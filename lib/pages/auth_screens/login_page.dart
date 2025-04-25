// import 'package:flutter/material.dart';
// import 'package:my_app/backend/api_requests/auth_api.dart';
// import 'package:provider/provider.dart';
// import 'package:my_app/app_state.dart';
// import '../../config/Animation/righttoleft_animation.dart';
// import '../../config/theme.dart';
// import './login_otp_1.dart';
// import './login_with_otp.dart';
// import 'package:url_launcher/url_launcher.dart';

// class LoginPage extends StatelessWidget {
//   LoginPage({super.key});

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   Future<void> _handleLogin(BuildContext context) async {
//     final appState = Provider.of<AppState>(context, listen: false);

//     await appState.login(
//       email: _emailController.text.trim(),
//       password: _passwordController.text.trim(),
//     );
//   }

//   Future<void> _handleForgotPassword(BuildContext context) async {
//     final email = _emailController.text.trim();

//     if (email.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter your email first')),
//       );
//       return;
//     }

//     try {
//       await AuthApi.forgotPassword(email: email);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Password reset link sent to your email')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final appState = Provider.of<AppState>(context);

//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildLogo(context),
//                 const SizedBox(height: 10),
//                 _buildLoginTitle(context),
//                 const SizedBox(height: 15),
//                 _buildLoginSubtitle(context),
//                 const SizedBox(height: 20),
//                 _buildEmailField(),
//                 const SizedBox(height: 10),
//                 _buildPasswordField(),
//                 const SizedBox(height: 20),

//                 // Login Button or Loading Indicator
//                 appState.isLoading
//                     ? const CircularProgressIndicator()
//                     : _buildLoginButton(context),

//                 const SizedBox(height: 10),

//                 // OTP Login Button
//                 _buildOtpLoginButton(context),

//                 const SizedBox(height: 15),
//                 _buildForgotPasswordLink(context),

//                 if (appState.errorMessage.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Text(
//                       appState.errorMessage,
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLogo(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 30.0),
//       child: Image.asset(
//         'assets/images/logo.png',
//         height: 40,
//         errorBuilder: (context, error, stackTrace) => const Icon(
//           Icons.broken_image,
//           size: 60,
//           color: Colors.grey,
//         ),
//       ),
//     );
//   }

//   Widget _buildLoginTitle(BuildContext context) {
//     return Text(
//       'Login to Admone',
//       style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//             fontFamily: 'Poppins',
//           ),
//     );
//   }

//   Widget _buildLoginSubtitle(BuildContext context) {
//     return Text(
//       'Enter your registered email address to login',
//       textAlign: TextAlign.center,
//       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//             fontFamily: 'Inter',
//           ),
//     );
//   }

//   Widget _buildEmailField() {
//     return SizedBox(
//       height: 45,
//       child: TextField(
//         controller: _emailController,
//         keyboardType: TextInputType.emailAddress,
//         decoration: _buildInputDecoration(
//           labelText: 'Email address',
//           prefixIcon: Icons.mail_outlined,
//         ),
//       ),
//     );
//   }

//   Widget _buildPasswordField() {
//     return SizedBox(
//       height: 45,
//       child: TextField(
//         controller: _passwordController,
//         obscureText: true,
//         decoration: _buildInputDecoration(
//           labelText: 'Password',
//           prefixIcon: Icons.lock_open_rounded,
//           suffixIcon: Icons.visibility,
//         ),
//       ),
//     );
//   }

//   InputDecoration _buildInputDecoration({
//     required String labelText,
//     required IconData prefixIcon,
//     IconData? suffixIcon,
//   }) {
//     return InputDecoration(
//       labelText: labelText,
//       labelStyle: TextStyle(color: CustomColors.textField),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide(color: CustomColors.textField, width: 1.0),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide(
//           color: CustomColors.textField.withOpacity(0.8),
//           width: 2.0,
//         ),
//       ),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//       filled: true,
//       fillColor: Colors.white,
//       prefixIcon: Icon(prefixIcon, color: CustomColors.textField, size: 20),
//       suffixIcon: suffixIcon != null
//           ? Icon(suffixIcon, color: CustomColors.textField, size: 20)
//           : null,
//     );
//   }

//   Widget _buildLoginButton(BuildContext context) {
//     return SizedBox(
//       height: 45,
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: () => _handleLogin(context),
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
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

//   Widget _buildForgotPasswordLink(BuildContext context) {
//     return TextButton(
//       onPressed: () => _handleForgotPassword(context),
//       child: Text(
//         'Forgot Password?',
//         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w600,
//             ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/backend/api_requests/auth_api.dart';
import 'package:my_app/app_state.dart';
// import your BottomNavScreen so we can navigate to it:
import 'package:my_app/main.dart';
import '../../config/Animation/righttoleft_animation.dart';
import '../../config/theme.dart';
import './login_with_otp.dart';
import './login_otp_1.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleLogin(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);

    // 1) trigger your AppState.login (sets isLoading, isLoggedIn, token, etc.)
    await appState.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // 2) once isLoggedIn flips to true, clear everything and go to dashboard
    if (appState.isLoggedIn) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const BottomNavScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _handleForgotPassword(BuildContext context) async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email first')),
      );
      return;
    }

    try {
      await AuthApi.forgotPassword(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset link sent to your email')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(context),
                const SizedBox(height: 10),
                _buildLoginTitle(context),
                const SizedBox(height: 15),
                _buildLoginSubtitle(context),
                const SizedBox(height: 20),
                _buildEmailField(),
                const SizedBox(height: 10),
                _buildPasswordField(),
                const SizedBox(height: 20),

                // Login Button or Loading Indicator
                appState.isLoading
                    ? const CircularProgressIndicator()
                    : _buildLoginButton(context),

                const SizedBox(height: 10),

                // OTP Login Button
                _buildOtpLoginButton(context),

                const SizedBox(height: 15),
                _buildForgotPasswordLink(context),

                if (appState.errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      appState.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Image.asset(
        'assets/images/logo.png',
        height: 40,
        errorBuilder: (context, error, stackTrace) => const Icon(
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
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontFamily: 'Poppins',
          ),
    );
  }

  Widget _buildLoginSubtitle(BuildContext context) {
    return Text(
      'Enter your registered email address to login',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontFamily: 'Inter',
          ),
    );
  }

  Widget _buildEmailField() => SizedBox(
        height: 45,
        child: TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _buildInputDecoration(
            labelText: 'Email address',
            prefixIcon: Icons.mail_outlined,
          ),
        ),
      );

  Widget _buildPasswordField() => SizedBox(
        height: 45,
        child: TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: _buildInputDecoration(
            labelText: 'Password',
            prefixIcon: Icons.lock_open_rounded,
            suffixIcon: Icons.visibility,
          ),
        ),
      );

  InputDecoration _buildInputDecoration({
    required String labelText,
    required IconData prefixIcon,
    IconData? suffixIcon,
  }) =>
      InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: CustomColors.textField),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CustomColors.textField, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: CustomColors.textField.withOpacity(0.8),
            width: 2.0,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(prefixIcon, color: CustomColors.textField, size: 20),
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: CustomColors.textField, size: 20)
            : null,
      );

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handleLogin(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
      height: 45,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            createRightToLeftRoute(LoginWithOtp()),
          );
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: Text(
          "Login with OTP",
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.primary,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink(BuildContext context) {
    return TextButton(
      onPressed: () => _handleForgotPassword(context),
      child: Text(
        'Forgot Password?',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
