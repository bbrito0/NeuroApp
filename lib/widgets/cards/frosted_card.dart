import 'package:flutter/material.dart';
import 'dart:ui';
import '../../theme/app_colors.dart' hide ThemeMode;
import '../../theme/app_colors.dart' as app_theme show ThemeMode;

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
  
  const FrostedCard({
    Key? key,
    required this.child,
    this.padding,
    this.borderRadius = 16.0,
    this.backgroundColor,
    this.border,
    this.elevation = 0,
    this.blurAmount = 10.0,
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
        ? blurAmount * 1.5  // Increase blur for dark mode
        : blurAmount;
    
    // Determine border color based on theme
    final defaultBorder = Border.all(
      color: AppColors.currentTheme == app_theme.ThemeMode.dark
          ? AppColors.primary.withOpacity(0.3) // More visible in dark mode
          : AppColors.getBorderWithOpacity(0.15),
      width: AppColors.currentTheme == app_theme.ThemeMode.dark ? 0.8 : 0.5,
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
            padding: padding ?? const EdgeInsets.all(16.0),
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