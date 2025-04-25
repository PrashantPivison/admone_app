import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
// import '../../app_state.dart';
import 'package:my_app/app_state.dart';
import '../../config/theme.dart';
import '../../config/Animation/righttoleft_animation.dart';
import '../../main.dart';
// import 'login_passcode.dart';
import './login_otp_1.dart';

class LoginBiometric extends StatelessWidget {
  LoginBiometric({Key? key}) : super(key: key);

  final LocalAuthentication _auth = LocalAuthentication();

  Future<void> _turnOnBiometric(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);

    bool canCheck = false;
    try {
      canCheck = await _auth.canCheckBiometrics;
    } catch (_) {
      canCheck = false;
    }

    if (!canCheck) {
      // Fallback to passcode
      appState.setPasscodeChecked(true);
      Navigator.pushReplacement(
        context,
        createRightToLeftRoute(LoginPasscode()),
      );
      return;
    }

    bool didAuth = false;
    try {
      didAuth = await _auth.authenticate(
        localizedReason: 'Authenticate to enable biometrics',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: false,
          useErrorDialogs: true,
        ),
      );
    } catch (_) {
      didAuth = false;
    }

    if (didAuth) {
      appState.setBiometricPassed(true);
      Navigator.of(context).pushAndRemoveUntil(
        createRightToLeftRoute(const BottomNavScreen()),
        (_) => false,
      );
    } else {
      // Cancelled or failed → passcode
      appState.setPasscodeChecked(true);
      Navigator.pushReplacement(
        context,
        createRightToLeftRoute(LoginPasscode()),
      );
    }
  }

  void _maybeLater(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setPasscodeChecked(true);
    Navigator.pushReplacement(
      context,
      createRightToLeftRoute(LoginPasscode()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                      _buildLogo(context),
                      const SizedBox(height: 15),
                      _buildLoginTitle(context),
                      const SizedBox(height: 15),
                      _buildLoginSubtitle(context),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 5),
              child: Column(
                children: [
                  _buildGetStartedButton(context),
                  const SizedBox(height: 5),
                  _buildMaybeLaterLink(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Image.asset(
        'assets/images/fingerprint.png',
        height: 130,
        errorBuilder: (c, e, s) => const Icon(
          Icons.broken_image,
          size: 130,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildLoginTitle(BuildContext context) {
    return Text(
      'Login with Biometric',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .headlineMedium
          ?.copyWith(fontFamily: 'Poppins'),
    );
  }

  Widget _buildLoginSubtitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        'Enable biometric authentication for quick and secure access.',
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontFamily: 'Inter', height: 1.5),
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _turnOnBiometric(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: Text(
          'Turn on Biometric Login',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Theme.of(context).colorScheme.surface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMaybeLaterLink(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextButton(
        onPressed: () => _maybeLater(context),
        child: Text(
          'May be later',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: CustomColors.textField,
              ),
        ),
      ),
    );
  }
}
