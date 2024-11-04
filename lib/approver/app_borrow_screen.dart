import 'package:borrow_movie/login_student.dart';
import 'package:flutter/material.dart';

class AppBorrowScreen extends StatefulWidget {
  const AppBorrowScreen({super.key});

  @override
  State<AppBorrowScreen> createState() => _AppBorrowScreenState();
}

class _AppBorrowScreenState extends State<AppBorrowScreen> {
  final List<Map<String, dynamic>> movies = [
    {'title': 'John Wick', 'status': 'AVAILABLE', 'image': 'john_wick.png'},
    {'title': 'Venom 2', 'status': 'PENDING', 'image': 'venom_2.png'},
    {
      'title': 'Mission: Impossible 6',
      'status': 'DISABLE',
      'image': 'mission_impossible_6.png'
    },
    {
      'title': 'Fast and Furious 9',
      'status': 'AVAILABLE',
      'image': 'fast_and_furious_9.png'
    },
    {
      'title': 'The Amazing Spider-Man',
      'status': 'AVAILABLE',
      'image': 'amazing_spiderman.png'
    },
    {
      'title': 'Transformers',
      'status': 'BORROWED',
      'image': 'transformers.png'
    },
  ];

  String? category; // Nullable category
  final List<String> cate = [
    'Adventure',
    'Action',
    'Comedy',
    'Fantasy',
    'Horror',
    'Romance',
    'Sci-Fi',
    'Thriller',
    'War',
  ];

  @override
  void initState() {
    super.initState();
    // Default category to a fallback value if no category is passed
    category = 'Adventure';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (data != null && data['categorie'] != null && category == 'Adventure') {
      // Set only if category is still at its initial default
      category = data['categorie'];
    }
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
      backgroundColor: Color(0xFFE5DCC9),
      appBar: AppBar(
        backgroundColor: Color(0xFFD2C5B0),
        title: Row(
          children: [
            Icon(Icons.shopping_cart, color: Colors.black),
            SizedBox(width: 8),
            Text('Borrow', style: TextStyle(color: Colors.black)),
            Spacer(),
          ],
        ),
      ),
      endDrawer: createDrawer(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search movie name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButton<String>(
              value: category,
              items: cate.map((String cate) {
                return DropdownMenuItem<String>(
                  value: cate,
                  child: Text(cate),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  category = newValue!;
                });
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return _buildMovieCard(movies[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(Map<String, dynamic> movie) {
    Color statusColor;
    switch (movie['status']) {
      case 'AVAILABLE':
        statusColor = Colors.green;
        break;
      case 'PENDING':
        statusColor = Colors.orange;
        break;
      case 'DISABLE':
        statusColor = Colors.red;
        break;
      case 'BORROWED':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.black;
    }

    return InkWell(
      onTap: null,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(
                'assets/images/${movie['image']}',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['title'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'ID: 001',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      movie['status'],
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}