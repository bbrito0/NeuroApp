import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';

class LockedFeatureOverlay extends StatelessWidget {
  final List<String> requiredSupplements;
  final Widget child;
  final bool showTooltip;

  const LockedFeatureOverlay({
    super.key,
    required this.requiredSupplements,
    required this.child,
    this.showTooltip = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      // fit: StackFit.expand, // REMOVED: Caused infinite height in Slivers
      // Default is StackFit.loose, which sizes to fit non-positioned children
      children: [
        // Semi-transparent child
        Opacity(
          opacity: 0.5,
          child: child,
        ),
        
        // Frosted overlay
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Container(
              color: AppColors.getSurfaceWithOpacity(0.2),
            ),
          ),
        ),
        
        // Lock icon
        Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.getColorWithOpacity(AppColors.primary, 0.9),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: SFIcon(
                SFIcons.sf_lock_fill,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
        
        // Tooltip showing required supplements (if enabled)
        if (showTooltip) _buildRequirementsTooltip(context),
      ],
    );
  }

  Widget _buildRequirementsTooltip(BuildContext context) {
    final supplementList = requiredSupplements.join(' / ');
    
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.getColorWithOpacity(AppColors.surface, 0.8),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            "Unlocked by: $supplementList",
            style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.primary),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
} 