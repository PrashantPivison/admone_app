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
import 'package:provider/provider.dart';
import '../../config/Animation/righttoleft_animation.dart';
import '../../config/theme.dart';
import './login_page.dart';
import '../../backend/api_requests/auth_api.dart';
import '../../app_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailCtrl = TextEditingController();
  String? _emailError;
  bool _isSending = false;
  String? _successMessage;
  String? _errorMessage;

  bool get _isEmailValid =>
      _emailCtrl.text.isNotEmpty &&
          RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailCtrl.text.trim());

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    final email = _emailCtrl.text.trim();

    setState(() {
      _emailError = !_isEmailValid ? 'Please enter a valid email' : null;
      _successMessage = null;
      _errorMessage = null;
    });

    if (!_isEmailValid) return;

    setState(() => _isSending = true);

    try {
      await AuthApi.forgotPassword(email: email);
      setState(() {
        _successMessage = 'Reset link sent to your email';
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().contains('not found')
            ? 'Email not found. Please check and try again.'
            : 'Failed to send reset link. Please try again.';
      });
    } finally {
      setState(() => _isSending = false);
    }
  }

  InputDecoration buildInputDecoration({
    required String labelText,
    required IconData prefixIcon,
    bool hasError = false,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: CustomColors.textField),
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(
          prefixIcon,
          color: CustomColors.textField,
          size: 20
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: hasError ? Colors.red : CustomColors.textField,
            width: 1.0
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: hasError ? Colors.red : CustomColors.textField.withOpacity(0.8),
            width: 2.0
        ),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    _buildLogo(),
                    const SizedBox(height: 30),
                    _buildForgotPasswordTitle(),
                    const SizedBox(height: 15),
                    _buildInstructionsText(),
                    const SizedBox(height: 30),
                    _buildEmailField(),
                    if (_emailError != null) ...[
                      const SizedBox(height: 8),
                      ErrorTextWidget(message: _emailError!),
                    ],
                    const SizedBox(height: 20),
                    _buildSendResetButton(),
                    const SizedBox(height: 12),
                    _buildLoginWithPasswordButton(),
                  ],
                ),
              ),
            ),
          ),

          // Success/Error messages
          if (_successMessage != null)
            Positioned(
              top: 20,
              left: 16,
              right: 16,
              child: _buildTopMessage(_successMessage!, isError: false),
            ),

          if (_errorMessage != null)
            Positioned(
              top: 20,
              left: 16,
              right: 16,
              child: _buildTopMessage(_errorMessage!, isError: true),
            ),
        ],
      ),
    );
  }

  Widget _buildTopMessage(String message, {required bool isError}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isError ? Colors.red : Colors.green,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isError ? Colors.red : Colors.green),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error : Icons.check_circle,
            color: Colors.white,
            size: 20,
          ),
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
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
            onPressed: () => setState(() {
              _successMessage = null;
              _errorMessage = null;
            }),
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

  Widget _buildForgotPasswordTitle() {
    return Text(
      'Forgot Password?',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInstructionsText() {
    return Text(
      'Enter your registered email to receive password reset instructions',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildEmailField() {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: _emailCtrl,
        keyboardType: TextInputType.emailAddress,
        decoration: buildInputDecoration(
          labelText: 'Email address',
          prefixIcon: Icons.mail_outlined,
          hasError: _emailError != null || _errorMessage != null,
        ),
        onChanged: (_) {
          if (_emailError != null || _errorMessage != null) {
            setState(() {
              _emailError = null;
              _errorMessage = null;
            });
          }
        },
      ),
    );
  }

  Widget _buildSendResetButton() {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: _isSending ? null : _sendResetLink,
        style: Theme.of(context).primaryButtonStyle,
        child: Text(
          "Send Reset Link",
          style: Theme.of(context).primaryButtonTextStyle,
        ),
      ),
      // child: ElevatedButton(
      //   onPressed: _isSending ? null : _sendResetLink,
      //   style: ElevatedButton.styleFrom(
      //     backgroundColor: Theme.of(context).colorScheme.primary,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(8),
      //     ),
      //   ),
      //   child: _isSending
      //       ? const SizedBox(
      //     width: 20,
      //     height: 20,
      //     child: CircularProgressIndicator(
      //       color: Colors.white,
      //       strokeWidth: 2,
      //     ),
      //   )
      //       : Text(
      //     'Send Reset Link',
      //     style: TextStyle(
      //       fontFamily: 'Poppins',
      //       fontSize: 14,
      //       color: Theme.of(context).colorScheme.surface,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildLoginWithPasswordButton() {
    return SizedBox(
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
      //     side: BorderSide(color: Theme.of(context).colorScheme.primary),
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(8),
      //     ),
      //   ),
      //   child: Text(
      //     'Login with Password',
      //     style: TextStyle(
      //       fontSize: 14,
      //       color: Theme.of(context).colorScheme.primary,
      //       fontFamily: 'Poppins',
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      // ),
    );
  }
}

class ErrorTextWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const ErrorTextWidget({
    Key? key,
    required this.message,
    this.icon = Icons.error_outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.red),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            message,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }
}