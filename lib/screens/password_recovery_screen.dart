import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        backgroundColor: Color(0xFF1C5E74), // Updated to match the dark blue color
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Enter your email to receive a password reset link.',
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF004F5D), // Light blue text color
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Color(0xFF7ED9EB)), // Cyan-like color for labels
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF7ED9EB)), // Cyan border on focus
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFBCE4E9)), // Light cyan border
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1C5E74), // Dark blue button color
                foregroundColor: Colors.white, // White text color
                minimumSize: Size(double.infinity, 50), // Full-width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
              onPressed: () => _sendPasswordResetEmail(context),
              child: Text('Send Email'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendPasswordResetEmail(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password reset email sent! Check your email.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF004F5D), // Light blue background
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error sending password reset email: $e',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFFAA4E4E), // Error red background
        ),
      );
    }
  }
}
