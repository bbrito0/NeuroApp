import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool usePrimaryGradient;
  final Gradient? customGradient;
  final bool hasSafeArea;
  final EdgeInsetsGeometry? padding;
  
  const GradientBackground({
    Key? key,
    required this.child,
    this.usePrimaryGradient = true,
    this.customGradient,
    this.hasSafeArea = true,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradientWidget = Container(
      decoration: BoxDecoration(
        gradient: customGradient ?? (usePrimaryGradient ? AppColors.primaryGradient : null),
      ),
      padding: padding,
      child: child,
    );

    return hasSafeArea 
      ? SafeArea(child: gradientWidget) 
      : gradientWidget;
  }
} 