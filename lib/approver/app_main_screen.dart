import 'package:borrow_movie/approver/app_borrow_screen.dart';
import 'package:borrow_movie/approver/app_dashboard_screen.dart';
import 'package:borrow_movie/approver/app_history_screen.dart';
import 'package:borrow_movie/approver/app_home_screen.dart';
import 'package:borrow_movie/approver/app_request_screen.dart';
import 'package:flutter/material.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    AppHomeScreen(),
    AppBorrowScreen(),
    AppDashboardScreen(),
    AppRequestScreen(),
    AppHistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Show the current screen
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Borrow'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.playlist_add_check_circle_rounded), label: 'Request'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'), // Profile tab if needed
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}