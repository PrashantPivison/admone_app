// lib/nav.dart

import 'package:flutter/material.dart';

// Import your pages/screens here
import 'package:my_app/pages/auth_screens/login_page.dart';
import 'package:my_app/pages/home_screens/home_page.dart';
import 'package:my_app/pages/documents/documents.dart';
import 'package:my_app/pages/chats/chats.dart';
import 'package:my_app/pages/todo/todo_list.dart';
// import 'package:my_app/pages/profile/';

// 1) A class to hold route names in a single place
class AppRoutes {
  static const String dashboard = '/dashboard';
  static const String login = '/login';
  static const String documents = '/documents';
  static const String chats = '/chats';
  static const String profile = '/profile';
  static const String todo = '/todo';
}

// 2) A Route Generator that handles named routes
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case AppRoutes.documents:
        return MaterialPageRoute(builder: (_) => FilesScreen());
      case AppRoutes.chats:
        return MaterialPageRoute(builder: (_) => Chats());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => TodoList());

      default:
        // If route not found, go to a fallback page or show an error
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page Not Found')),
          ),
        );
    }
  }
}
