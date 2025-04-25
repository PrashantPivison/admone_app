import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../config/Animation/righttoleft_animation.dart';
import '../../main.dart'; // for BottomNavScreen
import 'login_biometric.dart';

class LoginPasscode extends StatelessWidget {
  LoginPasscode({Key? key}) : super(key: key);
  final TextEditingController _passcodeController = TextEditingController();

  Future<void> _handlePasscodeLogin(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final attempt = _passcodeController.text.trim();

    final isValid = await appState.verifyPasscode(attempt);
    if (isValid) {
      appState.setPasscodeChecked(true);
      appState.setPasscodePassed(true);

      Navigator.of(context).pushAndRemoveUntil(
        createRightToLeftRoute(const BottomNavScreen()),
        (_) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid passcode')),
      );
    }
  }

  void _handleSkip(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setPasscodeChecked(true);

    Navigator.of(context).pushReplacement(
      createRightToLeftRoute(LoginBiometric()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/lock.png', height: 100),
              const SizedBox(height: 20),
              TextField(
                controller: _passcodeController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  hintText: 'Enter 4‑digit passcode',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handlePasscodeLogin(context),
                  child: const Text('Unlock'),
                ),
              ),
              TextButton(
                onPressed: () => _handleSkip(context),
                child: const Text('Skip and use biometric'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
