// import 'package:flutter/material.dart';
// import 'package:my_app/pages/notification/notifications_page.dart';
// import 'package:provider/provider.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'app_state.dart';
// import 'pages/auth_screens/login_page.dart';
// import 'pages/todo/todo_list.dart';
// import 'pages/documents/documents.dart';
// import 'pages/company_data/companydata.dart';
// import 'pages/chats/chats.dart';
// import 'config/theme.dart';
// import 'pages/home_screens/home_page.dart';
// import 'backend/api_requests/fcm_token_api.dart';
// import 'pages/intro.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("📩 BG Message: ${message.messageId}");
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   final InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//   );

//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('auth_token');

//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => AppState()..initializeAuth(token),
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class IntroPage extends StatefulWidget {
//   const IntroPage({super.key});

//   @override
//   State<IntroPage> createState() => _IntroPageState();
// }

// class _IntroPageState extends State<IntroPage> {
//   double _opacity = 1.0;

//   @override
//   void initState() {
//     super.initState();
//     _startNavigation();
//   }

//   void _startNavigation() {
//     // Start fade-out after 2 seconds
//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() => _opacity = 0.0);
//     });

//     // Navigate after fade-out animation completes
//     Future.delayed(const Duration(milliseconds: 2400), () {
//       final isLoggedIn =
//           Provider.of<AppState>(context, listen: false).isLoggedIn;
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>
//               isLoggedIn ? const BottomNavScreen() : const LoginPage(),
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedOpacity(
//       duration: const Duration(milliseconds: 800),
//       opacity: _opacity,
//       child: Scaffold(
//         body: Stack(
//           fit: StackFit.expand,
//           children: [
//             Image.asset(
//               'assets/images/Splash.png',
//               fit: BoxFit.cover,
//             ),
//             const Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: EdgeInsets.only(bottom: 150),
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   final LocalAuthentication _localAuth = LocalAuthentication();
//   bool _didBackground = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _setupFCM();

//     // ✅ Force auth if app launches and user is logged in
//     Future.delayed(Duration.zero, () {
//       final appState = Provider.of<AppState>(context, listen: false);
//       print("appState.useDeviceAut->>>>>>> ${appState.useDeviceAuth}");
//       if (appState.isLoggedIn && appState.useDeviceAuth) {
//         _authenticate();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     final appState = Provider.of<AppState>(context, listen: false);

//     if (state == AppLifecycleState.paused) {
//       _didBackground = true;
//     }

//     if (state == AppLifecycleState.resumed &&
//         _didBackground &&
//         appState.isLoggedIn &&
//         appState.useDeviceAuth) {
//       _didBackground = false;
//       _authenticate();
//     }
//   }

//   Future<void> _authenticate() async {
//     try {
//       final didAuthenticate = await _localAuth.authenticate(
//         localizedReason: 'Please authenticate to continue',
//         options: const AuthenticationOptions(
//           biometricOnly: false,
//           stickyAuth: true,
//           useErrorDialogs: true,
//         ),
//       );
//       if (!didAuthenticate) SystemNavigator.pop();
//     } on PlatformException {
//       // fallback allowed
//     }
//   }

//   Future<void> _setupFCM() async {
//     try {
//       final messaging = FirebaseMessaging.instance;
//       await messaging.requestPermission();

//       final fcmToken = await messaging.getToken();
//       final prefs = await SharedPreferences.getInstance();
//       final userId = prefs.getInt('user_id');

//       if (fcmToken != null && userId != null) {
//         await FcmTokenApi.saveFcmToken(userId: userId, fcmToken: fcmToken);
//         print('✅ FCM token sent to backend');
//       }

//       const AndroidNotificationChannel channel = AndroidNotificationChannel(
//         'default_channel_id',
//         'General Notifications',
//         description: 'Channel for general notifications',
//         importance: Importance.max,
//       );

//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);

//       FirebaseMessaging.onMessage.listen((message) {
//         print('🔔 Foreground notification: ${message.notification?.title}');

//         RemoteNotification? notification = message.notification;
//         AndroidNotification? android = message.notification?.android;

//         if (notification != null && android != null) {
//           flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 channelDescription: channel.description,
//                 importance: Importance.max,
//                 priority: Priority.high,
//                 icon: '@mipmap/ic_launcher',
//               ),
//             ),
//           );
//         }
//       });

//       FirebaseMessaging.onMessageOpenedApp.listen((message) {
//         print('📦 Notification tap data: ${message.data}');
//       });
//     } catch (e) {
//       print("❌ FCM setup error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: customTheme,
//       home: Consumer<AppState>(
//         builder: (ctx, appState, _) {
//           if (!appState.isLoggedIn) return const LoginPage();
//           return const BottomNavScreen();
//         },
//       ),
//     );
//   }
// }

// class BottomNavScreen extends StatefulWidget {
//   const BottomNavScreen({Key? key}) : super(key: key);

//   @override
//   State<BottomNavScreen> createState() => _BottomNavScreenState();
// }

// class _BottomNavScreenState extends State<BottomNavScreen> {
//   int _currentIndex = 0;

//   static final List<Widget> _pages = [
//     HomePage(),
//     FilesScreen(),
//     Chats(),
//     TodoList(),
//     CompanyDataPage(),
//   ];

//   Future<bool> _onWillPop() async {
//     if (_currentIndex != 0) {
//       setState(() {
//         _currentIndex = 0;
//       });
//       return false;
//     }
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         body: _pages[_currentIndex],
//         bottomNavigationBar: SafeArea(
//           child: Container(
//             margin: const EdgeInsets.fromLTRB(15, 0, 15, 20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 8,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: BottomNavigationBar(
//                 backgroundColor: Colors.white,
//                 currentIndex: _currentIndex,
//                 onTap: (index) => setState(() => _currentIndex = index),
//                 type: BottomNavigationBarType.fixed,
//                 items: const [
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.home_outlined),
//                     label: 'Home',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.folder_copy_outlined),
//                     label: 'Files',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.message_outlined),
//                     label: 'Message',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.playlist_add_sharp),
//                     label: 'To-do',
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:my_app/pages/notification/notifications_page.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'app_state.dart';
import 'pages/auth_screens/login_page.dart';
import 'pages/todo/todo_list.dart';
import 'pages/documents/documents.dart';
import 'pages/company_data/companydata.dart';
import 'pages/chats/chats.dart';
import 'config/theme.dart';
import 'pages/home_screens/home_page.dart';
import 'backend/api_requests/fcm_token_api.dart';
import 'pages/intro.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 BG Message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

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

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startNavigation();
  }

  void _startNavigation() {
    // Start fade-out after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _opacity = 0.0);
    });

    // Navigate after fade-out animation completes
    Future.delayed(const Duration(milliseconds: 2400), () {
      final isLoggedIn =
          Provider.of<AppState>(context, listen: false).isLoggedIn;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isLoggedIn ? const BottomNavScreen() : const LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: _opacity,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/Splash.png',
              fit: BoxFit.cover,
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 150),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _didBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupFCM();

    // ✅ Force auth if app launches and user is logged in
    Future.delayed(Duration.zero, () {
      final appState = Provider.of<AppState>(context, listen: false);
      print("appState.useDeviceAut->>>>>>> ${appState.useDeviceAuth}");
      if (appState.isLoggedIn && appState.useDeviceAuth) {
        _authenticate();
      }
    });
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
      _didBackground = true;
    }

    if (state == AppLifecycleState.resumed &&
        _didBackground &&
        appState.isLoggedIn &&
        appState.useDeviceAuth) {
      _didBackground = false;
      _authenticate();
    }
  }

  Future<void> _authenticate() async {
    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      if (!didAuthenticate) SystemNavigator.pop();
    } on PlatformException {
      // fallback allowed
    }
  }

  Future<void> _setupFCM() async {
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();

      final fcmToken = await messaging.getToken();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (fcmToken != null && userId != null) {
        await FcmTokenApi.saveFcmToken(userId: userId, fcmToken: fcmToken);
        print('✅ FCM token sent to backend');
      }

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'default_channel_id',
        'General Notifications',
        description: 'Channel for general notifications',
        importance: Importance.max,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      FirebaseMessaging.onMessage.listen((message) {
        print('🔔 Foreground notification: ${message.notification?.title}');

        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                importance: Importance.max,
                priority: Priority.high,
                icon: '@mipmap/ic_launcher',
              ),
            ),
          );
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print('📦 Notification tap data: ${message.data}');
      });
    } catch (e) {
      print("❌ FCM setup error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      home: IntroPage(),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      home: Consumer<AppState>(
        builder: (ctx, appState, _) {
          if (!appState.isLoggedIn) return const LoginPage();
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

  static final List<Widget> _pages = [
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
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
