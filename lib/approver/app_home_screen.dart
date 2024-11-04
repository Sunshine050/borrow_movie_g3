import 'package:borrow_movie/approver/app_borrow_screen.dart';
import 'package:borrow_movie/login_student.dart';
import 'package:flutter/material.dart';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({super.key});

  @override
  State<AppHomeScreen> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> {
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
                // Simulate successful login and navigate to HomeScreen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false, // Remove all previous routes
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
      appBar: AppBar(
        backgroundColor: Color(0xFFD2C5B0),
        title: Row(
          children: [
            Icon(Icons.home, color: Colors.black),
            SizedBox(width: 8),
            Text('HOME', style: TextStyle(color: Colors.black)),
            Expanded(child: Container()),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      endDrawer: createDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: [
                'Adventure',
                'Action',
                'Comedy',
                'Fantasy',
                'Horror',
                'Romance',
                'Sci-Fi',
                'Thriller',
                'War'
              ].map((genre) => _buildCategoryItem(genre, context)).toList(),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recommended',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildRecommendedItem('recommended1.png'),
                  _buildRecommendedItem('recommended2.png'),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Borrow'),
      //     BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Status'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //   ],
      // ),
    );
  }

  Widget _buildCategoryItem(String genre, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppBorrowScreen(),
            settings: RouteSettings(
              arguments: <String, dynamic>{
                'categorie': '$genre',
              },
            ),
          ),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/$genre.png',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            Text(genre),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedItem(String imageName) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 8),
      child: Image.asset(
        'assets/images/$imageName',
        width: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}