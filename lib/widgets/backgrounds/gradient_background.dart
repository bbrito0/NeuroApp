import 'package:flutter/material.dart';
import '../../theme/app_colors.dart' hide ThemeMode;
import '../../theme/app_colors.dart' as app_theme show ThemeMode;

class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool usePrimaryGradient;
  final Gradient? customGradient;
  final bool hasSafeArea;
  final EdgeInsetsGeometry? padding;
  final BackgroundStyle style;
  
  const GradientBackground({
    Key? key,
    required this.child,
    this.usePrimaryGradient = true,
    this.customGradient,
    this.hasSafeArea = true,
    this.padding,
    this.style = BackgroundStyle.standard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Default to the app background gradient
    final Gradient effectiveGradient = customGradient ?? AppColors.appBackgroundGradient;
    
    final gradientWidget = Container(
      decoration: BoxDecoration(
        gradient: effectiveGradient,
      ),
      padding: padding,
      child: child,
    );

    return hasSafeArea 
      ? SafeArea(child: gradientWidget) 
      : gradientWidget;
  }
}

enum BackgroundStyle {
  standard,
  premium,
  vignette
} 