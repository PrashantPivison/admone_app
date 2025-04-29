import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:my_app/app_state.dart';
import 'package:my_app/main.dart'; // BottomNavScreen

class BiometricAuthScreen extends StatelessWidget {
  BiometricAuthScreen({Key? key}) : super(key: key);

  final LocalAuthentication _auth = LocalAuthentication();

  Future<void> _authenticate(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);

    bool didAuth = false;
    try {
      didAuth = await _auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } catch (_) {
      didAuth = false;
    }

    if (didAuth) {
      appState.setBiometricPassed(true);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const BottomNavScreen()),
        (_) => false,
      );
    } else {
      // maybe exit app or show error
    }
  }

  @override
  Widget build(BuildContext context) {
    _authenticate(context); // trigger immediately

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
