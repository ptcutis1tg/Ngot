import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/debug.dart';
import 'package:flutter_application_1/firstscreen/dashboard_screen.dart' deferred as dashboard;
import 'package:flutter_application_1/firstscreen/settings_screen.dart' deferred as settings;
import 'package:flutter_application_1/firstscreen/statistic_screen.dart' deferred as statistic;
import 'package:flutter_application_1/firstscreen/wallet_screen.dart' deferred as wallet;
import 'package:flutter_application_1/firstscreen/widget/addtransaction.dart';
import 'package:flutter_application_1/models/transactionproflie.dart';
import 'package:flutter_application_1/providers/app_settings_provider.dart';
import 'package:flutter_application_1/providers/app_translations.dart';
import 'package:flutter_application_1/providers/backup_provider.dart';
import 'package:flutter_application_1/providers/currency_provider.dart';
import 'package:flutter_application_1/providers/transaction_provider.dart';
import 'package:flutter_application_1/providers/userprofileprovider.dart';
import 'package:flutter_application_1/reset.dart';
import 'package:flutter_application_1/supabase_config.dart';
import 'package:flutter_application_1/router/app_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const bool resetAppData = false;
const bool resetOnboardingFlowOnly = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PaintingBinding.instance.imageCache.maximumSize = 20;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 20 << 20;

  try {
    await dotenv.load(fileName: ".env");
    SupabaseConfig.validate();

    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );
    AppRouter.initializeAuthListener();
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Lỗi khởi tạo Supabase: $e\n\nVui lòng đảm bảo bạn đã cấu hình file .env và chạy app với cờ --dart-define-from-file=.env',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ),
      ),
    ));
    return;
  }

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
  await prefs.setString('userFullName', '');
  await prefs.setString('userBio', '');
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

    return MaterialApp.router(
      title: 'Daily Expense Diary',
      debugShowCheckedModeBanner: false,
      themeMode: appSettings.darkMode ? ThemeMode.dark : ThemeMode.light,
      locale: appSettings.locale,
      supportedLocales: const [
        Locale('vi'),
        Locale('en'),
        Locale('ko'),
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
          surface: Color(0xFF0C3827),
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF031F16),
        canvasColor: const Color(0xFF031F16),
        cardColor: const Color(0xFF0C3827),
        dividerColor: const Color(0xFF11653F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF031F16),
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
          tileColor: Color(0xFF0C3827),
          iconColor: Colors.white70,
          textColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF032717),
          selectedItemColor: Color(0xFF1CF07B),
          unselectedItemColor: Color(0xFF98A99F),
          selectedIconTheme: IconThemeData(color: Color(0xFF1CF07B)),
          unselectedIconTheme: IconThemeData(color: Color(0xFF98A99F)),
          type: BottomNavigationBarType.fixed,
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: Color(0xFF0C3827),
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
      routerConfig: AppRouter.router,
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

  Widget _buildDeferred(int index) {
    switch (index) {
      case 0:
        return FutureBuilder(
          future: dashboard.loadLibrary(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return dashboard.DashboardScreen();
            }
            return const Center(child: CircularProgressIndicator(color: Color(0xFF2ECC71)));
          },
        );
      case 1:
        return FutureBuilder(
          future: statistic.loadLibrary(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return statistic.StatisticsScreen();
            }
            return const Center(child: CircularProgressIndicator(color: Color(0xFF2ECC71)));
          },
        );
      case 2:
        return FutureBuilder(
          future: wallet.loadLibrary(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return wallet.WalletScreen();
            }
            return const Center(child: CircularProgressIndicator(color: Color(0xFF2ECC71)));
          },
        );
      case 3:
        return FutureBuilder(
          future: settings.loadLibrary(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return settings.SettingsScreen();
            }
            return const Center(child: CircularProgressIndicator(color: Color(0xFF2ECC71)));
          },
        );
      default:
        return const SizedBox();
    }
  }

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
    final languageCode =
        context.watch<AppSettingsProvider>().languageCode;

    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          if (_selectedIndex != index) {
            setState(() => _selectedIndex = index);
          }
        },
        children: [
          _buildDeferred(0),
          _buildDeferred(1),
          _buildDeferred(2),
          _buildDeferred(3),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF032717),
          border: Border(top: BorderSide(color: Color(0xFF0E5B3A), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF1CF07B),
          unselectedItemColor: const Color(0xFF98A99F),
          selectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              label: AppTranslations.getText(languageCode, 'nav_home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart_rounded),
              label: AppTranslations.getText(languageCode, 'nav_report'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_balance_wallet_rounded),
              label: AppTranslations.getText(languageCode, 'nav_wallet'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_rounded),
              label: AppTranslations.getText(languageCode, 'nav_settings'),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: RawMaterialButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (dialogContext) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              elevation: 0,
              child: AddTransactionWidget(
                onAdd: (TransactionProfile tx) {
                  context.read<TransactionProvider>().addTransaction(tx);
                },
                onClose: () => Navigator.of(dialogContext).pop(),
              ),
            ),
          );
        },
        fillColor: const Color(0xFF1CF07B),
        shape: const CircleBorder(),
        elevation: 8,
        constraints: const BoxConstraints.tightFor(width: 78, height: 78),
        child: const Icon(Icons.add, size: 44, color: Color(0xFF002A17)),
      ),
    );
  }
}
