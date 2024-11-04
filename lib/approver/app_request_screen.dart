import 'package:borrow_movie/login_student.dart';
import 'package:flutter/material.dart';

class AppRequestScreen extends StatefulWidget {
  const AppRequestScreen({super.key});

  @override
  State<AppRequestScreen> createState() => _AppRequestScreenState();
}

class _AppRequestScreenState extends State<AppRequestScreen> {
  final List<String> names = [
    'Somsak Jaidee',
    'Student 1',
    'Student 2',
    'Student 3',
    'Student 4',
    'Student 5',
    'Student 6',
    'Student 7',
    'Student 8',
    'Student 9',
    'Student 10',
  ];

  int _selectedIndex = 0;

  // Pop-up method
  void _showPopup(
    String movieName,
    String borrowerName,
    String borrowDate,
    String returnDate,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Color.fromARGB(255, 227, 226, 225),
          contentPadding: const EdgeInsets.all(15),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Details',
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Make corners round
                child: Image.asset(
                  'assets/images/john_wick.png',
                  height: 200, // Set image height
                  width: 200, // Set image width
                  fit: BoxFit.cover, // Make image cover the area
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Movie Name: $movieName',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 8),
              // Borrower details with white background
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Borrower Name: $borrowerName',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Borrow Date: $borrowDate',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Return Date: $returnDate',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Reject',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Approve',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

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
      appBar: AppBar(
        backgroundColor: Color(0xFFD2C5B0),
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'REQUEST',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ),
      ),
      endDrawer: createDrawer(context),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: names.length,
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: const Color.fromARGB(255, 255, 181, 85),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          'Name: ${names[index]}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 71, 50, 5),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.play_circle_fill,
                          color: Color.fromARGB(255, 255, 96, 17),
                          size: 40,
                        ),
                        onPressed: () {
                          _showPopup(
                            'John Wick',
                            names[index],
                            '20/10/2024',
                            '25/10/2024',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}