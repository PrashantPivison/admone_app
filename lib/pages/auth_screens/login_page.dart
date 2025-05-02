import 'package:flutter/material.dart';
import 'package:my_app/main.dart';
import 'package:my_app/pages/auth_screens/auth_setup_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_app/app_state.dart';
import '../../config/Animation/righttoleft_animation.dart';
import '../../config/theme.dart';
import './login_with_otp.dart';
import './forgot_password_page.dart';
import 'package:my_app/backend/api_requests/auth_api.dart';
import 'main_flow_redirector.dart';

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
  bool _obscurePassword = true; // toggle visibility

  bool get _canSubmit =>
      (_emailError == null && _passwordError == null) &&
      _emailCtrl.text.isNotEmpty &&
      _passwordCtrl.text.isNotEmpty;

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
    });

    if (!_canSubmit) return;

    final appState = Provider.of<AppState>(context, listen: false);
    await appState.login(email: email, password: pass);

    if (appState.isLoggedIn) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthSetupScreen()),
        (route) => false,
      );
    }
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: CustomColors.textField),
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(prefixIcon, color: CustomColors.textField, size: 20),
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
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
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
              _buildEmailField(),
              if (_emailError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(_emailError!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 14)),
                ),
              const SizedBox(height: 10),
              _buildPasswordField(),
              if (_passwordError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(_passwordError!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 14)),
                ),
              const SizedBox(height: 20),
              appState.isLoading
                  ? const CircularProgressIndicator()
                  : _buildLoginButton(context),
              const SizedBox(height: 10),
              _buildOtpLoginButton(context),
              const SizedBox(height: 15),
              _buildForgotPasswordLink(context),
              if (appState.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    appState.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
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

  Widget _buildEmailField() {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: _emailCtrl,
        keyboardType: TextInputType.emailAddress,
        decoration: _buildInputDecoration(
          labelText: 'Email address',
          prefixIcon: Icons.mail_outlined,
        ),
        onChanged: (_) => setState(() => _emailError = null),
      ),
    );
  }

  Widget _buildPasswordField() {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: _passwordCtrl,
        obscureText: _obscurePassword,
        decoration: _buildInputDecoration(
          labelText: 'Password',
          prefixIcon: Icons.lock_open_rounded,
        ).copyWith(
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: CustomColors.textField,
              size: 20,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        onChanged: (_) => setState(() => _passwordError = null),
      ),
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
      onPressed: () {
        Navigator.push(
          context,
          createRightToLeftRoute(const ForgotPasswordPage()),
        );
      },
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
