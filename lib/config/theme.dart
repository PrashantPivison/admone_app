import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomColors {
  // Custom color constants
  static const Color redBackground = Color(0xFFD84040);
  static const Color text = Color(0xFF000000); // Black (fully opaque)
  static const Color textGrey = Color(0x80000000); // Black with 50% opacity
  static const Color textField = Color(0x33000000); // Black with 20% opacity

  // Chats styling colors
  static const Color chatsGrey = Color(0xFFEEEEEE);
  static const Color chatsBorder = Color(0xFFDDDDDD);
  static const Color chatsGreen = Color(0xFFDFF6E5);
}

// Text styles
const btnText = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  fontFamily: "Inter",
);

const chatsMessage = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  fontFamily: "Inter",
  color: Colors.black,
);

// Main app theme configuration
final ThemeData customTheme = ThemeData(
  fontFamily: "Inter",
  // Default font family
  primaryColor: const Color(0x255597),
  // Primary color
  scaffoldBackgroundColor: const Color(0xFFE9ECEF),
  // Scaffold background

  // Color scheme for light theme
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF1F468E),
    // Primary color for widgets
    secondary: Color(0xFF6C757D),
    // Secondary color
    onSecondary: Colors.white,
    // Content on secondary color
    tertiary: Color(0xFF0E5FF5),
    // Tertiary color
    onTertiary: Colors.white,
    // Content on tertiary color
    background: Color(0xFFE9ECEF),
    // Background color
    onBackground: Color(0xFF262A2E),
    // Content on background
    surface: Colors.white,
    // Surface color (cards, sheets)
    onSurface: Color(0xFF262A2E),
    // Content on surface
    error: Color(0xFFD93933),
    // Error color
    onError: Colors.white,
    // Content on error color
    outline: Color(0xFFBDBDBD),
    // Outline/border color
    inverseSurface: Color(0xFF303030),
    // Inverse surface
    inversePrimary: Color(0xFF4179C5), // Inverse primary
  ),

  // Card theme
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 4,
    shadowColor: const Color(0x10000000), // 6% opacity
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
  ),

  // Text theme
  textTheme: const TextTheme(
    // Display styles
    displayLarge: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w500,
    ),

    // Headline styles
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.w500,
    ),

    // Title styles
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),

    // Body styles
    bodyMedium: TextStyle(
      fontSize: 16,
    ),
    bodySmall: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
    ),

    // Label styles (buttons, tabs)
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
    ),
  ),
);

// Input decoration builder
InputDecoration buildInputDecoration({
  required String labelText,
  required IconData prefixIcon,
  IconData? suffixIcon,
  VoidCallback? onSuffixTap,
}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: const TextStyle(color: CustomColors.textField),
    filled: true,
    fillColor: Colors.white,
    prefixIcon: Icon(
      prefixIcon,
      color: CustomColors.textField,
      size: 20,
    ),
    suffixIcon: suffixIcon != null
        ? GestureDetector(
            onTap: onSuffixTap,
            child: Icon(
              suffixIcon,
              color: CustomColors.textField,
              size: 20,
            ),
          )
        : null,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: CustomColors.textField,
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: CustomColors.textField.withOpacity(0.8),
        width: 2.0,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    contentPadding: const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 12,
    ),
  );
}

// Button theme extensions
extension BlueButtonThemeExtension on ThemeData {
  ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        minimumSize: const Size(double.infinity, 45),
      );

  TextStyle get primaryButtonTextStyle => const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  ButtonStyle get outlinedPrimaryButtonStyle => OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(color: colorScheme.primary),
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 10),
        minimumSize: const Size(double.infinity, 45),
      );
}

// shimmer loading effect

class ShimmerPlaceholder extends StatelessWidget {
  const ShimmerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 25,
                  height: 25,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 150,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
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
