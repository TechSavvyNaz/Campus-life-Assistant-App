import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'class_schedule_screen.dart';  // Import the class schedule screen

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2C3E50), // Darker blue for the app bar
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('images/img.png', height: 60),
              Text('Campus Assistant', style: TextStyle(color: Colors.white)),
              IconButton(
                icon: Icon(Icons.account_circle, color: Colors.white),
                onPressed: () {
                  // Placeholder for user profile navigation
                },
              ),
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Favorites'),
              Tab(text: 'Notifications'),
              Tab(text: 'Class Schedule'),
            ],
            indicatorColor: Color(0xFF72D1F6),  // Light blue indicator for tabs
            labelColor: Color(0xFF72D1F6),  // Light blue label color
            unselectedLabelColor: Colors.white, // White color for unselected tabs
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(user?.displayName ?? "User", style: TextStyle(color: Colors.white)),
                accountEmail: Text(user?.email ?? "", style: TextStyle(color: Colors.white)),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Color(0xFF72D1F6),  // Light blue for profile picture
                  child: Text(user?.email?.substring(0, 1) ?? 'U', style: TextStyle(color: Colors.white)),
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Logout'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Placeholder for home
            Center(child: Text("Home Page", style: TextStyle(color: Colors.white, fontSize: 20))),

            // Placeholder for favorites
            Center(child: Text("Favorites Page", style: TextStyle(color: Colors.white, fontSize: 20))),

            // Placeholder for notifications
            Center(child: Text("Notifications Page", style: TextStyle(color: Colors.white, fontSize: 20))),

            // Class Schedule Screen
            ClassScheduleScreen(),  // Integrated Class Schedule Screen
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFF2C3E50), // Darker background for bottom bar
          selectedItemColor: Color(0xFF72D1F6), // Light blue color for selected items
          unselectedItemColor: Colors.white, // White color for unselected items
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
