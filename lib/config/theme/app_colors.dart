import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

enum ThemeMode {
  light,
  dark
}

class AppColors {
  // Theme mode - static variable that can be toggled
  static ThemeMode currentTheme = ThemeMode.dark;
  
  // Primary Colors
  static const primary = Color.fromARGB(255, 18, 162, 183);
  static const primaryAlt = Color(0xFF30B0C7);
  
  // Background Gradient Colors - Light Mode
  static const backgroundGradientStartLight = Color.fromARGB(255, 195, 230, 235); // Soft teal
  static const backgroundGradientMiddleLight = Color.fromARGB(255, 195, 230, 235); // Mid teal-blue
  static const backgroundGradientEndLight = Color.fromARGB(255, 195, 230, 235); // Very light blue-white
  
  // Background Gradient Colors - Dark Mode
  static const backgroundGradientStartDark = Color(0xFF0A3F4A); // Deep teal-blue
  static const backgroundGradientMiddleDark = Color(0xFF0A323C); // Midtone teal-blue
  static const backgroundGradientEndDark = Color(0xFF072830); // Even deeper blue
  
  // Gradient Constants
  static const List<double> gradientStops = [0.1, 0.4, 1.0];
  static const List<double> vignetteGradientStops = [0.4, 1.0];
  static const double gradientRadius = 1.5;
  
  // Shadow Constants
  static const double cardShadowBlur = 12.0;
  static const double cardShadowOffsetY = 4.0;
  static const double secondaryShadowBlur = 20.0;
  static const double secondaryShadowOffsetY = 8.0;
  static const double subtleShadowBlur = 8.0;
  static const double subtleShadowOffsetY = 2.0;
  static const double glowShadowBlur = 25.0;
  static const double glowShadowSpread = 3.0;
  static const double cardShadowOpacity = 0.12;
  static const double cardShadowPrimaryOpacity = 0.05;
  static const double cardShadowDarkOpacity = 0.25;
  static const double subtleShadowOpacity = 0.08;
  static const double subtleShadowDarkOpacity = 0.15;
  static const double glowShadowOpacity = 0.15;
  
  // Dynamic Background Colors - based on current theme
  static Color get backgroundGradientStart => currentTheme == ThemeMode.light 
      ? backgroundGradientStartLight 
      : backgroundGradientStartDark;
      
  static Color get backgroundGradientMiddle => currentTheme == ThemeMode.light 
      ? backgroundGradientMiddleLight 
      : backgroundGradientMiddleDark;
      
  static Color get backgroundGradientEnd => currentTheme == ThemeMode.light 
      ? backgroundGradientEndLight 
      : backgroundGradientEndDark;
  
  // Status Colors
  static const success = Color(0xFF34C759);
  
  // System Colors - Light Mode
  static const surfaceLight = CupertinoColors.systemBackground;
  static const textPrimaryLight = Color.fromARGB(255, 44, 43, 43);
  static const textSecondaryLight = CupertinoColors.secondaryLabel;
  
  // System Colors - Dark Mode
  static const surfaceDark = Color(0xFF1A2A30); // Dark surface color that complements the background
  static const textPrimaryDark = Colors.white;
  static const textSecondaryDark = Color(0xFFB0B8BC); // Softer white for secondary text
  
  // System Colors - Dynamic based on theme
  static Color get surface => currentTheme == ThemeMode.light ? surfaceLight : surfaceDark;
  static Color get textPrimary => currentTheme == ThemeMode.light ? textPrimaryLight : textPrimaryDark;
  static Color get textSecondary => currentTheme == ThemeMode.light ? textSecondaryLight : textSecondaryDark;
  
  // Shared System Colors
  static const border = CupertinoColors.separator;
  static const inactive = CupertinoColors.systemGrey;
  static const separator = CupertinoColors.separator;
  static const label = Color.fromARGB(255, 25, 25, 25);
  static const secondaryLabel = CupertinoColors.secondaryLabel;
  static const systemGrey3 = CupertinoColors.systemGrey3;
  static const systemGrey4 = CupertinoColors.systemGrey4;
  static const systemGrey5 = CupertinoColors.systemGrey5;
  static const systemGrey6 = CupertinoColors.systemGrey6;
  
  // Common Opacity Values
  static const backgroundOpacity = 1.0;
  static const surfaceOpacity = 0.8;
  static const borderOpacity = 0.2;
  static const inactiveOpacity = 0.5;
  
  // Card Opacity by Hierarchy - Light Mode
  static const primaryCardOpacityLight = 0.85;
  static const secondaryCardOpacityLight = 0.7;
  static const tertiaryCardOpacityLight = 0.5;
  
  // Card Opacity by Hierarchy - Dark Mode (lower opacity for darker cards)
  static const primaryCardOpacityDark = 0.15;   // Much lower to darken cards
  static const secondaryCardOpacityDark = 0.12;
  static const tertiaryCardOpacityDark = 0.08;
  
  // Dynamic card opacity getters
  static double get primaryCardOpacity => 
      currentTheme == ThemeMode.light ? primaryCardOpacityLight : primaryCardOpacityDark;
  static double get secondaryCardOpacity => 
      currentTheme == ThemeMode.light ? secondaryCardOpacityLight : secondaryCardOpacityDark;
  static double get tertiaryCardOpacity => 
      currentTheme == ThemeMode.light ? tertiaryCardOpacityLight : tertiaryCardOpacityDark;
  
  // App Background Gradient - Universal style with theme-aware colors
  static Gradient get appBackgroundGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      getColorWithOpacity(backgroundGradientStart, backgroundOpacity),
      getColorWithOpacity(backgroundGradientMiddle, backgroundOpacity),
      getColorWithOpacity(backgroundGradientEnd, backgroundOpacity),
    ],
    stops: gradientStops,
  );
  
  // For backward compatibility - all gradient types now use the same style
  static Gradient get primaryGradient => appBackgroundGradient;
  static Gradient get premiumGradient => appBackgroundGradient;
  static Gradient get vignetteGradient => RadialGradient(
    center: Alignment.center,
    radius: gradientRadius,
    colors: [
      backgroundGradientStart,
      backgroundGradientEnd,
    ],
    stops: vignetteGradientStops,
  );

  static Gradient get frostedGlassGradient => LinearGradient(
    begin: const Alignment(-1.0, 1.0),
    end: const Alignment(1.0, -1.0),
    colors: [
      getColorWithOpacity(surface, 0.0),
      getColorWithOpacity(surface, 0.0),
    ],
  );

  static LinearGradient primarySurfaceGradient({double startOpacity = 0.1, double endOpacity = 0.15}) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        getColorWithOpacity(primary, startOpacity),
        getColorWithOpacity(primary, endOpacity),
      ],
    );
  }
  
  // Helper Methods
  static Color getPrimaryWithOpacity(double opacity) => getColorWithOpacity(primary, opacity);
  static Color getSurfaceWithOpacity(double opacity) => getColorWithOpacity(surface, opacity);
  static Color getBorderWithOpacity(double opacity) => getColorWithOpacity(border, opacity);
  
  /// General method to apply opacity to any color
  /// This method should be used instead of direct color.withOpacity calls
  /// to ensure consistent opacity handling throughout the app
  /// 
  /// MIGRATION GUIDE:
  /// Replace direct calls like:
  ///   color.withOpacity(0.5)
  /// With:
  ///   AppColors.getColorWithOpacity(color, 0.5)
  ///
  /// For commonly used colors, prefer the specific methods:
  ///   AppColors.getPrimaryWithOpacity(0.5)
  ///   AppColors.getSurfaceWithOpacity(0.5)  
  ///   AppColors.getBorderWithOpacity(0.5)
  static Color getColorWithOpacity(Color color, double opacity) {
    // Ensure opacity is within valid range
    final validOpacity = opacity.clamp(0.0, 1.0);
    return color.withValues(alpha: validOpacity);
  }
  
  // Shadow Styles - Dynamic based on theme
  static List<BoxShadow> get cardShadow => currentTheme == ThemeMode.light ? 
    [
      BoxShadow(
        color: getColorWithOpacity(Colors.black, cardShadowOpacity),
        blurRadius: cardShadowBlur,
        offset: const Offset(0, cardShadowOffsetY),
      ),
      BoxShadow(
        color: getColorWithOpacity(primary, cardShadowPrimaryOpacity),
        blurRadius: secondaryShadowBlur,
        offset: const Offset(0, secondaryShadowOffsetY),
      ),
    ] : 
    [
      BoxShadow(
        color: getColorWithOpacity(Colors.black, cardShadowDarkOpacity),
        blurRadius: cardShadowBlur,
        offset: const Offset(0, cardShadowOffsetY),
      ),
    ];
  
  static List<BoxShadow> get subtleShadow => currentTheme == ThemeMode.light ?
    [
      BoxShadow(
        color: getColorWithOpacity(Colors.black, subtleShadowOpacity),
        blurRadius: subtleShadowBlur,
        offset: const Offset(0, subtleShadowOffsetY),
      ),
    ] :
    [
      BoxShadow(
        color: getColorWithOpacity(Colors.black, subtleShadowDarkOpacity),
        blurRadius: subtleShadowBlur,
        offset: const Offset(0, subtleShadowOffsetY),
      ),
    ];
  
  static List<BoxShadow> get glowShadow => [
    BoxShadow(
      color: getColorWithOpacity(primary, glowShadowOpacity),
      blurRadius: glowShadowBlur,
      spreadRadius: glowShadowSpread,
    ),
  ];
  
  // Method to toggle theme
  static void toggleTheme() {
    currentTheme = currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
} 