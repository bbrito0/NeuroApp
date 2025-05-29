import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../config/theme/app_colors.dart' hide ThemeMode;
import '../../../config/theme/app_colors.dart' as app_theme show ThemeMode;

class FrostedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final BoxBorder? border;
  final double elevation;
  final double blurAmount;
  final List<BoxShadow>? shadows;
  final CardHierarchy hierarchy;
  
  // UI Constants
  static const double defaultBorderRadius = 16.0;
  static const double defaultElevation = 0.0;
  static const double defaultBlurAmount = 10.0;
  static const double defaultPadding = 16.0;
  static const double darkModeBlurMultiplier = 1.5;
  static const double darkModeBorderWidth = 0.8;
  static const double lightModeBorderWidth = 0.5;
  static const double darkModeBorderOpacity = 0.3;
  static const double lightModeBorderOpacity = 0.15;
  
  const FrostedCard({
    Key? key,
    required this.child,
    this.padding,
    this.borderRadius = defaultBorderRadius,
    this.backgroundColor,
    this.border,
    this.elevation = defaultElevation,
    this.blurAmount = defaultBlurAmount,
    this.shadows,
    this.hierarchy = CardHierarchy.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine opacity based on hierarchy
    double defaultOpacity;
    switch (hierarchy) {
      case CardHierarchy.primary:
        defaultOpacity = AppColors.primaryCardOpacity;
        break;
      case CardHierarchy.secondary:
        defaultOpacity = AppColors.secondaryCardOpacity;
        break;
      case CardHierarchy.tertiary:
        defaultOpacity = AppColors.tertiaryCardOpacity;
        break;
    }
    
    // Get shadows based on hierarchy if not provided
    final effectiveShadows = shadows ?? _getShadowsForHierarchy();
    
    // Determine blur amount based on theme
    final effectiveBlurAmount = AppColors.currentTheme == app_theme.ThemeMode.dark 
        ? blurAmount * darkModeBlurMultiplier  // Increase blur for dark mode
        : blurAmount;
    
    // Determine border color based on theme
    final defaultBorder = Border.all(
      color: AppColors.currentTheme == app_theme.ThemeMode.dark
          ? AppColors.getColorWithOpacity(AppColors.primary, darkModeBorderOpacity) // More visible in dark mode
          : AppColors.getBorderWithOpacity(lightModeBorderOpacity),
      width: AppColors.currentTheme == app_theme.ThemeMode.dark ? darkModeBorderWidth : lightModeBorderWidth,
    );
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: effectiveShadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: effectiveBlurAmount,
            sigmaY: effectiveBlurAmount,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.getSurfaceWithOpacity(defaultOpacity),
              border: border ?? defaultBorder,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding ?? const EdgeInsets.all(defaultPadding),
            child: child,
          ),
        ),
      ),
    );
  }
  
  List<BoxShadow> _getShadowsForHierarchy() {
    switch (hierarchy) {
      case CardHierarchy.primary:
        return AppColors.cardShadow;
      case CardHierarchy.secondary:
        return AppColors.subtleShadow;
      case CardHierarchy.tertiary:
        return [];
    }
  }
}

enum CardHierarchy {
  primary,
  secondary,
  tertiary
} 