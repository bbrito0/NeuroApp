import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';

class CustomNavigationBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  final String title;
  final String? subtitle;
  final int? currentStep;
  final int? totalSteps;
  final VoidCallback? onBackPressed;
  
  // UI Constants
  static const double borderRadius = 20.0;
  static const double blurAmount = 8.0;
  static const double borderWidth = 0.5;
  static const double borderOpacity = 0.2;
  static const double bottomPadding = 12.0;
  static const double horizontalPadding = 16.0;
  static const double stepIndicatorWidth = 24.0;
  static const double stepIndicatorHeight = 4.0;
  static const double stepIndicatorMargin = 2.0;
  static const double stepIndicatorBorderRadius = 2.0;
  static const double stepIndicatorOpacity = 0.3;
  static const double smallSpacing = 4.0;
  static const double standardSpacing = 8.0;
  static const double leadingPadding = 8.0;
  static const double heightWithStepAndSubtitle = 160.0;
  static const double heightWithSubtitle = 140.0;
  static const double standardHeight = 120.0;
  
  static const List<Color> gradientColors = [
    Color.fromARGB(255, 0, 118, 169),
    Color.fromARGB(255, 18, 162, 183),
    Color.fromARGB(255, 92, 197, 217),
  ];
  static const List<double> gradientStops = [0.0, 0.5, 1.0];
  
  const CustomNavigationBar({
    Key? key,
    required this.title,
    this.subtitle,
    this.currentStep,
    this.totalSteps,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(borderRadius),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
              stops: gradientStops,
            ),
            border: Border(
              bottom: BorderSide(
                color: AppColors.getPrimaryWithOpacity(borderOpacity),
                width: borderWidth,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: bottomPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: CupertinoNavigationBar(
                      backgroundColor: Colors.transparent,
                      border: null,
                      padding: const EdgeInsetsDirectional.only(start: leadingPadding),
                      leading: onBackPressed != null ? CupertinoNavigationBarBackButton(
                        color: AppColors.surface,
                        onPressed: onBackPressed,
                      ) : null,
                    ),
                  ),
                  const SizedBox(height: smallSpacing),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Text(
                      title,
                      style: AppTextStyles.withColor(
                        AppTextStyles.heading1,
                        AppColors.surface,
                      ),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: standardSpacing),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Text(
                        subtitle!,
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodyMedium,
                          AppColors.surface,
                        ),
                      ),
                    ),
                  ],
                  if (currentStep != null && totalSteps != null) ...[
                    const SizedBox(height: standardSpacing),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          totalSteps!,
                          (index) => Container(
                            width: stepIndicatorWidth,
                            height: stepIndicatorHeight,
                            margin: const EdgeInsets.symmetric(horizontal: stepIndicatorMargin),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(stepIndicatorBorderRadius),
                              color: index + 1 == currentStep
                                  ? AppColors.surface
                                  : AppColors.getColorWithOpacity(AppColors.surface, stepIndicatorOpacity),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    (currentStep != null && subtitle != null) ? heightWithStepAndSubtitle : subtitle != null ? heightWithSubtitle : standardHeight
  );

  @override
  bool shouldFullyObstruct(BuildContext context) => false;
} 