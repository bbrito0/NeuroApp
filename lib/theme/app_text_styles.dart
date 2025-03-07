import 'package:flutter/cupertino.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String _fontFamily = '.SF Pro Text';

  // Headings
  static const TextStyle heading1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.38,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.35,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
    height: 1.3,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.24,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
  );

  // Special Text Styles
  static TextStyle welcomeTitle = const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
    height: 1.2,
  );

  static TextStyle welcomeName = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.36,
    height: 1.1,
    color: AppColors.primary,
  );

  static TextStyle actionButton = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.24,
    color: AppColors.primary,
  );

  static TextStyle secondaryText = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
    color: AppColors.secondaryLabel,
  );

  // Helper method to apply color to any style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  // Helper method to apply weight to any style
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  // Helper method to apply height to any style
  static TextStyle withHeight(TextStyle style, double height) {
    return style.copyWith(height: height);
  }
} 