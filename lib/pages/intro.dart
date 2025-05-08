import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Splash.png'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
          // Loader Positioned at Bottom Center, Slightly Up
          Align(
            // alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 300), // Adjust value as needed
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white), // Change color if needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
