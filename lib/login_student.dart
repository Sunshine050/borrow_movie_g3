import 'package:borrow_movie/admin/Ad_main_screen.dart';
import 'package:borrow_movie/approver/app_main_screen.dart';
import 'package:borrow_movie/main.dart';
import 'package:borrow_movie/student/main_screen.dart';
import 'package:borrow_movie/student/regis_student.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.png', // Replace with your image asset
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Sign in to continue',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'username',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: _username,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'password',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: _password,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('LOGIN'),
                    onPressed: () {
                      setState(
                        () {
                          if (_username.text == "ad" && _password.text == "ad") {
                            // Simulate successful login and navigate to HomeScreen
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdMainScreen()),
                              (Route<dynamic> route) =>
                                  false, // Remove all previous routes
                            );
                          } else if (_username.text == "ap" && _password.text == "ap") {
                            // Simulate successful login and navigate to HomeScreen
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AppMainScreen()),
                              (Route<dynamic> route) =>
                                  false, // Remove all previous routes
                            );
                          } else if (_username.text == "st" && _password.text == "st") {
                            // Simulate successful login and navigate to HomeScreen
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen()),
                              (Route<dynamic> route) =>
                                  false, // Remove all previous routes
                            );
                          } else {}
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Text(
                        "don't have an account?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      TextButton(
                        child: Text(
                          "create a new account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisStudent()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
