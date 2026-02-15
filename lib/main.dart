import 'package:flutter/material.dart';
import 'package:flutter_application_1/firstscreen/dashboard_screen.dart';
import 'package:flutter_application_1/providers/userprofileprovider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firstscreen/statistic_screen.dart';
import 'firstscreen/wallet_screen.dart';
import 'firstscreen/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/reset.dart';
import 'package:flutter_application_1/debug.dart';

// Flag để reset dữ liệu (thay đổi thành true nếu muốn reset)
const bool RESET_APP_DATA = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DebugHelper.printAllData();
  await initializeUserProfile();
  // Initialize với option reset
  await AppInitializer.initialize(resetData: RESET_APP_DATA);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
      ],
      child: const DailyExpenseApp(),
    ),
  );
}

Future<void> initializeUserProfile() async {
  final prefs = await SharedPreferences.getInstance();
  bool userProfileExists = prefs.getBool('userProfileExists') ?? false;

  if (!userProfileExists) {
    // Tạo UserProfile lần đầu tiên
    await prefs.setBool('userProfileExists', true);
    // Khởi tạo dữ liệu mặc định
    await prefs.setString('userName', '');
    await prefs.setString('userEmail', '');
    // Thêm các trường khác nếu cần
  }
}

class DailyExpenseApp extends StatelessWidget {
  const DailyExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Expense Diary',
      debugShowCheckedModeBanner: false,

      // 1. Thiết lập Theme theo tông màu của Mockup
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2ECC71), // Màu xanh lá chủ đạo
          primary: const Color(0xFF2ECC71),
          secondary: const Color(0xFF27AE60),
          surface: Colors.white,
        ),

        // 2. Thiết lập Font chữ (Sử dụng Inter hoặc Poppins cho hiện đại)
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),

        // Tùy chỉnh Appbar
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

      home: const MainNavigationScreen(),
    );
  }
}

// 3. Cấu trúc điều hướng chính (Bottom Navigation Bar)
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // Danh sách các màn hình tương ứng với Mockup
  static const List<Widget> _pages = [
    DashboardScreen(), // Màn hình 1
    StatisticsScreen(), // Màn hình báo cáo
    WalletScreen(), // Màn hình ví
    SettingsScreen(), // Màn hình cài đặt
  ];
  @override
  void initState() {
    super.initState();
    // Load profile khi app khởi động
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0), // Trượt nhẹ từ phải sang
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined), label: 'Statistics'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Wallets'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}

// Lớp Provider tạm thời để tránh lỗi build
class ExpenseProvider extends ChangeNotifier {}
