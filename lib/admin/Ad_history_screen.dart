import 'package:flutter/material.dart';
import 'package:borrow_movie/login_student.dart';

class AdHistoryScreen extends StatelessWidget {
  final List<Map<String, String>> historyData = [
    {
      'title': 'Harry Potter',
      'image': 'assets/images/Fantasy.png',
      'borrowDate': '19/10/2024',
      'returnDate': '26/10/2024',
      'borrowerName': 'John',
      'approver': 'Aj. Tommy',
      'recipient': 'Admin 1',
    },
    {
      'title': 'Fast and Furious',
      'image': 'assets/images/Action.png',
      'borrowDate': '20/10/2024',
      'returnDate': '27/10/2024',
      'borrowerName': 'Mark',
      'approver': 'Aj. Lisa',
      'recipient': 'Admin 2',
    },
    // Add more movie data as needed
  ];

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

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 120,
      color: Colors.grey,
      margin: EdgeInsets.symmetric(horizontal: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD2C5B0),
        leading: Icon(Icons.history, color: Colors.black),
        title: Text(
          'HISTORY',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: createDrawer(context),
      body: Container(
        color: Color(0xFFD2C5B0),
        child: Column(
          children: [
            Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 16),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(child: Text('Movie Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                  VerticalDivider(color: Colors.white, width: 1),
                  Expanded(child: Text('Borrow Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                  VerticalDivider(color: Colors.white, width: 1),
                  Expanded(child: Text('Return Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                  VerticalDivider(color: Colors.white, width: 1),
                  Expanded(child: Text('Borrower Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                  VerticalDivider(color: Colors.white, width: 1),
                  Expanded(child: Text('Approver Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                  VerticalDivider(color: Colors.white, width: 1),
                  Expanded(child: Text('Recipient of returned', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: historyData.length,
                itemBuilder: (context, index) {
                  final movie = historyData[index];
                  return Container(
                    height: 160, // Adjust this value to change the height of each item
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                movie['image'] ?? 'assets/images/default.png',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 4),
                              Text(movie['title'] ?? 'Unknown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                            ],
                          ),
                        ),
                        _buildVerticalDivider(),
                        Expanded(child: Center(child: Text(movie['borrowDate'] ?? 'N/A',style: TextStyle(fontSize: 10),))),
                        _buildVerticalDivider(),
                        Expanded(child: Center(child: Text(movie['returnDate'] ?? 'N/A',style: TextStyle(fontSize: 10),))),
                        _buildVerticalDivider(),
                        Expanded(child: Center(child: Text(movie['borrowerName'] ?? 'N/A',style: TextStyle(fontSize: 10),))),
                        _buildVerticalDivider(),
                        Expanded(child: Center(child: Text(movie['approver'] ?? 'N/A',style: TextStyle(fontSize: 10),))),
                        _buildVerticalDivider(),
                        Expanded(child: Center(child: Text(movie['recipient'] ?? 'N/A',style: TextStyle(fontSize: 10),))),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
