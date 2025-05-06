// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:my_app/main.dart';
// import 'package:my_app/pages/auth_screens/auth_setup_screen.dart';
// import 'package:my_app/app_state.dart';
// import '../../config/Animation/righttoleft_animation.dart';
// import '../../config/theme.dart';
// import './login_with_otp.dart';
// import './forgot_password_page.dart';
// import 'package:my_app/backend/api_requests/auth_api.dart';
// import 'main_flow_redirector.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final _emailCtrl = TextEditingController();
//   final _passwordCtrl = TextEditingController();
//   String? _emailError;
//   String? _passwordError;
//   bool _obscurePassword = true;
//
//   bool get _canSubmit =>
//       (_emailError == null && _passwordError == null) &&
//           _emailCtrl.text.isNotEmpty &&
//           _passwordCtrl.text.isNotEmpty;
//
//   Future<void> _validateAndLogin() async {
//     final email = _emailCtrl.text.trim();
//     final pass = _passwordCtrl.text;
//
//     setState(() {
//       _emailError = email.isEmpty
//           ? 'Please enter a valid email address'
//           : (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)
//           ? 'Enter a valid email'
//           : null);
//
//           _passwordError = pass.isEmpty
//           ? 'Password must be at least 6 characters long'
//               : (pass.length < 6 ? 'Min. 6 characters' : null);
//     });
//
//     if (!_canSubmit) return;
//
//     final appState = Provider.of<AppState>(context, listen: false);
//     await appState.login(email: email, password: pass);
//
//     if (appState.isLoggedIn) {
//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (_) => const AuthSetupScreen()),
//             (route) => false,
//       );
//     }
//   }
//
//   InputDecoration buildInputDecoration({
//     required String labelText,
//     required IconData prefixIcon,
//     IconData? suffixIcon,
//     VoidCallback? onSuffixTap,
//   }) {
//     return InputDecoration(
//       labelText: labelText,
//       labelStyle: TextStyle(color: CustomColors.textField),
//       filled: true,
//       fillColor: Colors.white,
//       prefixIcon: Icon(prefixIcon, color: CustomColors.textField, size: 20),
//       suffixIcon: suffixIcon != null
//           ? IconButton(
//         icon: Icon(suffixIcon, color: CustomColors.textField, size: 20),
//         onPressed: onSuffixTap,
//       )
//           : null,
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide(color: CustomColors.textField, width: 1.0),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide(
//             color: CustomColors.textField.withOpacity(0.8), width: 2.0),
//       ),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//       contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//     );
//   }
//
//   @override
//   void dispose() {
//     _emailCtrl.dispose();
//     _passwordCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final appState = Provider.of<AppState>(context);
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: Stack(
//         children: [
//           Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 25.0),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 50), // leave space for the top message
//                   _buildLogo(),
//                   const SizedBox(height: 10),
//                   _buildLoginTitle(context),
//                   const SizedBox(height: 15),
//                   _buildLoginSubtitle(context),
//                   const SizedBox(height: 20),
//                   _buildInputFields(),
//                   const SizedBox(height: 20),
//                   _buildActionButtons(context, appState),
//                   if (appState.errorMessage.isNotEmpty)
//                     _buildErrorMessage(appState),
//                 ],
//               ),
//             ),
//           ),
//             _buildTopSuccessMessage(appState.errorMessage),
//             // _buildTopErrorMessage(appState.errorMessage),
//         ],
//       ),
//     );
//
//
//   }
//
//   Widget _buildTopErrorMessage(String message) {
//     return Positioned(
//       top: 100,
//       left: 16,
//       right: 16,
//       child: Container(
//         width: 300,
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
//         decoration: BoxDecoration(
//           color: Colors.red,
//           border: Border.all(color: Colors.red),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Icon(Icons.error, color: Colors.white, size: 20),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 "This email address does not exist. Please enter valid details.This email address does not exist. Please enter valid details.",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontFamily: "inter",
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTopSuccessMessage(String message) {
//     return Positioned(
//       top: 100,
//       left: 16,
//       right: 16,
//       child: Container(
//         width: 200.0,
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
//         decoration: BoxDecoration(
//           color: Colors.green,
//           border: Border.all(color: Colors.green),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Icon(Icons.check_circle, color: Colors.white, size: 20),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 "Login Successful.",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontFamily: "inter",
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLogo() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 30.0),
//       child: Image.asset(
//         'assets/images/logo.png',
//         height: 40,
//         errorBuilder: (_, __, ___) => const Icon(
//           Icons.broken_image,
//           size: 60,
//           color: Colors.grey,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoginTitle(BuildContext context) {
//     return Text(
//       'Login to Admone',
//       style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//         fontFamily: 'Poppins',
//       ),
//     );
//   }
//
//   Widget _buildLoginSubtitle(BuildContext context) {
//     return Text(
//       'Enter your registered email address to login',
//       textAlign: TextAlign.center,
//       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//         fontFamily: 'Inter',
//       ),
//     );
//   }
//
//   Widget _buildInputFields() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildEmailField(),
//         if (_emailError != null) _buildErrorText(_emailError!),
//         const SizedBox(height: 10),
//         _buildPasswordField(),
//         if (_passwordError != null) _buildErrorText(_passwordError!),
//       ],
//     );
//   }
//
//   Widget _buildEmailField() {
//     return SizedBox(
//       height: 45,
//       child: TextField(
//         controller: _emailCtrl,
//         keyboardType: TextInputType.emailAddress,
//         decoration: buildInputDecoration(
//           labelText: 'Email address',
//           prefixIcon: Icons.mail_outlined,
//         ),
//         onChanged: (_) => setState(() => _emailError = null),
//       ),
//     );
//   }
//
//   Widget _buildPasswordField() {
//     return SizedBox(
//       height: 45,
//       child: TextField(
//         controller: _passwordCtrl,
//         obscureText: _obscurePassword,
//         decoration: buildInputDecoration(
//           labelText: 'Password',
//           prefixIcon: Icons.lock_open_rounded,
//           suffixIcon: _obscurePassword ? Icons.visibility : Icons.visibility_off,
//           onSuffixTap: () => setState(() => _obscurePassword = !_obscurePassword),
//         ),
//         onChanged: (_) => setState(() => _passwordError = null),
//       ),
//     );
//   }
//
//   Widget _buildErrorText(String error) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
//       child: Row(
//         children: [
//           const Icon(Icons.error, size: 16, color: Colors.red),
//           const SizedBox(width: 5),
//           Text(
//             error,
//             style: const TextStyle(color: Colors.red, fontSize: 12),
//           ),
//
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButtons(BuildContext context, AppState appState) {
//     return Column(
//       children: [
//         appState.isLoading
//             ? const CircularProgressIndicator()
//             : _buildLoginButton(context),
//         const SizedBox(height: 10),
//         _buildOtpLoginButton(context),
//         const SizedBox(height: 15),
//         _buildForgotPasswordLink(context),
//       ],
//     );
//   }
//
//   Widget _buildLoginButton(BuildContext context) {
//     return SizedBox(
//       height: 45,
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: _validateAndLogin,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           padding: const EdgeInsets.symmetric(vertical: 10),
//         ),
//         child: Text(
//           "Log in",
//           style: TextStyle(
//             fontFamily: 'Poppins',
//             fontSize: 14,
//             color: Theme.of(context).colorScheme.surface,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOtpLoginButton(BuildContext context) {
//     return SizedBox(
//       height: 45,
//       width: double.infinity,
//       child: OutlinedButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             createRightToLeftRoute(LoginWithOtp()),
//           );
//         },
//         style: OutlinedButton.styleFrom(
//           side: BorderSide(color: Theme.of(context).colorScheme.primary),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           padding: const EdgeInsets.symmetric(vertical: 10),
//         ),
//         child: Text(
//           "Login with OTP",
//           style: TextStyle(
//             fontSize: 14,
//             color: Theme.of(context).colorScheme.primary,
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildForgotPasswordLink(BuildContext context) {
//     return TextButton(
//       onPressed: () {
//         Navigator.push(
//           context,
//           createRightToLeftRoute(const ForgotPasswordPage()),
//         );
//       },
//       child: Text(
//         'Forgot Password?',
//         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorMessage(AppState appState) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8),
//       child: Text(
//         appState.errorMessage,
//         style: const TextStyle(color: Colors.red),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/pages/auth_screens/auth_setup_screen.dart';
import 'package:my_app/config/Animation/righttoleft_animation.dart';
// import 'package:my_app/config/theme.dart';
import '../../config/theme.dart';
import 'package:my_app/pages/auth_screens/login_with_otp.dart';
import 'package:my_app/pages/auth_screens/forgot_password_page.dart';
import 'package:my_app/app_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String? _emailError;
  String? _passwordError;
  bool _obscurePassword = true;
  String? _successMessage;
  bool _isLoading = false;

  bool get _canSubmit =>
      (_emailError == null && _passwordError == null) &&
          _emailCtrl.text.isNotEmpty &&
          _passwordCtrl.text.isNotEmpty;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _validateAndLogin() async {
    final email = _emailCtrl.text.trim();
    final pass = _passwordCtrl.text;

    setState(() {
      _emailError = email.isEmpty
          ? 'Please enter a valid email address'
          : (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)
          ? 'Enter a valid email'
          : null);

      _passwordError = pass.isEmpty
          ? 'Password must be at least 6 characters long'
          : (pass.length < 6 ? 'Min. 6 characters' : null);

      _successMessage = null;
    });

    if (!_canSubmit) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.login(email: email, password: pass);

      if (appState.isLoggedIn) {
        setState(() {
          _successMessage = 'Login successful!';
        });

        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const AuthSetupScreen()),
                (route) => false,
          );
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  InputDecoration buildInputDecoration({
    required String labelText,
    required IconData prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: CustomColors.textField),
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(prefixIcon, color: CustomColors.textField, size: 20),
      suffixIcon: suffixIcon != null
          ? IconButton(
        icon: Icon(suffixIcon, color: CustomColors.textField, size: 20),
        onPressed: onSuffixTap,
      )
          : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: CustomColors.textField, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: CustomColors.textField.withOpacity(0.8), width: 2.0),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
      Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Main centered content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(),
                  const SizedBox(height: 10),
                  _buildLoginTitle(context),
                  const SizedBox(height: 15),
                  _buildLoginSubtitle(context),
                  const SizedBox(height: 20),
                  _buildInputFields(),
                  const SizedBox(height: 20),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),

          // Success message (fixed at top)
          if (_successMessage != null)
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: _buildTopSuccessMessage(_successMessage!),
            ),

          // Error message (fixed at top)
          if (appState.errorMessage.isNotEmpty && _successMessage == null)
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: SafeArea(
                child: _buildTopErrorMessage(appState.errorMessage),
              ),
            ),
        ],
      ),
    ),



    if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopSuccessMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 20),
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
              "This email address does not exist. Please enter valid details.This email address does not exist. Please enter valid details.",
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Image.asset(
        'assets/images/logo.png',
        height: 40,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.broken_image,
          size: 60,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildLoginTitle(BuildContext context) {
    return Text(
      'Login to Admone',
      style: Theme.of(context)
          .textTheme
          .headlineMedium
          ?.copyWith(fontFamily: 'Poppins'),
    );
  }

  Widget _buildLoginSubtitle(BuildContext context) {
    return Text(
      'Enter your registered email address to login',
      textAlign: TextAlign.center,
      style:
      Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'Inter'),
    );
  }

  Widget _buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEmailField(),
        if (_emailError != null) _buildErrorText(_emailError!),
        const SizedBox(height: 10),
        _buildPasswordField(),
        if (_passwordError != null) _buildErrorText(_passwordError!),
      ],
    );
  }

  Widget _buildEmailField() {
    final appState = Provider.of<AppState>(context);
    final hasError = _emailError != null ||
        (appState.errorMessage.isNotEmpty && _successMessage == null);

    // Start with the base decoration
    var decoration = buildInputDecoration(
      labelText: 'Email address',
      prefixIcon: Icons.mail_outlined,
    );

    // If there's an error, modify the decoration
    if (hasError) {
      decoration = decoration.copyWith(
        // labelStyle: const TextStyle(color: Colors.red),
        // prefixIcon: const Icon(Icons.mail_outlined, color: Colors.red, size: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Maintain your radius
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Maintain your radius
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
      );
    }


    return SizedBox(
      height: 45,
      child: TextField(
        controller: _emailCtrl,
        keyboardType: TextInputType.emailAddress,
        decoration: decoration,
        onChanged: (_) {
          if (_emailError != null || appState.errorMessage.isNotEmpty) {
            setState(() {
              _emailError = null;
              appState.errorMessage = '';
            });
          }
        },
      ),
    );
  }


  Widget _buildPasswordField() {
    final appState = Provider.of<AppState>(context);
    final hasError = _passwordError != null ||
        (appState.errorMessage.isNotEmpty && _successMessage == null);

    // Start with the base decoration
    var decoration = buildInputDecoration(
      labelText: 'Password',
      prefixIcon: Icons.lock_open_rounded,
      suffixIcon: _obscurePassword ? Icons.visibility : Icons.visibility_off,
      onSuffixTap: () => setState(() => _obscurePassword = !_obscurePassword),
    );

    // If there's an error, modify the decoration
    if (hasError) {
      decoration = decoration.copyWith(
        // labelStyle: const TextStyle(color: Colors.red),
        // prefixIcon: const Icon(Icons.lock_open_rounded, color: Colors.red, size: 20),
        // suffixIcon: Icon(
        //   _obscurePassword ? Icons.visibility : Icons.visibility_off,
        //   color: Colors.red,
        //   size: 20,
        // ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Maintain your radius
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Maintain your radius
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
      );
    }

    return SizedBox(
      height: 45,
      child: TextField(
        controller: _passwordCtrl,
        obscureText: _obscurePassword,
        decoration: decoration,
        onChanged: (_) {
          if (_passwordError != null || appState.errorMessage.isNotEmpty) {
            setState(() {
              _passwordError = null;
              appState.errorMessage = '';
            });
          }
        },
      ),
    );
  }



  // Widget _buildEmailField() {
  //   return SizedBox(
  //     height: 45,
  //     child: TextField(
  //       controller: _emailCtrl,
  //       keyboardType: TextInputType.emailAddress,
  //       decoration: buildInputDecoration(
  //         labelText: 'Email address',
  //         prefixIcon: Icons.mail_outlined,
  //       ),
  //       onChanged: (_) => setState(() => _emailError = null),
  //     ),
  //   );
  // }

  // Widget _buildPasswordField() {
  //   return SizedBox(
  //     height: 45,
  //     child: TextField(
  //       controller: _passwordCtrl,
  //       obscureText: _obscurePassword,
  //       decoration: buildInputDecoration(
  //         labelText: 'Password',
  //         prefixIcon: Icons.lock_open_rounded,
  //         suffixIcon:
  //         _obscurePassword ? Icons.visibility : Icons.visibility_off,
  //         onSuffixTap: () =>
  //             setState(() => _obscurePassword = !_obscurePassword),
  //       ),
  //       onChanged: (_) => setState(() => _passwordError = null),
  //     ),
  //   );
  // }

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

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _buildLoginButton(context),
        const SizedBox(height: 10),
        _buildOtpLoginButton(context),
        const SizedBox(height: 15),
        _buildForgotPasswordLink(context),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _validateAndLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: Text(
          "Log in",
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

  Widget _buildOtpLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            createRightToLeftRoute(const LoginWithOtp()),
          );
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        child: Text(
          "Login with OTP",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
        );
      },
      child: Text(
        "Forgot Password?",
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontFamily: "Poppins",
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}