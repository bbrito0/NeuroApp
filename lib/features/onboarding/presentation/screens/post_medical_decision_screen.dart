import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';

/// Post-medical decision screen that allows users to choose how to proceed
/// after completing the medical questionnaire during onboarding.
/// 
/// Users can either:
/// - Scan a product code to unlock premium features
/// - Continue with limited features
class PostMedicalDecisionScreen extends StatefulWidget {
  const PostMedicalDecisionScreen({super.key});

  @override
  State<PostMedicalDecisionScreen> createState() => _PostMedicalDecisionScreenState();
}

class _PostMedicalDecisionScreenState extends State<PostMedicalDecisionScreen> with SingleTickerProviderStateMixin {
  // UI Constants
  static const double standardPadding = 24.0;
  static const double largeSpacing = 32.0;
  static const double mediumSpacing = 24.0;
  static const double smallSpacing = 16.0;
  static const double miniSpacing = 12.0;
  static const double tinySpacing = 8.0;
  static const double cardBorderRadius = 20.0;
  static const double infoBorderRadius = 16.0;
  static const double borderWidth = 0.5;
  static const double outlinedBorderWidth = 1.0;
  static const double highlightedBorderWidth = 2.0;
  static const double iconContainerSize = 80.0;
  static const double iconSize = 40.0;
  static const double infoIconSize = 24.0;
  static const Duration animationDuration = Duration(seconds: 20);
  
  // Colors
  static const Color purpleColor = Color(0xFF8A2BE2);
  
  late final AnimationController _controller;
  late final Animation<Alignment> _beginAlignment;
  late final Animation<Alignment> _endAlignment;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: animationDuration,
      vsync: this,
    )..repeat();

    _beginAlignment = AlignmentTween(
      begin: const Alignment(-1.0, -1.0),
      end: const Alignment(1.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _endAlignment = AlignmentTween(
      begin: const Alignment(0.0, 0.0),
      end: const Alignment(2.0, 2.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToCodeScanner() {
    context.goNamed('code-scanner');
  }

  void _navigateToLimitedFeatures() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      navigationBar: CustomNavigationBar(
        title: localizations.completeSetup,
        subtitle: localizations.chooseHowToProceed,
        onBackPressed: () => context.pop(),
      ),
      child: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: _beginAlignment.value,
                    end: _endAlignment.value,
                    colors: AppColors.primaryGradient.colors,
                    tileMode: TileMode.mirror,
                  ),
                ),
              );
            },
          ),
          // Frosted glass effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.frostedGlassGradient,
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(standardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: largeSpacing),
                  // Decision Cards
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Scan Product Code Option
                        _buildOptionCard(
                          title: localizations.scanProductCode,
                          description: localizations.unlockPremiumFeatures,
                          icon: SFIcons.sf_qrcode,
                          color: AppColors.primary,
                          onTap: _navigateToCodeScanner,
                        ),
                        const SizedBox(height: mediumSpacing),
                        // Limited Features Option
                        _buildOptionCard(
                          title: localizations.continueWithLimitedFeatures,
                          description: localizations.accessBasicFeatures,
                          icon: SFIcons.sf_star,
                          color: purpleColor,
                          isOutlined: true,
                          onTap: _navigateToLimitedFeatures,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: mediumSpacing),
                  // Note about features
                  FrostedCard(
                    borderRadius: infoBorderRadius,
                    backgroundColor: AppColors.getSurfaceWithOpacity(0.2),
                    padding: const EdgeInsets.all(smallSpacing),
                    border: Border.all(
                      color: AppColors.getPrimaryWithOpacity(0.2),
                      width: borderWidth,
                    ),
                    child: Row(
                      children: [
                        const SFIcon(
                          SFIcons.sf_info_circle_fill,
                          color: AppColors.primary,
                          fontSize: infoIconSize,
                        ),
                        const SizedBox(width: miniSpacing),
                        Expanded(
                          child: Text(
                            localizations.premiumFeaturesDescription,
                            style: AppTextStyles.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    bool isOutlined = false,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: FrostedCard(
        borderRadius: cardBorderRadius,
        backgroundColor: isOutlined 
            ? Colors.transparent 
            : AppColors.getColorWithOpacity(color, 0.1),
        padding: const EdgeInsets.all(standardPadding),
        border: Border.all(
          color: isOutlined 
              ? AppColors.getColorWithOpacity(color, 0.5) 
              : color,
          width: isOutlined ? outlinedBorderWidth : highlightedBorderWidth,
        ),
        child: Column(
          children: [
            Container(
              width: iconContainerSize,
              height: iconContainerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.getColorWithOpacity(color, 0.1),
              ),
              child: Center(
                child: SFIcon(
                  icon,
                  fontSize: iconSize,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: smallSpacing),
            Text(
              title,
              style: AppTextStyles.withColor(
                AppTextStyles.heading2,
                color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: tinySpacing),
            Text(
              description,
              style: AppTextStyles.secondaryText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 