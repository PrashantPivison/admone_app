import 'package:flutter/material.dart';
import 'package:my_app/home_page.dart';
import 'pages/documents/documents.dart';
import 'pages/company_data/companydata.dart';
import 'pages/company_data/companydata_details.dart';
import 'pages/chats/chats.dart';

import 'pages/auth_screens/login_page.dart'; // If needed

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: CompanydataDetails(),
      home: BottomNavScreen(),
    );
  }
}

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    DocumentsPage(),
    ChatsPage(),
    CompanyDataPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Image.asset(
          'images/adm_logo.png',
          width: 150.0,
          height: 80.0,
        ),
        actions: [
          // Notification Icon
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.blueAccent, // Fix color issue
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),

          // User Name with Padding
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'User Name',
              style: TextStyle(color: Colors.black), // Adjust color as needed
            ),
          ),

          // User Profile Dropdown
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushReplacementNamed(
                    context, '/login'); // Navigate properly
              }
            },
            icon: const CircleAvatar(
              backgroundImage: AssetImage('images/user_profile.png'),
            ),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'profile', child: Text('Profile')),
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),

          const SizedBox(width: 10), // Add some spacing
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[200],
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed, // Ensures all icons are visible
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: "Documents",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: "Company Data",
          ),
        ],
      ),
    );
  }
}
