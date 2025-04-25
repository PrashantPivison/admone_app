// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../app_state.dart';
// import '../../config/Animation/righttoleft_animation.dart';
// import '../../config/theme.dart';
// import '../../main.dart' show BottomNavScreen;
// import 'login_page.dart'; // Your email/password screen
// import 'package:my_app/backend/api_requests/auth_api.dart';

// class LoginWithOtp extends StatefulWidget {
//   const LoginWithOtp({Key? key}) : super(key: key);

//   @override
//   State<LoginWithOtp> createState() => _LoginWithOtpState();
// }

// class _LoginWithOtpState extends State<LoginWithOtp> {
//   final _emailCtrl = TextEditingController();
//   final _otpCtrl = TextEditingController();

//   bool _isEmailValid = false;
//   bool _isOtpSent = false;
//   bool _isSendingOtp = false;
//   bool _isVerifyingOtp = false;
//   int _secondsRemaining = 60;
//   Timer? _timer;
//   int? _userId;

//   @override
//   void initState() {
//     super.initState();
//     _emailCtrl.addListener(_validateEmail);
//   }

//   void _validateEmail() {
//     final e = _emailCtrl.text.trim();
//     final valid = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(e);
//     if (valid != _isEmailValid) setState(() => _isEmailValid = valid);
//   }

//   Future<void> _sendOtp() async {
//     if (!_isEmailValid || _isOtpSent || _isSendingOtp) return;
//     setState(() => _isSendingOtp = true);

//     try {
//       // Call backend directly to get userId
//       final res = await AuthApi.sendOtp(email: _emailCtrl.text.trim());
//       final id = res['userId'];
//       if (id is int)
//         _userId = id;
//       else if (id is String) _userId = int.tryParse(id);

//       if (_userId == null) throw Exception('Invalid userId from server');

//       setState(() {
//         _isOtpSent = true;
//         _secondsRemaining = 60;
//       });
//       _timer = Timer.periodic(const Duration(seconds: 1), (t) {
//         if (_secondsRemaining > 0) {
//           setState(() => _secondsRemaining--);
//         } else {
//           t.cancel();
//           setState(() => _isOtpSent = false);
//         }
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(e.toString())));
//     } finally {
//       setState(() => _isSendingOtp = false);
//     }
//   }

//   Future<void> _verifyOtp() async {
//     if (_userId == null || _isVerifyingOtp) return;
//     setState(() => _isVerifyingOtp = true);

//     final appState = Provider.of<AppState>(context, listen: false);
//     await appState.verifyOtp(
//       userId: _userId!,
//       otp: _otpCtrl.text.trim(),
//     );

//     if (appState.isLoggedIn) {
//       Navigator.of(context).pushAndRemoveUntil(
//         createRightToLeftRoute(const BottomNavScreen()),
//         (_) => false,
//       );
//     } else if (appState.errorMessage.isNotEmpty) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(appState.errorMessage)));
//     }

//     setState(() => _isVerifyingOtp = false);
//   }

//   // Future<void> _verifyOtp() async {
//   //   final appState = Provider.of<AppState>(context, listen: false);

//   //   await appState.verifyOtp(
//   //     userId: _userId!,
//   //     otp: _otpCtrl.text.trim(),
//   //   );
//   // }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _emailCtrl.removeListener(_validateEmail);
//     _emailCtrl.dispose();
//     _otpCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final title =
//         _isOtpSent ? 'Enter one‐time passcode' : 'Login with One‐Time Passcode';
//     final subtitle = _isOtpSent
//         ? 'Check your email for the verification code.'
//         : 'Enter your registered email to receive an OTP.';

//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 25),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(height: 60),
//               Image.asset('assets/images/logo.png', height: 40),
//               const SizedBox(height: 20),
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context)
//                     .textTheme
//                     .headlineMedium
//                     ?.copyWith(fontFamily: 'Poppins'),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 subtitle,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodySmall
//                     ?.copyWith(fontFamily: 'Inter'),
//               ),
//               const SizedBox(height: 24),
//               if (!_isOtpSent) _buildEmailField() else _buildOtpField(),
//               const SizedBox(height: 20),
//               _isOtpSent ? _buildVerifyButton() : _buildSendOtpButton(),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmailField() => SizedBox(
//         height: 45,
//         child: TextField(
//           controller: _emailCtrl,
//           keyboardType: TextInputType.emailAddress,
//           decoration: InputDecoration(
//             labelText: 'Email address',
//             filled: true,
//             fillColor: Colors.white,
//             prefixIcon:
//                 Icon(Icons.mail_outlined, color: CustomColors.textField),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(color: CustomColors.textField),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(
//                 color: CustomColors.textField.withOpacity(0.8),
//                 width: 2,
//               ),
//             ),
//           ),
//         ),
//       );

//   Widget _buildOtpField() => SizedBox(
//         height: 45,
//         child: TextField(
//           controller: _otpCtrl,
//           keyboardType: TextInputType.number,
//           maxLength: 6,
//           decoration: InputDecoration(
//             counterText: '',
//             labelText: 'Enter OTP',
//             filled: true,
//             fillColor: Colors.white,
//             prefixIcon: Icon(Icons.dialpad, color: CustomColors.textField),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(color: CustomColors.textField),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(
//                 color: CustomColors.textField.withOpacity(0.8),
//                 width: 2,
//               ),
//             ),
//           ),
//         ),
//       );

//   Widget _buildSendOtpButton() => SizedBox(
//         width: double.infinity,
//         height: 45,
//         child: ElevatedButton(
//           onPressed: (_isEmailValid && !_isOtpSent && !_isSendingOtp)
//               ? _sendOtp
//               : null,
//           child: _isSendingOtp
//               ? const CircularProgressIndicator(color: Colors.white)
//               : const Text('Get OTP', style: TextStyle(fontFamily: 'Poppins')),
//         ),
//       );

//   Widget _buildVerifyButton() => SizedBox(
//         width: double.infinity,
//         height: 45,
//         child: ElevatedButton(
//           onPressed: _isVerifyingOtp ? null : _verifyOtp,
//           child: _isVerifyingOtp
//               ? const CircularProgressIndicator(color: Colors.white)
//               : const Text('Verify OTP',
//                   style: TextStyle(fontFamily: 'Poppins')),
//         ),
//       );
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../config/Animation/righttoleft_animation.dart';
import '../../config/theme.dart';
import '../../main.dart' show BottomNavScreen;
import 'package:my_app/backend/api_requests/auth_api.dart';

class LoginWithOtp extends StatefulWidget {
  const LoginWithOtp({Key? key}) : super(key: key);

  @override
  State<LoginWithOtp> createState() => _LoginWithOtpState();
}

class _LoginWithOtpState extends State<LoginWithOtp> {
  final _emailCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();

  bool _isEmailValid = false;
  bool _isOtpSent = false;
  bool _isSendingOtp = false;
  bool _isVerifyingOtp = false;
  int _secondsRemaining = 120; // 2-minute timer
  Timer? _timer;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _emailCtrl.addListener(_validateEmail);
  }

  void _validateEmail() {
    final e = _emailCtrl.text.trim();
    final valid = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(e);
    if (valid != _isEmailValid) setState(() => _isEmailValid = valid);
  }

  Future<void> _sendOtp() async {
    if (!_isEmailValid || _isSendingOtp) return;
    setState(() {
      _isSendingOtp = true;
      _isOtpSent = true;
      _secondsRemaining = 120;
    });

    try {
      final res = await AuthApi.sendOtp(email: _emailCtrl.text.trim());
      final id = res['userId'];
      if (id is int)
        _userId = id;
      else if (id is String) _userId = int.tryParse(id);
      if (_userId == null) throw Exception('Invalid userId from server');

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          t.cancel();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() => _isOtpSent = false);
    } finally {
      setState(() => _isSendingOtp = false);
    }
  }

  Future<void> _verifyOtp() async {
    if (_userId == null || _isVerifyingOtp) return;
    setState(() => _isVerifyingOtp = true);

    final appState = Provider.of<AppState>(context, listen: false);
    await appState.verifyOtp(userId: _userId!, otp: _otpCtrl.text.trim());

    if (appState.isLoggedIn) {
      Navigator.of(context).pushAndRemoveUntil(
        createRightToLeftRoute(const BottomNavScreen()),
        (_) => false,
      );
    } else if (appState.errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(appState.errorMessage)));
    }

    setState(() => _isVerifyingOtp = false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailCtrl.removeListener(_validateEmail);
    _emailCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title =
        _isOtpSent ? 'Enter one‑time passcode' : 'Login with One‑Time Passcode';
    final subtitle = _isOtpSent
        ? 'Check your email for the verification code.'
        : 'Enter your registered email to receive an OTP.';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Image.asset('assets/images/logo.png', height: 40),
              const SizedBox(height: 20),
              Text(title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontFamily: 'Poppins')),
              const SizedBox(height: 12),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontFamily: 'Inter')),
              const SizedBox(height: 24),

              // Input field
              if (!_isOtpSent) _buildEmailField() else _buildOtpField(),

              const SizedBox(height: 10),

              // Countdown or resend link
              if (_isOtpSent) ...[
                if (_secondsRemaining > 0)
                  Text(
                    'Request new code in '
                    '${_secondsRemaining ~/ 60}:'
                    '${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(color: Colors.grey[600]),
                  )
                else
                  TextButton(
                    onPressed: _sendOtp,
                    child: const Text('Resend OTP'),
                  ),
                const SizedBox(height: 20),
                _buildVerifyButton(),
              ] else ...[
                const SizedBox(height: 20),
                _buildSendOtpButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() => SizedBox(
        height: 45,
        child: TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email address',
            filled: true,
            fillColor: Colors.white,
            prefixIcon:
                Icon(Icons.mail_outlined, color: CustomColors.textField),
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
          ),
        ),
      );

  Widget _buildOtpField() => SizedBox(
        height: 45,
        child: TextField(
          controller: _otpCtrl,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: InputDecoration(
            counterText: '',
            labelText: 'Enter OTP',
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(Icons.dialpad, color: CustomColors.textField),
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
          ),
        ),
      );

  Widget _buildSendOtpButton() => SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
          onPressed: (_isEmailValid && !_isSendingOtp) ? _sendOtp : null,
          child: _isSendingOtp
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Get OTP', style: TextStyle(fontFamily: 'Poppins')),
        ),
      );

  Widget _buildVerifyButton() => SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
          onPressed: _isVerifyingOtp ? null : _verifyOtp,
          child: _isVerifyingOtp
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Verify OTP',
                  style: TextStyle(fontFamily: 'Poppins')),
        ),
      );
}
