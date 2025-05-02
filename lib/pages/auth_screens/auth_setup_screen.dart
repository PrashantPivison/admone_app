// lib/pages/auth_screens/auth_setup_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../config/theme.dart';
import '../../config/Animation/righttoleft_animation.dart';
import '../../main.dart'; // for BottomNavScreen

class AuthSetupScreen extends StatelessWidget {
  const AuthSetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/admlogo.png',
          height: 40,
          errorBuilder: (_, __, ___) => const SizedBox(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // match your biometric screen logo
                      Image.asset(
                        'assets/images/fingerprint.png',
                        height: 120,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.lock_outline,
                            size: 120,
                            color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Secure your app',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Would you like to enable device unlock\n(PIN/Pattern/Biometrics)?',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontFamily: 'Inter', height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // buttons at bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<AppState>(context, listen: false)
                            .setUseDeviceAuth(true);
                        Navigator.of(context).pushReplacement(
                          createRightToLeftRoute(const BottomNavScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        textStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      child: Text('Yes, secure it',
                          style: TextStyle(color: onPrimary)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        Provider.of<AppState>(context, listen: false)
                            .setUseDeviceAuth(false);
                        Navigator.of(context).pushReplacement(
                          createRightToLeftRoute(const BottomNavScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        textStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      child:
                          Text('No, thanks', style: TextStyle(color: primary)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
