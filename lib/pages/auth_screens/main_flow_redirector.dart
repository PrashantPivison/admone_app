import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/app_state.dart';
import 'package:my_app/pages/auth_screens/login_page.dart';
import 'package:my_app/pages/auth_screens/login_biometric.dart';
import 'package:my_app/pages/auth_screens/login_otp_1.dart';
import 'package:my_app/main.dart'; // For BottomNavScreen

class MainFlowRedirector extends StatelessWidget {
  const MainFlowRedirector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        if (!appState.isLoggedIn) {
          return const LoginPage();
        }

        // // 🛑 Very Important → First check if setup is done or not
        // if (!appState.biometricSetupDone) {
        //   return LoginBiometric(); // First time ask
        // }
        // if (appState.passcodeSet && !appState.passcodePassed) {
        //   return LoginPasscode(); // Passcode authentication
        // }
        // // ✅ Now biometric/passcode setup is done

        // if (appState.biometricPassed || appState.passcodePassed) {
        //   return const BottomNavScreen(); // Already authenticated
        // }

        // if (appState.passcodeSet) {
        //   return LoginPasscode(); // Authenticate via passcode
        // }

        return LoginBiometric(); // Authenticate via biometric
      },
    );
  }
}
