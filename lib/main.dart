import 'package:flutter/material.dart';
import 'package:flutter_application_1/firstscreen/dashboard_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firstscreen/statistic_screen.dart';
import 'firstscreen/wallet_screen.dart';
import 'firstscreen/settings_screen.dart';

void main() async {
  runApp(
    // Sử dụng Provider để quản lý trạng thái sau này
    ChangeNotifierProvider(
      create: (context) => ExpenseProvider(),
      child: const DailyExpenseApp(),
    ),
  );
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
