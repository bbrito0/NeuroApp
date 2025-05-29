import 'package:flutter/cupertino.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeCard extends StatelessWidget {
  final VoidCallback onGetStarted;

  const WelcomeCard({
    super.key,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App logo with subtle glow
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.getPrimaryWithOpacity(0.5),
                  AppColors.getPrimaryWithOpacity(0.1),
                ],
                stops: const [0.3, 1.0],
              ),
              boxShadow: AppColors.glowShadow,
            ),
            child: Center(
              child: Image.asset(
                'assets/images/LogoWhite.png',
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Welcome content with enhanced card styling
          FrostedCard(
            borderRadius: 24,
            backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.primaryCardOpacity),
            padding: const EdgeInsets.all(28),
            border: Border.all(
              color: AppColors.getPrimaryWithOpacity(0.2),
              width: 0.8,
            ),
            hierarchy: CardHierarchy.primary,
            shadows: AppColors.cardShadow,
            child: Column(
              children: [
                Text(
                  localizations.welcomeTitle,
                  style: AppTextStyles.adaptive(AppTextStyles.heading1),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  localizations.aiHealthAssistant,
                  style: AppTextStyles.adaptive(AppTextStyles.bodyLarge),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.welcomeMessage,
                  style: AppTextStyles.adaptive(AppTextStyles.secondaryText, isPrimary: false),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                ActionButton(
                  text: localizations.getStarted,
                  onPressed: onGetStarted,
                  style: ActionButtonStyle.filled,
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.surface,
                  isFullWidth: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 