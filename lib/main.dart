import 'package:flutter/material.dart';
import 'package:my_app/config/theme.dart';
import 'package:my_app/pages/auth_screens/biometric_auth_screen.dart';
import 'package:my_app/pages/todo/todo_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_state.dart';
import 'pages/auth_screens/login_page.dart';
import 'pages/auth_screens/set_passcode.dart';
import 'pages/auth_screens/login_otp_1.dart';
import 'pages/auth_screens/login_biometric.dart';
import 'pages/auth_screens/login_otp_1.dart';
import 'pages/documents/documents.dart';
import 'pages/company_data/companydata.dart';
import 'pages/chats/chats.dart';
import 'pages/home_screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState()..initializeAuth(token),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      home: Consumer<AppState>(
        builder: (context, appState, _) {
          if (!appState.isLoggedIn) {
            return const LoginPage();
          }

          if (!appState.biometricSetupDone) {
            return LoginBiometric();
          }

          // If user has set passcode, authenticate by passcode
          if (appState.passcodeSet && !appState.passcodePassed) {
            return LoginPasscode();
          }

          // If user has enabled biometric, authenticate by biometric
          if (!appState.passcodeSet && !appState.biometricPassed) {
            return BiometricAuthScreen();
          }

          return const BottomNavScreen(); // after authentication success
        },
      ),
    );
  }
}

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    FilesScreen(),
    Chats(),
    TodoList(),
    CompanyDataPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final appState = Provider.of<AppState>(context, listen: false);
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.grey[200],
      //   title: Image.asset(
      //     'images/adm_logo.png',
      //     width: 150.0,
      //     height: 80.0,
      //     errorBuilder: (context, error, stackTrace) => const SizedBox(
      //       width: 150,
      //       height: 80,
      //       child: Center(child: Text('ADM Logo')),
      //     ),
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.notifications),
      //       color: Colors.blueAccent,
      //       onPressed: () {
      //         ScaffoldMessenger.of(context).showSnackBar(
      //           const SnackBar(content: Text('No new notifications')),
      //         );
      //       },
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
      //       child: Text(
      //         '${appState.userData?['user']?['name'] ?? ''} '
      //         '${appState.userData?['user']?['surname'] ?? ''}',
      //         style: const TextStyle(color: Colors.black),
      //       ),
      //     ),
      //     PopupMenuButton<String>(
      //       onSelected: (value) async {
      //         if (value == 'logout') {
      //           // 1) clear your auth state
      //           await appState.logout();
      //           // 2) and then blow away everything in the Navigator
      //           Navigator.of(context).pushAndRemoveUntil(
      //             MaterialPageRoute(builder: (_) => LoginPage()),
      //             (route) => false,
      //           );
      //         }
      //       },
      //       icon: const CircleAvatar(
      //         backgroundImage: AssetImage('images/user_profile.png'),
      //       ),
      //       itemBuilder: (BuildContext context) => const [
      //         PopupMenuItem(value: 'profile', child: Text('Profile')),
      //         PopupMenuItem(value: 'settings', child: Text('Settings')),
      //         PopupMenuItem(value: 'logout', child: Text('Logout')),
      //       ],
      //     ),
      //     const SizedBox(width: 10),
      //   ],
      // ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[200],
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_copy_outlined),
            label: 'Files',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add_sharp),
            label: 'To-do',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add_sharp),
            label: 'Billing',
          ),
        ],
      ),
    );
  }
}
