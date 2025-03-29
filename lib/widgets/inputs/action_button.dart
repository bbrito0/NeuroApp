import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

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

  const ActionButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.style = ActionButtonStyle.filled,
    this.isLoading = false,
    this.isFullWidth = false,
    this.height = 44.0,
    this.borderRadius = 16.0,
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
            const SizedBox(width: 8),
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
            gradient: bgColor == AppColors.primary ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color.fromARGB(255, 0, 118, 169),
                Color.fromARGB(255, 18, 162, 183),
                Color.fromARGB(255, 92, 197, 217),
              ],
              stops: const [0.0, 0.5, 1.0],
            ) : null,
            color: bgColor == AppColors.primary ? null : bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: style == ActionButtonStyle.filled ? [
              BoxShadow(
                color: (bgColor == AppColors.primary ? AppColors.primary : bgColor).withOpacity(0.2),
                offset: const Offset(0, 4),
                blurRadius: 12,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: (bgColor == AppColors.primary ? AppColors.primary : bgColor).withOpacity(0.1),
                offset: const Offset(0, 1),
                blurRadius: 3,
                spreadRadius: 0,
              ),
            ] : null,
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
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
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 2),
                blurRadius: 6,
                spreadRadius: 0,
              ),
            ],
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          child: buttonContent,
        );
        break;

      case ActionButtonStyle.text:
        buttonContainer = Container(
          height: height,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          child: buttonContent,
        );
        break;
    }

    // Wrap in gesture detector
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Opacity(
        opacity: (onPressed == null || isLoading) ? 0.5 : 1.0,
        child: buttonContainer,
      ),
    );
  }
} 