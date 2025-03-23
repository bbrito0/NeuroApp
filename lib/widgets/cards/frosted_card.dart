import 'package:flutter/material.dart';
import 'dart:ui';
import '../../theme/app_colors.dart';

class FrostedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final BoxBorder? border;
  final double elevation;
  final double blurAmount;
  
  const FrostedCard({
    Key? key,
    required this.child,
    this.padding,
    this.borderRadius = 16.0,
    this.backgroundColor,
    this.border,
    this.elevation = 0,
    this.blurAmount = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurAmount,
            sigmaY: blurAmount,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.getSurfaceWithOpacity(0.5),
              border: border ?? Border.all(
                color: AppColors.getBorderWithOpacity(0.1),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding ?? const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
} 