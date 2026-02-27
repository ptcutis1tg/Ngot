import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_application_1/debug.dart';
import 'package:flutter_application_1/firstscreen/dashboard_screen.dart';
import 'package:flutter_application_1/firstscreen/onboarding_flow.dart';
import 'package:flutter_application_1/firstscreen/settings_screen.dart';
import 'package:flutter_application_1/firstscreen/statistic_screen.dart';
import 'package:flutter_application_1/firstscreen/wallet_screen.dart';
import 'package:flutter_application_1/firstscreen/widget/addtransaction.dart';
import 'package:flutter_application_1/models/transactionproflie.dart';
import 'package:flutter_application_1/providers/app_settings_provider.dart';
import 'package:flutter_application_1/providers/backup_provider.dart';
import 'package:flutter_application_1/providers/currency_provider.dart';
import 'package:flutter_application_1/providers/transaction_provider.dart';
import 'package:flutter_application_1/providers/userprofileprovider.dart';
import 'package:flutter_application_1/reset.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const bool resetAppData = false;
const bool resetOnboardingFlowOnly = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    DebugHelper.printAllData();
  }

  await initializeUserProfile();
  await AppInitializer.initialize(resetData: resetAppData);
  await resetOnboardingIfNeeded();
  final appSettingsProvider = AppSettingsProvider();
  await appSettingsProvider.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => BackupProvider()),
        ChangeNotifierProvider(create: (_) => appSettingsProvider),
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
      ],
      child: const DailyExpenseApp(),
    ),
  );
}

Future<void> initializeUserProfile() async {
  final prefs = await SharedPreferences.getInstance();
  final exists = prefs.getBool('userProfileExists') ?? false;
  if (exists) return;

  await prefs.setBool('userProfileExists', true);
  await prefs.setString('userName', '');
  await prefs.setString('userEmail', '');
  await prefs.setString('userAvatar', 'assets/user/anonymous.jpg');
}

Future<void> resetOnboardingIfNeeded() async {
  if (!resetOnboardingFlowOnly) return;
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('onboarding_completed');
}

class DailyExpenseApp extends StatelessWidget {
  const DailyExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appSettings = context.watch<AppSettingsProvider>();

    return MaterialApp(
      title: 'Daily Expense Diary',
      debugShowCheckedModeBanner: false,
      themeMode: appSettings.darkMode ? ThemeMode.dark : ThemeMode.light,
      locale: appSettings.locale,
      supportedLocales: const [
        Locale('vi'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2ECC71),
          primary: const Color(0xFF2ECC71),
          secondary: const Color(0xFF27AE60),
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2ECC71),
          secondary: Color(0xFF27AE60),
          surface: Color(0xFF121212),
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF000000),
        canvasColor: const Color(0xFF000000),
        cardColor: const Color(0xFF1B1B1B),
        dividerColor: const Color(0xFF2A2A2A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF000000),
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        listTileTheme: const ListTileThemeData(
          tileColor: Color(0xFF1B1B1B),
          iconColor: Colors.white70,
          textColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF101010),
          selectedItemColor: Color(0xFF2ECC71),
          unselectedItemColor: Colors.white70,
          selectedIconTheme: IconThemeData(color: Color(0xFF2ECC71)),
          unselectedIconTheme: IconThemeData(color: Colors.white70),
          type: BottomNavigationBarType.fixed,
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: Color(0xFF1E1E1E),
          titleTextStyle: TextStyle(color: Colors.white),
          contentTextStyle: TextStyle(color: Colors.white70),
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: const AppLaunchGate(child: MainNavigationScreen()),
    );
  }
}

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MainNavigationBody();
  }
}

class _MainNavigationBody extends StatefulWidget {
  const _MainNavigationBody();

  @override
  State<_MainNavigationBody> createState() => _MainNavigationBodyState();
}

class _MainNavigationBodyState extends State<_MainNavigationBody> {
  int _selectedIndex = 0;
  late final PageController _pageController;

  static const List<Widget> _pages = [
    DashboardScreen(),
    StatisticsScreen(),
    WalletScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileProvider>().loadProfile();
      context.read<TransactionProvider>().loadTransactions();
      context.read<BackupProvider>().loadConfig();
      context.read<CurrencyProvider>().loadCurrency();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isVietnamese =
        context.watch<AppSettingsProvider>().languageCode == 'vi';

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          if (_selectedIndex != index) {
            setState(() => _selectedIndex = index);
          }
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor:
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            label: isVietnamese ? 'Trang chủ' : 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart_outlined),
            label: isVietnamese ? 'Thống kê' : 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            label: isVietnamese ? 'Ví tiền' : 'Wallets',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            label: isVietnamese ? 'Cài đặt' : 'Settings',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: EdgeInsets.zero,
        child: RawMaterialButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              barrierDismissible: true,
              builder: (dialogContext) => Dialog(
                backgroundColor: Colors.transparent,
                insetPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: AddTransactionWidget(
                  onAdd: (TransactionProfile tx) {
                    context.read<TransactionProvider>().addTransaction(tx);
                  },
                  onClose: () => Navigator.of(dialogContext).pop(),
                ),
              ),
            );
          },
          fillColor: Theme.of(context).colorScheme.primary,
          shape: const CircleBorder(),
          elevation: 6,
          constraints: const BoxConstraints.tightFor(width: 64, height: 64),
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
    );
  }
}
