// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../app_state.dart';
// import '../../config/Animation/righttoleft_animation.dart';
// import '../../config/theme.dart';
// import '../../main.dart' show BottomNavScreen;
// import './login_page.dart';
// import 'package:my_app/backend/api_requests/auth_api.dart';
//
// class LoginWithOtp extends StatefulWidget {
//   const LoginWithOtp({Key? key}) : super(key: key);
//
//   @override
//   State<LoginWithOtp> createState() => _LoginWithOtpState();
// }
//
// class _LoginWithOtpState extends State<LoginWithOtp> {
//   final _emailCtrl = TextEditingController();
//   final _otpCtrl = TextEditingController();
//
//   bool _isEmailValid = false;
//   bool _isOtpSent = false;
//   bool _isSendingOtp = false;
//   bool _isVerifyingOtp = false;
//   int _secondsRemaining = 120;
//   Timer? _timer;
//   int? _userId;
//
//   @override
//   void initState() {
//     super.initState();
//     _emailCtrl.addListener(_validateEmail);
//   }
//
//   void _validateEmail() {
//     final text = _emailCtrl.text.trim();
//     // allow letters, numbers, underscore, dot, plus and hyphen in local part
//     final valid = RegExp(r"^[\w.+-]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(text);
//     if (valid != _isEmailValid) setState(() => _isEmailValid = valid);
//   }
//
//   Future<void> _sendOtp() async {
//     if (!_isEmailValid || _isSendingOtp) return;
//
//     setState(() {
//       _isSendingOtp = true;
//       _isOtpSent = false;
//       _secondsRemaining = 120;
//     });
//
//     try {
//       final res = await AuthApi.sendOtp(email: _emailCtrl.text.trim());
//
//       print('🛠 API Response in _sendOtp(): $res');
//
//       if (res.containsKey('userId')) {
//         final rawUserId = res['userId'];
//
//         if (rawUserId is int) {
//           _userId = rawUserId;
//         } else if (rawUserId is String) {
//           _userId = int.tryParse(rawUserId);
//         }
//
//         if (_userId == null) {
//           throw Exception('Invalid user ID received.');
//         }
//
//         setState(() {
//           _isOtpSent = true;
//         });
//
//         _timer?.cancel();
//         _timer = Timer.periodic(const Duration(seconds: 1), (t) {
//           if (_secondsRemaining > 0) {
//             setState(() => _secondsRemaining--);
//           } else {
//             t.cancel();
//           }
//         });
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('OTP sent successfully!')),
//         );
//       } else {
//         final errorMsg = res['message'] ?? res['error'] ?? 'Failed to send OTP';
//         throw Exception(errorMsg);
//       }
//     } catch (e) {
//       _timer?.cancel();
//       setState(() {
//         _isOtpSent = false;
//       });
//       final errorText = e.toString().replaceFirst('Exception: ', '');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(errorText)),
//       );
//     } finally {
//       setState(() => _isSendingOtp = false);
//     }
//   }
//
//   Future<void> _verifyOtp() async {
//     if (_userId == null || _isVerifyingOtp) return;
//
//     setState(() => _isVerifyingOtp = true);
//
//     try {
//       final appState = Provider.of<AppState>(context, listen: false);
//       await appState.verifyOtp(userId: _userId!, otp: _otpCtrl.text.trim());
//
//       if (appState.isLoggedIn) {
//         Navigator.of(context).pushAndRemoveUntil(
//           createRightToLeftRoute(const BottomNavScreen()),
//           (_) => false,
//         );
//       } else if (appState.errorMessage.isNotEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(appState.errorMessage)),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Invalid OTP')),
//         );
//       }
//     } catch (e) {
//       final errorText = e.toString().replaceFirst('Exception: ', '');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(errorText)),
//       );
//     } finally {
//       setState(() => _isVerifyingOtp = false);
//     }
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     _emailCtrl.removeListener(_validateEmail);
//     _emailCtrl.dispose();
//     _otpCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final title =
//         _isOtpSent ? 'Enter one-time passcode' : 'Login with One-Time Passcode';
//     final subtitle = _isOtpSent
//         ? 'An email with verification code was sent to your registered email address. Please enter the code below to login.'
//         : 'Enter your registered email address to login';
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 25),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(height: 60),
//               _buildLogo(),
//               const SizedBox(height: 24),
//               _buildTitle(title),
//               const SizedBox(height: 12),
//               _buildSubtitle(subtitle),
//               const SizedBox(height: 24),
//               if (!_isOtpSent)
//                 _buildEmailField()
//               else ...[
//                 if (_secondsRemaining > 0)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: Text(
//                       'Request new code in ${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
//                       textAlign: TextAlign.center,
//                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w600,
//                           ),
//                     ),
//                   )
//                 else
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: TextButton(
//                       onPressed: _sendOtp,
//                       child: const Text('Resend OTP'),
//                     ),
//                   ),
//                 _buildOtpField(),
//               ],
//               const SizedBox(height: 20),
//               if (_isOtpSent) _buildVerifyButton() else _buildSendOtpButton(),
//               const SizedBox(height: 16),
//               _buildPasswordLoginButton(context),
//               const SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLogo() {
//     return Image.asset(
//       'assets/images/logo.png',
//       height: 40,
//       errorBuilder: (_, __, ___) => const Icon(
//         Icons.broken_image,
//         size: 60,
//         color: Colors.grey,
//       ),
//     );
//   }
//
//   Widget _buildTitle(String text) {
//     return Text(
//       text,
//       textAlign: TextAlign.center,
//       style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//             fontFamily: 'Poppins',
//           ),
//     );
//   }
//
//   Widget _buildSubtitle(String text) {
//     return Text(
//       text,
//       textAlign: TextAlign.center,
//       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//             fontFamily: 'Inter',
//           ),
//     );
//   }
//
//   Widget _buildEmailField() => SizedBox(
//         height: 45,
//         // child: TextField(
//         //   controller: _emailCtrl,
//         //   keyboardType: TextInputType.emailAddress,
//         //   decoration: _buildInputDecoration(
//         //     labelText: 'Email address',
//         //     prefixIcon: Icons.mail_outlined,
//         //   ),
//         // ),
//
//     child: TextField(
//       controller: _emailCtrl,
//       keyboardType: TextInputType.emailAddress,
//       decoration: buildInputDecoration(
//         labelText: 'Email address',
//         prefixIcon: Icons.mail_outlined,
//       ),
//     ),
//       );
//
//   Widget _buildOtpField() => SizedBox(
//         height: 45,
//         child: TextField(
//           controller: _otpCtrl,
//           keyboardType: TextInputType.number,
//           textAlign: TextAlign.center,
//           maxLength: 6,
//           decoration: _buildotpDecoration(hintText: 'Enter OTP Here'),
//         ),
//       );
//   InputDecoration _buildotpDecoration({
//     required String hintText,
//   }) {
//     return InputDecoration(
//       hintText: hintText,
//       counterText: '',
//       hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
//       contentPadding: EdgeInsets.symmetric(vertical: 16),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
//       ),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       filled: true,
//       fillColor: Colors.white,
//     );
//   }
//
//   // InputDecoration _buildInputDecoration({
//   //   required String labelText,
//   //   required IconData prefixIcon,
//   // }) {
//   //   return InputDecoration(
//   //     labelText: labelText,
//   //     labelStyle: TextStyle(color: CustomColors.textField),
//   //     counterText: '',
//   //     filled: true,
//   //     fillColor: Colors.white,
//   //     prefixIcon: Icon(prefixIcon, color: CustomColors.textField),
//   //     enabledBorder: OutlineInputBorder(
//   //       borderRadius: BorderRadius.circular(10),
//   //       borderSide: BorderSide(color: CustomColors.textField),
//   //     ),
//   //     focusedBorder: OutlineInputBorder(
//   //       borderRadius: BorderRadius.circular(10),
//   //       borderSide: BorderSide(
//   //         color: CustomColors.textField.withOpacity(0.8),
//   //         width: 2,
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   Widget _buildSendOtpButton() => SizedBox(
//         width: double.infinity,
//         height: 45,
//         child: ElevatedButton(
//           onPressed: (_isEmailValid && !_isSendingOtp) ? _sendOtp : null,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Theme.of(context).colorScheme.primary,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             padding: const EdgeInsets.symmetric(vertical: 10),
//           ),
//           child: _isSendingOtp
//               ? const SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                       color: Colors.white, strokeWidth: 2),
//                 )
//               : const Text(
//                   'Get OTP',
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 14,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//         ),
//       );
//
//   Widget _buildVerifyButton() => SizedBox(
//         width: double.infinity,
//         height: 50,
//         child: ElevatedButton(
//           onPressed: _isVerifyingOtp ? null : _verifyOtp,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Theme.of(context).colorScheme.primary,
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             textStyle: const TextStyle(
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16),
//           ),
//           child: _isVerifyingOtp
//               ? const SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                       color: Colors.white, strokeWidth: 2),
//                 )
//               : const Text('Verify OTP'),
//         ),
//       );
//
//   Widget _buildPasswordLoginButton(BuildContext context) => SizedBox(
//         width: double.infinity,
//         height: 45,
//         child: OutlinedButton(
//           onPressed: () {
//             Navigator.of(context).pushReplacement(
//               createRightToLeftRoute(const LoginPage()),
//             );
//           },
//           style: OutlinedButton.styleFrom(
//             side: BorderSide(
//               color: Theme.of(context).colorScheme.primary,
//               width: 1.5,
//             ),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: Text(
//             'Login with Password',
//             style: TextStyle(
//               color: Theme.of(context).colorScheme.primary,
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w500,
//               fontSize: 14,
//             ),
//           ),
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
import './login_page.dart';
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
  int _secondsRemaining = 120;
  Timer? _timer;
  int? _userId;
  String? _emailError;
  String? _otpError;

  @override
  void initState() {
    super.initState();
    _emailCtrl.addListener(_validateEmail);
  }

  void _validateEmail() {
    final text = _emailCtrl.text.trim();
    final valid = RegExp(r"^[\w.+-]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(text);
    setState(() {
      _isEmailValid = valid;
      _emailError = null; // Clear error when user types
    });
  }

  Future<void> _sendOtp() async {
    if (!_isEmailValid || _isSendingOtp) return;

    setState(() {
      _isSendingOtp = true;
      _isOtpSent = false;
      _secondsRemaining = 120;
      _emailError = null;
    });

    try {
      final res = await AuthApi.sendOtp(email: _emailCtrl.text.trim());

      print('🛠 API Response in _sendOtp(): $res');

      if (res.containsKey('userId')) {
        final rawUserId = res['userId'];

        if (rawUserId is int) {
          _userId = rawUserId;
        } else if (rawUserId is String) {
          _userId = int.tryParse(rawUserId);
        }

        if (_userId == null) {
          throw Exception('Invalid user ID received.');
        }

        setState(() {
          _isOtpSent = true;
        });

        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (t) {
          if (_secondsRemaining > 0) {
            setState(() => _secondsRemaining--);
          } else {
            t.cancel();
          }
        });
      } else {
        final errorMsg = res['message'] ?? res['error'] ?? 'Failed to send OTP';
        throw Exception(errorMsg);
      }
    } catch (e) {
      _timer?.cancel();
      setState(() {
        _isOtpSent = false;
        _emailError = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() => _isSendingOtp = false);
    }
  }

  Future<void> _verifyOtp() async {
    if (_userId == null || _isVerifyingOtp) return;

    setState(() {
      _isVerifyingOtp = true;
      _otpError = null;
    });

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.verifyOtp(userId: _userId!, otp: _otpCtrl.text.trim());

      if (appState.isLoggedIn) {
        Navigator.of(context).pushAndRemoveUntil(
          createRightToLeftRoute(const BottomNavScreen()),
              (_) => false,
        );
      } else if (appState.errorMessage.isNotEmpty) {
        setState(() {
          _otpError = appState.errorMessage;
        });
      } else {
        setState(() {
          _otpError = 'Invalid OTP';
        });
      }
    } catch (e) {
      setState(() {
        _otpError = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() => _isVerifyingOtp = false);
    }
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
    _isOtpSent ? 'Enter one-time passcode' : 'Login with One-Time Passcode';
    final subtitle = _isOtpSent
        ? 'An email with verification code was sent to your registered email address. Please enter the code below to login.'
        : 'Enter your registered email address to login';

    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  _buildLogo(),
                  const SizedBox(height: 24),
                  _buildTitle(title),
                  const SizedBox(height: 12),
                  _buildSubtitle(subtitle),
                  const SizedBox(height: 24),
                  if (!_isOtpSent)
                    _buildEmailField()
                  else ...[
                    if (_secondsRemaining > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          'Request new code in ${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TextButton(
                          onPressed: _sendOtp,
                          child: const Text('Resend OTP'),
                        ),
                      ),
                    _buildOtpField(),
                  ],
                  const SizedBox(height: 20),
                  if (_isOtpSent) _buildVerifyButton() else _buildSendOtpButton(),
                  const SizedBox(height: 16),
                  _buildPasswordLoginButton(context),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // Error messages at the top
          if (_emailError != null || _otpError != null || appState.errorMessage.isNotEmpty)
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: _buildTopErrorMessage(_emailError ?? _otpError ?? appState.errorMessage),
            ),
        ],
      ),
    );
  }

  Widget _buildTopErrorMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/logo.png',
      height: 40,
      errorBuilder: (_, __, ___) => const Icon(
        Icons.broken_image,
        size: 60,
        color: Colors.grey,
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

  Widget _buildEmailField() {
    final hasError = _emailError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 45,
          child: TextField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: buildInputDecoration(
              labelText: 'Email address',
              prefixIcon: Icons.mail_outlined,
              hasError: hasError,
            ),
          ),
        ),
        if (hasError) _buildErrorText(_emailError!),
      ],
    );
  }

  Widget _buildOtpField() {
    final hasError = _otpError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 45,
          child: TextField(
            controller: _otpCtrl,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            decoration: _buildOtpDecoration(
              hintText: 'Enter OTP Here',
              hasError: hasError,
            ),
          ),
        ),
        if (hasError) _buildErrorText(_otpError!),
      ],
    );
  }

  InputDecoration _buildOtpDecoration({
    required String hintText,
    bool hasError = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      counterText: '',
      hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: hasError ? Colors.red : Colors.grey.shade300,
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: hasError ? Colors.red : Colors.grey.shade300,
          width: 1.2,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  InputDecoration buildInputDecoration({
    required String labelText,
    required IconData prefixIcon,
    bool hasError = false,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: hasError ? Colors.red : CustomColors.textField,
      ),
      counterText: '',
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(
        prefixIcon,
        color: CustomColors.textField,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: hasError ? Colors.red : CustomColors.textField,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: hasError ? Colors.red : CustomColors.textField.withOpacity(0.8),
          width: 2,
        ),
      ),
    );
  }

  Widget _buildErrorText(String error) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
      child: Row(
        children: [
          const Icon(Icons.error, size: 16, color: Colors.red),
          const SizedBox(width: 5),
          Text(
            error,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSendOtpButton() => SizedBox(
    width: double.infinity,
    height: 45,
    child: ElevatedButton(
     onPressed: (_isEmailValid && !_isSendingOtp) ? _sendOtp : null,
      style: Theme.of(context).primaryButtonStyle,
      child: Text(
        "Get OTP",
        style: Theme.of(context).primaryButtonTextStyle,
      ),
    ),
    // child: ElevatedButton(
    //   onPressed: (_isEmailValid && !_isSendingOtp) ? _sendOtp : null,
    //   style: ElevatedButton.styleFrom(
    //     backgroundColor: Theme.of(context).colorScheme.primary,
    //     shape:
    //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    //     padding: const EdgeInsets.symmetric(vertical: 10),
    //   ),
    //   child: _isSendingOtp
    //       ? const SizedBox(
    //     width: 20,
    //     height: 20,
    //     child: CircularProgressIndicator(
    //         color: Colors.white, strokeWidth: 2),
    //   )
    //       : const Text(
    //     'Get OTP',
    //     style: TextStyle(
    //       fontFamily: 'Poppins',
    //       fontSize: 14,
    //       color: Colors.white,
    //       fontWeight: FontWeight.w600,
    //     ),
    //   ),
    // ),
  );

  Widget _buildVerifyButton() => SizedBox(
    width: double.infinity,
    height: 45,
    child: ElevatedButton(
      onPressed: _isVerifyingOtp ? null : _verifyOtp,
      style: Theme.of(context).primaryButtonStyle,
      child: Text(
        "Verify OTP",
        style: Theme.of(context).primaryButtonTextStyle,
      ),
    ),
    // child: ElevatedButton(
    //   onPressed: _isVerifyingOtp ? null : _verifyOtp,
    //   style: ElevatedButton.styleFrom(
    //     backgroundColor: Theme.of(context).colorScheme.primary,
    //     foregroundColor: Colors.white,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(8),
    //     ),
    //     textStyle: const TextStyle(
    //         fontFamily: 'Poppins',
    //         fontWeight: FontWeight.w600,
    //         fontSize: 16),
    //   ),
    //   child: _isVerifyingOtp
    //       ? const SizedBox(
    //     width: 20,
    //     height: 20,
    //     child: CircularProgressIndicator(
    //         color: Colors.white, strokeWidth: 2),
    //   )
    //       : const Text('Verify OTP'),
    // ),
  );

  Widget _buildPasswordLoginButton(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 45,
    child: OutlinedButton(
      onPressed: () {
      Navigator.of(context).pushReplacement(
        createRightToLeftRoute(const LoginPage()),
      );
    },
      style: Theme.of(context).outlinedPrimaryButtonStyle,
      child: Text(
        "Login with Password",
        style: Theme.of(context).primaryButtonTextStyle.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    ),
    // child: OutlinedButton(
    //   onPressed: () {
    //     Navigator.of(context).pushReplacement(
    //       createRightToLeftRoute(const LoginPage()),
    //     );
    //   },
    //   style: OutlinedButton.styleFrom(
    //     side: BorderSide(
    //       color: Theme.of(context).colorScheme.primary,
    //       width: 1.5,
    //     ),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(8),
    //     ),
    //   ),
    //   child: Text(
    //     'Login with Password',
    //     style: TextStyle(
    //       color: Theme.of(context).colorScheme.primary,
    //       fontFamily: 'Poppins',
    //       fontWeight: FontWeight.w500,
    //       fontSize: 14,
    //     ),
    //   ),
    // ),
  );
}