import 'package:borrow_movie/student/status_screen.dart';
import 'package:flutter/material.dart';

class BorrowDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

        DateTime _today = DateTime.now();
DateTime _return = _today.add(Duration(days: 7));

int _return_day = _return.day;
int _return_month = _return.month;
int _return_year = _return.year;

    return Scaffold(
      backgroundColor: Color(0xFFE5DCC9),
      appBar: AppBar(
        backgroundColor: Color(0xFFD2C5B0),
        title: Row(
          children: [
            Icon(Icons.shopping_cart, color: Colors.black),
            SizedBox(width: 8),
            Text('Borrow', style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage('assets/images/${data['image']}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(height: 16),
              Text(
                'Name : ${data['name']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Borrow Date : ${_today.day}/${_today.month}/${_today.year}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Return Date : $_return_day/$_return_month/$_return_year',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Back'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      minimumSize: Size(120, 40),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StatusScreen(),
                settings: RouteSettings(
                  arguments: <String, dynamic>{
                    'mo_name': '${data['name']}',
                    'borrow_date': '${_today.day}/${_today.month}/${_today.year}',
                    'return_date': '$_return_day/$_return_month/$_return_year',
                    'bor_name': 'John',
                    'status': 'Pending',
                  },
                ),
              ),
            );
                    },
                    child: Text('Borrow'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(120, 40),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
