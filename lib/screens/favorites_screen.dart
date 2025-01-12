import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        backgroundColor: Color(0xFF25313B),
      ),
      body: Center(
        child: Text(
          "Your favorite items will appear here.",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
