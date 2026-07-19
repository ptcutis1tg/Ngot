import 'package:flutter/material.dart';
import 'dashboard_components/dashboard_components.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF052E1F),
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF031F16),
                Color(0xFF052E1F),
              ],
            ),
          ),
          child: SafeArea(child: _DashboardBody()),
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopBar(),
          SizedBox(height: 32),
          ProfileSection(),
          SizedBox(height: 26),
          BalanceCard(),
          SizedBox(height: 32),
          RecentHeader(),
          SizedBox(height: 8),
          RecentList(),
        ],
      ),
    );
  }
}
