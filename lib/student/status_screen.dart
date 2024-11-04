import 'package:borrow_movie/login_student.dart';
import 'package:borrow_movie/main.dart';
import 'package:borrow_movie/student/home_screen.dart';
import 'package:borrow_movie/student/main_screen.dart';
import 'package:flutter/material.dart';

class StatusScreen extends StatelessWidget {
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
    // Retrieve the data from the route arguments
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD2C5B0),
        title: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.black),
            SizedBox(width: 8),
            Text('STATUS', style: TextStyle(color: Colors.black)),
            Expanded(child: Container()),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      endDrawer: createDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: data != null && data.isNotEmpty
            ? DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    _buildStatusTab(data),
                    FilledButton(
                        onPressed: () {
                          // Simulate successful login and navigate to HomeScreen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
                (Route<dynamic> route) => false, // Remove all previous routes
              );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.blue), // Background color
                          foregroundColor: MaterialStateProperty.all(
                              Colors.white), // Text color
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 32.0)), // Padding
                          elevation: MaterialStateProperty.all(5), // Elevation
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12.0), // Border radius
                          )),
                        ),
                        child: Text('Home'))
                  ],
                ),
              )
            : Center(
                child:
                    Text('No data available.', style: TextStyle(fontSize: 18)),
              ),
      ),
    );
  }

  Widget _buildStatusTab(Map<String, dynamic> data) {
    return SingleChildScrollView(
      child: Center(
        child: Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${data['mo_name']}',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text('Borrow Date: ${data['borrow_date']}',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text('Return Date: ${data['return_date']}',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text('Borrower Name: ${data['bor_name']}',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('Status: ', style: TextStyle(fontSize: 16)),
                    Text('${data['status']}',
                        style: TextStyle(fontSize: 16, color: Colors.yellow)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
