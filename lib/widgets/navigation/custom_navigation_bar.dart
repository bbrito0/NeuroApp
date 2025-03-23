import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class CustomNavigationBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  final String title;
  final String? subtitle;
  final int? currentStep;
  final int? totalSteps;
  final VoidCallback? onBackPressed;
  
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
        bottom: Radius.circular(20),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color.fromARGB(255, 0, 118, 169),
                Color.fromARGB(255, 18, 162, 183),
                Color.fromARGB(255, 92, 197, 217),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            border: Border(
              bottom: BorderSide(
                color: AppColors.getPrimaryWithOpacity(0.2),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: CupertinoNavigationBar(
                      backgroundColor: Colors.transparent,
                      border: null,
                      padding: const EdgeInsetsDirectional.only(start: 8),
                      leading: onBackPressed != null ? CupertinoNavigationBarBackButton(
                        color: AppColors.surface,
                        onPressed: onBackPressed,
                      ) : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      title,
                      style: AppTextStyles.withColor(
                        AppTextStyles.heading1,
                        AppColors.surface,
                      ),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          totalSteps!,
                          (index) => Container(
                            width: 24,
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: index + 1 == currentStep
                                  ? AppColors.surface
                                  : AppColors.surface.withOpacity(0.3),
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
    (currentStep != null && subtitle != null) ? 160 : subtitle != null ? 140 : 120
  );

  @override
  bool shouldFullyObstruct(BuildContext context) => false;
} 