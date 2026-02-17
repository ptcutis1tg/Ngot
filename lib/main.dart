import 'package:flutter/material.dart';
import 'package:flutter_application_1/debug.dart';
import 'package:flutter_application_1/firstscreen/dashboard_screen.dart';
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

const bool RESET_APP_DATA = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DebugHelper.printAllData();
  await initializeUserProfile();
  await AppInitializer.initialize(resetData: RESET_APP_DATA);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => BackupProvider()),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
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

class DailyExpenseApp extends StatelessWidget {
  const DailyExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appSettings = context.watch<AppSettingsProvider>();

    return MaterialApp(
      title: 'Daily Expense Diary',
      debugShowCheckedModeBanner: false,
      themeMode: appSettings.darkMode ? ThemeMode.dark : ThemeMode.light,
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2ECC71),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
      ),
      home: const MainNavigationScreen(),
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
      context.read<AppSettingsProvider>().loadSettings();
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
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Wallets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 16),
        child: RawMaterialButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              barrierDismissible: true,
              builder: (dialogContext) => Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
