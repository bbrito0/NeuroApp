import 'package:flutter/material.dart';
import './app_colors.dart';

class AppTextStyles {
  static const String _fontFamily = '.SF Pro Text';

  // Base Styles
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.08,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.24,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.41,
    height: 1.3,
  );
  
  static const TextStyle heading1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.38,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.35,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.41,
  );
  
  static const TextStyle heading4 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
  );
  
  // Component-specific Styles
  static TextStyle get secondaryText => withColor(
    bodySmall, 
    AppColors.textSecondary,
  );
  
  static TextStyle get actionButton => withColor(
    bodyMedium.copyWith(
      fontWeight: FontWeight.w400,
    ),
    AppColors.primary,
  );
  
  // Helper Methods
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
  
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }
  
  static TextStyle withHeight(TextStyle style, double height) {
    return style.copyWith(height: height);
  }
  
  // Get a style that adapts to the current theme
  static TextStyle adaptive(TextStyle style, {bool isPrimary = true}) {
    // For primary text (headings, main content)
    if (isPrimary) {
      return style.copyWith(
        color: AppColors.textPrimary,
      );
    } 
    // For secondary text (descriptions, subtitles)
    else {
      return style.copyWith(
        color: AppColors.textSecondary,
      );
    }
  }
} 