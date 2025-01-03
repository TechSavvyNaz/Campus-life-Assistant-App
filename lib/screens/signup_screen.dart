import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart'; // Ensure the file path is correct

class SignupScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7FCFF), // Light background color
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50), // Add some top padding
              Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF25313B), // Dark blue color for heading
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Sign up to get started!',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xFF7ED9EB), // Cyan accent
                ),
              ),
              SizedBox(height: 40),
              _buildTextField(
                controller: _nameController,
                labelText: 'Name',
                icon: Icons.person,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                icon: Icons.email,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _passwordController,
                labelText: 'Password',
                icon: Icons.lock,
                isPassword: true,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25313B), // Dark blue button color
                  foregroundColor: Colors.white, // White text
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _register(context),
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  'Already have an account? Log in',
                  style: TextStyle(color: Color(0xFF004F5D)), // Light blue link color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Color(0xFF004F5D)), // Light blue text
        prefixIcon: Icon(icon, color: Color(0xFF25313B)), // Cyan icon
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF25313B)), // Cyan border
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFBCE4E9)), // Light cyan border
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white, // White background
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    try {
      // Attempt to sign up the new user with Firebase
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Optional: Update the display name of the Firebase User
      await userCredential.user!.updateProfile(displayName: _nameController.text.trim());
      await userCredential.user!.reload();

      // Navigate to the login screen after successful signup
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Handle the error if the email is already in use
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('This email is already in use.')),
        );
      } else {
        // Handle other FirebaseAuth errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign up: ${e.message}')),
        );
      }
    } catch (e) {
      // Handle any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up')),
      );
    }
  }
}
