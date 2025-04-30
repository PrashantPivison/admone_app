// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../app_state.dart';
// import '../../config/Animation/righttoleft_animation.dart';
// import '../../main.dart'; // for BottomNavScreen
// import 'login_biometric.dart';
//
// class LoginPasscode extends StatelessWidget {
//   LoginPasscode({Key? key}) : super(key: key);
//   final TextEditingController _passcodeController = TextEditingController();
//
//   Future<void> _handlePasscodeLogin(BuildContext context) async {
//     final appState = Provider.of<AppState>(context, listen: false);
//     final attempt = _passcodeController.text.trim();
//
//     final isValid = await appState.verifyPasscode(attempt);
//     if (isValid) {
//       appState.setPasscodeChecked(true);
//       appState.setPasscodePassed(true);
//
//       Navigator.of(context).pushAndRemoveUntil(
//         createRightToLeftRoute(const BottomNavScreen()),
//         (_) => false,
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Invalid passcode')),
//       );
//     }
//   }
//
//   void _handleSkip(BuildContext context) {
//     final appState = Provider.of<AppState>(context, listen: false);
//     appState.setPasscodeChecked(true);
//
//     Navigator.of(context).pushReplacement(
//       createRightToLeftRoute(LoginBiometric()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 25),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.asset('assets/images/lock.png', height: 100),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _passcodeController,
//                 obscureText: true,
//                 keyboardType: TextInputType.number,
//                 maxLength: 4,
//                 decoration: const InputDecoration(
//                   hintText: 'Enter 4‑digit passcode',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () => _handlePasscodeLogin(context),
//                   child: const Text('Unlock'),
//                 ),
//               ),
//               if (!Provider.of<AppState>(context, listen: false)
//                   .passcodeSet) ...[
//                 TextButton(
//                   onPressed: () => _handleSkip(context),
//                   child: const Text('Skip and use biometric'),
//                 ),
//               ]
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../config/Animation/righttoleft_animation.dart';
import '../../config/theme.dart';
import '../../main.dart' show BottomNavScreen;
import 'login_biometric.dart';

class LoginPasscode extends StatefulWidget {
  const LoginPasscode({Key? key}) : super(key: key);

  @override
  State<LoginPasscode> createState() => _LoginPasscodeState();
}

class _LoginPasscodeState extends State<LoginPasscode> {
  final TextEditingController _passcodeController = TextEditingController();
  bool _isVerifying = false;
  bool _showError = false;

  Future<void> _handlePasscodeLogin() async {
    if (_isVerifying) return;

    setState(() {
      _isVerifying = true;
      _showError = false;
    });

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      final attempt = _passcodeController.text.trim();

      if (attempt.length != 4) {
        throw Exception('Passcode must be 4 digits');
      }

      final isValid = await appState.verifyPasscode(attempt);

      if (isValid) {
        appState.setPasscodeChecked(true);
        appState.setPasscodePassed(true);

        _navigateToHome();
      } else {
        throw Exception('Invalid passcode');
      }
    } catch (e) {
      setState(() => _showError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      createRightToLeftRoute(const BottomNavScreen()),
          (_) => false,
    );
  }

  void _handleSkip() {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setPasscodeChecked(true);

    // Navigator.of(context).pushReplacement(
    //   createRightToLeftRoute(const LoginBiometric()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final canSkip = !appState.passcodeSet;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              _buildLockIcon(),
              const SizedBox(height: 24),
              _buildTitle('Enter Passcode'),
              const SizedBox(height: 12),
              _buildSubtitle('Enter your 4-digit passcode to continue'),
              const SizedBox(height: 24),
              _buildPasscodeField(),
              if (_showError) ...[
                const SizedBox(height: 8),
                Text(
                  'Invalid passcode. Please try again.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.red,
                    fontFamily: 'Inter',
                    fontSize: 14,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              _buildUnlockButton(),
              if (canSkip) ...[
                const SizedBox(height: 16),
                _buildSkipButton(),
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLockIcon() {
    return Image.asset(
      'assets/images/lock.png',
      height: 100,
      errorBuilder: (_, __, ___) => Icon(
        Icons.lock_outline,
        size: 60,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildSubtitle(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildPasscodeField() {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: _passcodeController,
        obscureText: true,
        keyboardType: TextInputType.number,
        maxLength: 4,
        // textAlign: TextAlign.center,
        // style: const TextStyle(
        //   fontSize: 24,
        //   letterSpacing: 8,
        // ),
        decoration: _buildInputDecoration(
          hintText: 'Enter passcode',
          prefixIcon: Icons.lock_outline,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      counterText: '',
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(prefixIcon, color: CustomColors.textField),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: CustomColors.textField),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: CustomColors.textField.withOpacity(0.8),
          width: 2,
        ),
      ),
    );
  }

  Widget _buildUnlockButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isVerifying ? null : _handlePasscodeLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        child: _isVerifying
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Text('Unlock'),
      ),
    );
  }

  Widget _buildSkipButton() {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: OutlinedButton(
        onPressed: _handleSkip,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Use Biometric Instead',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passcodeController.dispose();
    super.dispose();
  }
}