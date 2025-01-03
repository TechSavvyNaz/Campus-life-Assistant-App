import 'dart:async';
import 'package:flutter/material.dart';
import 'package:campuslife_assistant/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the login screen after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF25313B), // Set the background color
      body: Center(
        child: Image.asset(
          'images/img.png', // Replace with the path to your logo
          width: double.infinity, // Make the logo fill the screen width
          height: double.infinity, // Make the logo fill the screen height
          fit: BoxFit.contain, // Adjust the logo proportionally to fit within the screen
        ),
      ),
    );
  }
}
