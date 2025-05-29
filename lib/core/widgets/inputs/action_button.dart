import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';

enum ActionButtonStyle { filled, outlined, text }

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ActionButtonStyle style;
  final bool isLoading;
  final bool isFullWidth;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? icon;
  
  // UI Constants
  static const double defaultHeight = 44.0;
  static const double defaultBorderRadius = 16.0;
  static const double defaultHorizontalPadding = 16.0;
  static const double iconSpacing = 8.0;
  static const double shadowOffsetY1 = 4.0;
  static const double shadowBlurRadius1 = 12.0;
  static const double shadowOffsetY2 = 1.0;
  static const double shadowBlurRadius2 = 3.0;
  static const double shadowOffsetY3 = 2.0;
  static const double shadowBlurRadius3 = 6.0;
  static const double borderWidth = 1.0;
  static const double disabledOpacity = 0.5;
  
  static const List<Color> primaryGradientColors = [
    Color.fromARGB(255, 0, 118, 169),
    Color.fromARGB(255, 18, 162, 183),
    Color.fromARGB(255, 92, 197, 217),
  ];
  
  static const List<double> gradientStops = [0.0, 0.5, 1.0];

  const ActionButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.style = ActionButtonStyle.filled,
    this.isLoading = false,
    this.isFullWidth = false,
    this.height = defaultHeight,
    this.borderRadius = defaultBorderRadius,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine colors based on style
    Color bgColor = backgroundColor ?? AppColors.primary;
    Color txtColor = textColor ?? AppColors.surface;
    
    if (style == ActionButtonStyle.outlined) {
      bgColor = Colors.transparent;
      txtColor = textColor ?? AppColors.primary;
    } else if (style == ActionButtonStyle.text) {
      bgColor = Colors.transparent;
      txtColor = textColor ?? AppColors.primary;
    }

    // Create button content
    Widget buttonContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          CupertinoActivityIndicator(color: txtColor)
        else ...[
          if (icon != null) ...[
            icon!,
            const SizedBox(width: iconSpacing),
          ],
          Text(
            text,
            style: AppTextStyles.withColor(
              AppTextStyles.bodyMedium,
              txtColor,
            ),
          ),
        ],
      ],
    );

    // Create container based on style
    Widget buttonContainer;
    switch (style) {
      case ActionButtonStyle.filled:
        buttonContainer = Container(
          height: height,
          decoration: BoxDecoration(
            gradient: bgColor == AppColors.primary ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: primaryGradientColors,
              stops: gradientStops,
            ) : null,
            color: bgColor == AppColors.primary ? null : bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: style == ActionButtonStyle.filled ? [
              BoxShadow(
                color: AppColors.getColorWithOpacity(
                  bgColor == AppColors.primary ? AppColors.primary : bgColor, 
                  0.2
                ),
                offset: const Offset(0, shadowOffsetY1),
                blurRadius: shadowBlurRadius1,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: AppColors.getColorWithOpacity(
                  bgColor == AppColors.primary ? AppColors.primary : bgColor,
                  0.1
                ),
                offset: const Offset(0, shadowOffsetY2),
                blurRadius: shadowBlurRadius2,
                spreadRadius: 0,
              ),
            ] : null,
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
          child: buttonContent,
        );
        break;

      case ActionButtonStyle.outlined:
        buttonContainer = Container(
          height: height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: txtColor,
              width: borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.getColorWithOpacity(Colors.black, 0.05),
                offset: const Offset(0, shadowOffsetY3),
                blurRadius: shadowBlurRadius3,
                spreadRadius: 0,
              ),
            ],
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
          child: buttonContent,
        );
        break;

      case ActionButtonStyle.text:
        buttonContainer = Container(
          height: height,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
          child: buttonContent,
        );
        break;
    }

    // Wrap in gesture detector
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Opacity(
        opacity: (onPressed == null || isLoading) ? disabledOpacity : 1.0,
        child: buttonContainer,
      ),
    );
  }
} 