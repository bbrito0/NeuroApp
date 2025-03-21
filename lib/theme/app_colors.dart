import 'package:flutter/cupertino.dart';

class AppColors {
  // Primary Colors
  static const primary = Color.fromARGB(255, 18, 162, 183);
  static const primaryAlt = Color(0xFF30B0C7);
  
  // Background Gradient Colors
  static const backgroundGradientStart = Color.fromARGB(255, 172, 209, 217);
  static const backgroundGradientMiddle = Color.fromARGB(255, 172, 209, 217);
  static const backgroundGradientEnd = Color.fromARGB(255, 172, 209, 217);
  
  // Status Colors
  static const success = Color(0xFF34C759);
  
  // System Colors
  static const surface = CupertinoColors.systemBackground;
  static const border = CupertinoColors.separator;
  static const textPrimary = CupertinoColors.label;
  static const textSecondary = CupertinoColors.secondaryLabel;
  static const inactive = CupertinoColors.systemGrey;
  
  // Additional System Colors
  static const separator = CupertinoColors.separator;
  static const label = CupertinoColors.label;
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
  
  // Gradient Presets
  static final primaryGradient = LinearGradient(
    begin: const Alignment(-1.0, 1.0),
    end: const Alignment(1.0, -1.0),
    colors: [
      backgroundGradientStart.withOpacity(backgroundOpacity),
      backgroundGradientMiddle.withOpacity(backgroundOpacity),
      backgroundGradientEnd.withOpacity(backgroundOpacity),
    ],
    stops: const [0.15, 0.6, 1.0],
  );

  static final frostedGlassGradient = LinearGradient(
    begin: const Alignment(-1.0, 1.0),
    end: const Alignment(1.0, -1.0),
    colors: [
      surface.withOpacity(0.0),
      surface.withOpacity(0.0),
    ],
  );

  static LinearGradient primarySurfaceGradient({double startOpacity = 0.1, double endOpacity = 0.15}) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primary.withOpacity(startOpacity),
        primary.withOpacity(endOpacity),
      ],
    );
  }
  
  // Helper Methods
  static Color getPrimaryWithOpacity(double opacity) => primary.withOpacity(opacity);
  static Color getSurfaceWithOpacity(double opacity) => surface.withOpacity(opacity);
  static Color getBorderWithOpacity(double opacity) => border.withOpacity(opacity);
} 