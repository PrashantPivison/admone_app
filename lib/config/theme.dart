import 'package:flutter/material.dart';

class CustomColors {
  // Custom color constants
  static const Color redBackground = Color(0xFFD84040);
  static const Color text = Color(0xFF000000); // Black (fully opaque)
  static const Color textGrey = Color(0xFF00000080); // Black (fully opaque)
  static const Color textField = Color(0x33000000); // Black with 20% opacity

  // chats styling color
  static const Color chatsgrey = Color(0xFFF2F2F2); // <-- fixed
  static const Color chatsborder = Color(0xFFDDDDDD); // <-- fixed
  static const Color chatsgreen = Color(0xFFDFF6E5); // <-- fixed
}

const btntext = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  fontFamily: "inter",
);

const chatsmessage = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  fontFamily: "inter",
  color: Colors.black,
);

// Main app theme configuration
final ThemeData customTheme = ThemeData(
  fontFamily: "Inter", // Default font family
  primaryColor: const Color(
      0x255597), // Primary color (note: this is an unusual color value)
  scaffoldBackgroundColor:
      const Color(0xFFE9ECEF), // Background color for Scaffold

  // Color scheme for light theme
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF1F468E), // Primary color for widgets
    secondary: Color(0xFF6C757D), // Secondary color for widgets
    onSecondary: Colors.white, // Color for content on secondary color
    tertiary: Color(0xFF0E5FF5), // Tertiary color
    onTertiary: Colors.white, // Color for content on tertiary color
    background: Color(0xFFE9ECEF), // Background color
    onBackground: Color(0xFF262A2E), // Color for content on background
    surface: Colors.white, // Surface color (for cards, sheets, etc.)
    onSurface: Color(0xFF262A2E), // Color for content on surface
    error: Color(0xFFD93933), // Error color
    onError: Colors.white, // Color for content on error color
    outline: Color(0xFFBDBDBD), // Outline/border color
    inverseSurface: Color(0xFF303030), // Inverse surface color
    inversePrimary: Color(0xFF4179C5), // Inverse primary color
  ),

  // Card theme configuration
  cardTheme: CardTheme(
    color: Colors.white, // Card background color
    elevation: 4, // Default elevation
    shadowColor: const Color(0x10000000), // Shadow color with 6% opacity
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0), // Card corner radius
    ),
  ),

  // Text theme configuration
  textTheme: const TextTheme(
    // Display text styles
    displayLarge: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    displaySmall: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),

    // Headline text styles
    headlineLarge:
        TextStyle(fontSize: 32, fontWeight: FontWeight.w600), // In use
    headlineMedium:
        TextStyle(fontSize: 24, fontWeight: FontWeight.w600), // In use
    headlineSmall:
        TextStyle(fontSize: 21, fontWeight: FontWeight.w500), // In use

    // Title text styles
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),

    // Body text styles
    bodyMedium: TextStyle(fontSize: 16), // In use
    bodySmall: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
    ), // In use

    // Label text styles (used for buttons, tabs, etc.)
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), // In use
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
    // In use
  ),

// btntextTheme: const TextTheme(
//   btntext: TextStyle(
//     fontFamily: 'DM Sans',
//     fontSize: 24.0,
//     fontWeight: FontWeight.600,
//   ),
// )
  // Button theme configuration
  // buttonTheme: ButtonThemeData(
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(8.0), // Button corner radius
  //   ),
  //   buttonColor: const Color(0xFF1F468E), // Default button color
  // ),
);

//
// InputDecoration buildInputDecoration({
//   required String labelText,
//   required IconData prefixIcon,
// }) {
//   return InputDecoration(
//     labelText: labelText,
//     labelStyle: TextStyle(color: CustomColors.textField),
//     filled: true,
//     fillColor: Colors.white,
//     prefixIcon: Icon(prefixIcon, color: CustomColors.textField, size: 20),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: BorderSide(color: CustomColors.textField, width: 1.0),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: BorderSide(
//         color: CustomColors.textField.withOpacity(0.8),
//         width: 2.0,
//       ),
//     ),
//     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//     contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//   );
// }


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
        ? GestureDetector(
      onTap: onSuffixTap,
      child: Icon(suffixIcon, color: CustomColors.textField, size: 20),
    )
        : null,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: CustomColors.textField, width: 1.0),
      // borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: CustomColors.textField.withOpacity(0.8),
        width: 2.0,
      ),
    ),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
  );
}
