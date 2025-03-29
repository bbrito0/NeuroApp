import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

// Add MainScreen import
import '../main.dart';
import '../services/tutorial_service.dart';
import './onboarding_features_slideshow.dart';  // Import the onboarding features slideshow

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/AI Health Assistant LOGIN SCREEN.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  // Logo
                  Image.asset(
                    'assets/images/LogoWhite.png',
                    height: 120,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations.aiHealthAssistant,
                    style: AppTextStyles.withColor(
                      AppTextStyles.bodyMedium,
                      AppColors.surface.withOpacity(0.8),
                    ),
                  ),
                  const Spacer(flex: 2),
                  // Login Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          CupertinoPageRoute(
                            builder: (context) => MainScreen(key: UniqueKey()),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      child: Text(
                        localizations.login,
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodyLarge,
                          AppColors.surface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // New User Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.3),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const OnboardingFeaturesSlideshow(),
                          ),
                        );
                      },
                      child: Text(
                        localizations.newUser,
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodyLarge,
                          AppColors.surface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Forgot Password Link
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: Text(
                      localizations.forgotPassword,
                      style: AppTextStyles.withColor(
                        AppTextStyles.bodyMedium,
                        AppColors.surface.withOpacity(0.8),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 