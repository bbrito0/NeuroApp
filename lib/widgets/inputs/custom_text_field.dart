import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onChanged;
  final Widget? prefix;
  final Widget? suffix;
  final bool autofocus;
  final bool enabled;
  final int? maxLength;
  final int maxLines;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.onEditingComplete,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.autofocus = false,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
    this.borderRadius = 10.0,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: AppTextStyles.withColor(
              AppTextStyles.bodyMedium,
              AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        CupertinoTextField(
          controller: controller,
          placeholder: hintText,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          onChanged: onChanged,
          prefix: prefix,
          suffix: suffix,
          autofocus: autofocus,
          enabled: enabled,
          maxLength: maxLength,
          maxLines: maxLines,
          padding: contentPadding ?? const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: AppColors.systemGrey6,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: errorText != null
                  ? CupertinoColors.systemRed
                  : AppColors.getBorderWithOpacity(0.2),
              width: 0.5,
            ),
          ),
          style: AppTextStyles.withColor(
            AppTextStyles.bodyMedium,
            AppColors.textPrimary,
          ),
          placeholderStyle: AppTextStyles.withColor(
            AppTextStyles.bodyMedium,
            AppColors.textSecondary,
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: AppTextStyles.withColor(
              AppTextStyles.bodySmall,
              CupertinoColors.systemRed,
            ),
          ),
        ],
      ],
    );
  }
} 