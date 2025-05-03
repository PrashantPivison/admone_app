// import 'package:flutter/material.dart';
// import 'package:my_app/config/theme.dart';
// import 'package:my_app/pages/auth_screens/biometric_auth_screen.dart';
// import 'package:my_app/pages/todo/todo_list.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'app_state.dart';
// import 'pages/auth_screens/login_page.dart';
// import 'pages/auth_screens/set_passcode.dart';
// import 'pages/auth_screens/login_otp_1.dart';
// import 'pages/auth_screens/login_biometric.dart';
// import 'pages/auth_screens/login_otp_1.dart';
// import 'pages/documents/documents.dart';
// import 'pages/company_data/companydata.dart';
// import 'pages/chats/chats.dart';
// import 'pages/home_screens/home_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('auth_token');

//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => AppState()..initializeAuth(token),
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: customTheme,
//       home: Consumer<AppState>(
//         builder: (context, appState, _) {
//           if (!appState.isLoggedIn) {
//             return const LoginPage();
//           }

//           if (!appState.biometricSetupDone) {
//             return LoginBiometric();
//           }

//           // If user has set passcode, authenticate by passcode
//           if (appState.passcodeSet && !appState.passcodePassed) {
//             return LoginPasscode();
//           }

//           // If user has enabled biometric, authenticate by biometric
//           if (!appState.passcodeSet && !appState.biometricPassed) {
//             return BiometricAuthScreen();
//           }

//           return const BottomNavScreen(); // after authentication success
//         },
//       ),
//     );
//   }
// }

// class BottomNavScreen extends StatefulWidget {
//   const BottomNavScreen({super.key});

//   @override
//   State<BottomNavScreen> createState() => _BottomNavScreenState();
// }

// class _BottomNavScreenState extends State<BottomNavScreen> {
//   int _currentIndex = 0;

//   final List<Widget> _pages = [
//     HomePage(),
//     FilesScreen(),
//     Chats(),
//     TodoList(),
//     CompanyDataPage(),
//   ];

//   void _onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final appState = Provider.of<AppState>(context, listen: false);
//     final appState = Provider.of<AppState>(context);
//     return Scaffold(
//       body: _pages[_currentIndex],
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child: Container(
//             color: Colors.white, // Background color moved here
//             child: BottomNavigationBar(
//               backgroundColor: Colors.transparent, // Important!
//               elevation: 0, // Removes default shadow
//               currentIndex: _currentIndex,
//               onTap: _onTabTapped,
//               type: BottomNavigationBarType.fixed,
//               items: const [
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.home_outlined),
//                   label: 'Home',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.folder_copy_outlined),
//                   label: 'Files',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.message_outlined),
//                   label: 'Message',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.playlist_add_sharp),
//                   label: 'To-do',
//                 ),
//                 // BottomNavigationBarItem(
//                 //   icon: Icon(Icons.playlist_add_sharp),
//                 //   label: 'Billing',
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       // bottomNavigationBar: Padding(
//       //   padding: const EdgeInsets.fromLTRB(15,0,15,20),
//       //   child: Container(
//       //     decoration: BoxDecoration(
//       //       borderRadius: BorderRadius.vertical(
//       //         top: Radius.circular(8), // Rounded top corners
//       //       ),
//       //     ),
//       //     child: BottomNavigationBar(
//       //       backgroundColor: Colors.white,
//       //       currentIndex: _currentIndex,
//       //       onTap: _onTabTapped,
//       //       type: BottomNavigationBarType.fixed,
//       //       items: const [
//       //         BottomNavigationBarItem(
//       //           icon: Icon(Icons.home_outlined),
//       //           label: 'Home',
//       //         ),
//       //         BottomNavigationBarItem(
//       //           icon: Icon(Icons.folder_copy_outlined),
//       //           label: 'Files',
//       //         ),
//       //         BottomNavigationBarItem(
//       //           icon: Icon(Icons.message_outlined),
//       //           label: 'Message',
//       //         ),
//       //         BottomNavigationBarItem(
//       //           icon: Icon(Icons.playlist_add_sharp),
//       //           label: 'To-do',
//       //         ),
//       //         BottomNavigationBarItem(
//       //           icon: Icon(Icons.playlist_add_sharp),
//       //           label: 'Billing',
//       //         ),
//       //       ],
//       //     ),
//       //   ),
//       // ),
//     );
//   }
// }

// lib/main.dart

// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_state.dart';
import 'pages/auth_screens/login_page.dart';
import 'pages/todo/todo_list.dart';
import 'pages/documents/documents.dart';
import 'pages/company_data/companydata.dart';
import 'pages/chats/chats.dart';
import 'config/theme.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Track whether we’ve been backgrounded
  bool _didBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final appState = Provider.of<AppState>(context, listen: false);

    if (state == AppLifecycleState.paused) {
      // we’re leaving the app
      _didBackground = true;
    }

    if (state == AppLifecycleState.resumed &&
        _didBackground &&
        appState.isLoggedIn &&
        appState.useDeviceAuth) {
      // only if we *did* background previously
      _didBackground = false;
      _authenticate();
    }
  }

  Future<void> _authenticate() async {
    try {
      final did = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      if (!did) SystemNavigator.pop();
    } on PlatformException {
      // no enrolled auth—let them in
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      home: Consumer<AppState>(
        builder: (ctx, appState, _) {
          if (!appState.isLoggedIn) {
            return const LoginPage();
          }
          // Logged in → always go straight to the main nav;
          // auth hack happens on lifecycle resume above.
          return const BottomNavScreen();
        },
      ),
    );
  }
}

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({Key? key}) : super(key: key);
  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;
  static const List<Widget> _pages = [
    HomePage(),
    FilesScreen(),
    Chats(),
    TodoList(),
    CompanyDataPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.folder_copy_outlined), label: 'Files'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.message_outlined), label: 'Message'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.playlist_add_sharp), label: 'To-do'),
            ],
          ),
        ),
      ),
    );
  }
}
