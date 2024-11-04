import 'package:borrow_movie/admin/Ad_borrow_screen.dart';
import 'package:borrow_movie/admin/Ad_dashboard_screen.dart';
import 'package:borrow_movie/admin/Ad_history_screen.dart';
import 'package:borrow_movie/admin/Ad_home_screen.dart';
import 'package:borrow_movie/admin/Ad_return_screen.dart';
import 'package:borrow_movie/student/borrow_screen.dart';
import 'package:borrow_movie/student/history_screen.dart';
import 'package:borrow_movie/student/home_screen.dart';
import 'package:borrow_movie/student/status_screen.dart';
import 'package:flutter/material.dart';

class AdMainScreen extends StatefulWidget {
  @override
  _AdMainScreenState createState() => _AdMainScreenState();
}

class _AdMainScreenState extends State<AdMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    AdHomeScreen(),
    AdBorrowScreen(),
    AdDashboardScreen(),
    AdReturnScreen(),
    AdHistoryScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.playlist_add_check_circle_rounded), label: 'Return'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'), // Profile tab if needed
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}