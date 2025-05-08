import 'package:flutter/material.dart';
import 'package:my_app/pages/home_screens/Home_page.dart';
import '../../config/theme.dart';

import '../../config/Animation/righttoleft_animation.dart';

class LoginFaceid extends StatelessWidget {
  LoginFaceid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Centered content
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

            // Bottom section with button and forgot password
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
        'assets/images/faceid.png',
        height: 130,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.broken_image,
          size: 130,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildLoginTitle(BuildContext context) {
    return Text(
      'Allow Face ID',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildLoginSubtitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        'Enable Face ID authentication for quick and secure access.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'Inter',
              height: 1.5,
            ),
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
         onPressed: () {
            Navigator.push(
              context,
              createRightToLeftRoute(HomePage()),
            );
          },
        style: Theme.of(context).primaryButtonStyle,
        child: Text(
          "Turn on Face ID",
          style: Theme.of(context).primaryButtonTextStyle,
        ),
      ),
      // child: ElevatedButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       createRightToLeftRoute(HomePage()),
      //     );
      //   },
      //   style: ElevatedButton.styleFrom(
      //     backgroundColor: Theme.of(context).colorScheme.primary,
      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      //     padding: const EdgeInsets.symmetric(vertical: 10),
      //   ),
      //   child: Text(
      //     "Turn on Face ID",
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

  Widget _buildMaybeLaterLink(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextButton(
        onPressed: _handleForgotPassword,
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

  void _handleForgotPassword() {
    print("Forgot password pressed!");
    // Add forgot password logic here
  }
}
