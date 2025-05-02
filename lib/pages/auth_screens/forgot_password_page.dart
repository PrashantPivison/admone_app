// import 'package:flutter/material.dart';
// import '../../config/Animation/righttoleft_animation.dart';
// import '../../config/theme.dart';
// import './login_page.dart';
// import 'package:my_app/backend/api_requests/auth_api.dart';
//
// class ForgotPasswordPage extends StatefulWidget {
//   const ForgotPasswordPage({Key? key}) : super(key: key);
//
//   @override
//   State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
// }
//
// class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
//   final _emailCtrl = TextEditingController();
//   String? _emailError;
//   bool _isSending = false;
//
//   bool get _isEmailValid =>
//       _emailCtrl.text.isNotEmpty &&
//       RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailCtrl.text.trim());
//
//   Future<void> _sendResetLink() async {
//     final email = _emailCtrl.text.trim();
//     setState(() {
//       _emailError = !_isEmailValid ? 'Please enter a valid email' : null;
//     });
//
//     if (!_isEmailValid) return;
//
//     setState(() => _isSending = true);
//
//     try {
//       await AuthApi.forgotPassword(email: email);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Reset link sent to your email')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     } finally {
//       setState(() => _isSending = false);
//     }
//   }
//
//   @override
//   void dispose() {
//     _emailCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: AppBar(
//         title: const Text('Forgot Password'),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor:
//             Colors.black, // Optional: make back arrow and title black
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 25),
//           child: Column(
//             children: [
//               const SizedBox(height: 30),
//
//               // 🖼️ Logo Image
//               Image.asset(
//                 'assets/images/logo.png',
//                 height: 40,
//                 errorBuilder: (_, __, ___) => const Icon(Icons.broken_image,
//                     size: 60, color: Colors.grey),
//               ),
//               const SizedBox(height: 30),
//
//               TextField(
//                 controller: _emailCtrl,
//                 keyboardType: TextInputType.emailAddress,
//                 // decoration: InputDecoration(
//                 //   labelStyle: TextStyle(color: CustomColors.textField),
//                 //   labelText: 'Email address',
//                 //   prefixIcon:
//                 //       Icon(Icons.mail_outlined, color: CustomColors.textField),
//                 //   border: OutlineInputBorder(
//                 //       borderRadius: BorderRadius.circular(10)),
//                 //   filled: true,
//                 //   fillColor: Colors.white,
//                 // ),
//                 decoration:InputDecoration(
//                   labelText:'Email address',
//                   labelStyle: TextStyle(color: CustomColors.textField),
//                   counterText: '',
//                   filled: true,
//                   fillColor: Colors.white,
//                   prefixIcon:  Icon(Icons.mail_outlined, color: CustomColors.textField),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: CustomColors.textField),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(
//                       color: CustomColors.textField.withOpacity(0.8),
//                       width: 2,
//                     ),
//                   ),
//                 ),
//                 onChanged: (_) {
//                   if (_emailError != null) {
//                     setState(() => _emailError = null);
//                   }
//                 },
//               ),
//               if (_emailError != null) ...[
//                 const SizedBox(height: 4),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8),
//                   child: Text(_emailError!,  style: const TextStyle(color: Colors.red ,  fontSize: 14)),
//                 ),
//               ],
//               const SizedBox(height: 20),
//
//               // Send Reset Link button
//               SizedBox(
//                 width: double.infinity,
//                 height: 45,
//                 child: ElevatedButton(
//                   onPressed: _isSending ? null : _sendResetLink,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Theme.of(context).colorScheme.primary,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: _isSending
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                               color: Colors.white, strokeWidth: 2),
//                         )
//                       : const Text('Send Reset Link' ,
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 14,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               // Login with Password button
//               SizedBox(
//                 width: double.infinity,
//                 height: 45,
//                 child: OutlinedButton(
//                   onPressed: () {
//                     Navigator.of(context).pushReplacement(
//                       createRightToLeftRoute(const LoginPage()),
//                     );
//                   },
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(
//                         color: Theme.of(context).colorScheme.primary),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: Text(
//                     'Login with Password',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Theme.of(context).colorScheme.primary,
//                       fontFamily: 'Poppins',
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../config/Animation/righttoleft_animation.dart';
import '../../config/theme.dart';
import './login_page.dart';
import 'package:my_app/backend/api_requests/auth_api.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailCtrl = TextEditingController();
  String? _emailError;
  bool _isSending = false;

  bool get _isEmailValid =>
      _emailCtrl.text.isNotEmpty &&
          RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailCtrl.text.trim());

  Future<void> _sendResetLink() async {
    final email = _emailCtrl.text.trim();
    setState(() {
      _emailError = !_isEmailValid ? 'Please enter a valid email' : null;
    });

    if (!_isEmailValid) return;

    setState(() => _isSending = true);

    try {
      await AuthApi.forgotPassword(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reset link sent to your email')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 30),

                // 🖼️ Logo Image
                Image.asset(
                  'assets/images/logo.png',
                  height: 40,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image,
                      size: 60, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // TextField(
                //   controller: _emailCtrl,
                //   keyboardType: TextInputType.emailAddress,
                //   decoration: InputDecoration(
                //     labelText: 'Email address',
                //     labelStyle: TextStyle(color: CustomColors.textField),
                //     counterText: '',
                //     filled: true,
                //     fillColor: Colors.white,
                //     prefixIcon: Icon(Icons.mail_outlined, color: CustomColors.textField),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10),
                //       borderSide: BorderSide(color: CustomColors.textField),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10),
                //       borderSide: BorderSide(
                //         color: CustomColors.textField.withOpacity(0.8),
                //         width: 2,
                //       ),
                //     ),
                //   ),
                //   onChanged: (_) {
                //     if (_emailError != null) {
                //       setState(() => _emailError = null);
                //     }
                //   },
                // ),

                TextField(
                  decoration: buildInputDecoration(
                    labelText: 'Email address',
                    prefixIcon: Icons.mail_outlined,
                  ),
                  onChanged: (_) {
                    if (_emailError != null) {
                      setState(() => _emailError = null);
                    }
                  },
                ),



                if (_emailError != null) ...[
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(_emailError!,
                        style: const TextStyle(color: Colors.red, fontSize: 14)),
                  ),
                ],
                const SizedBox(height: 20),

                // Send Reset Link button
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _isSending ? null : _sendResetLink,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSending
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                        : const Text('Send Reset Link',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Login with Password button
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        createRightToLeftRoute(const LoginPage()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Login with Password',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}