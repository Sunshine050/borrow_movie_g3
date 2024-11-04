import 'package:borrow_movie/login_student.dart';
import 'package:flutter/material.dart';

class AppDashboardScreen extends StatefulWidget {
  const AppDashboardScreen({super.key});

  @override
  State<AppDashboardScreen> createState() => _AppDashboardScreenState();
}

class _AppDashboardScreenState extends State<AppDashboardScreen> {
  int _selectedIndex = 0;

  int _availableCount = 5;
  int _pendingCount = 4;
  int _disableCount = 6;
  int _borrowedCount = 6;
  int _allMoviesCount = 21;

  // Method to create a drawer
  Widget createDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.lightBlue),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/Action.png',
                  width: 100,
                ),
                const Text('Header'),
              ],
            ),
          ),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              icon: Icon(Icons.logout),
              label: Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFD2C5B0),
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'DASHBOARD',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ),
      ),
      endDrawer: createDrawer(context),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Opacity(
              opacity: 0.3, // Adjust opacity for visibility
              child: Image.asset(
                'assets/images/background.png', // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content on top of the background image
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 50,
                    mainAxisSpacing: 30,
                    children: [
                      buildDashboardCard(
                          'AVAILABLE',
                          _availableCount.toString(),
                          const Color.fromARGB(255, 0, 187, 6),
                          Text('$_availableCount').selectionColor),
                      buildDashboardCard(
                          'PENDING',
                          _pendingCount.toString(),
                          const Color.fromARGB(255, 255, 153, 0),
                          Text('$_availableCount').selectionColor),
                      buildDashboardCard(
                          'DISABLE',
                          _disableCount.toString(),
                          const Color.fromARGB(255, 255, 0, 25),
                          Text('$_availableCount').selectionColor),
                      buildDashboardCard(
                          'BORROWED',
                          _borrowedCount.toString(),
                          const Color.fromARGB(255, 0, 140, 255),
                          Text('$_availableCount').selectionColor),
                      // buildDashboardCard('ALL MOVIES', _allMoviesCount.toString(), const Color.fromARGB(255, 67, 67, 67), Text('$_availableCount').selectionColor),
                    ],
                  ),
                ),
                Center(
                  child: buildDashboardCardAll(
                      'ALL MOVIES',
                      _allMoviesCount.toString(),
                      const Color.fromARGB(255, 67, 67, 67),
                      Text('$_availableCount').selectionColor),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDashboardCard(
      String title, String count, Color? bgColor, Color? textColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            count,
            style: TextStyle(
              color: textColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDashboardCardAll(
      String title, String count, Color? bgColor, Color? textColor) {
    return Container(
      width: 170, // Set a specific width for the card
      height: 170, // Set a specific height for the card
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15, // Adjusted font size for the title
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Adjusted spacing
          Text(
            count,
            style: TextStyle(
              color: textColor,
              fontSize: 28, // Adjusted font size for the count
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}