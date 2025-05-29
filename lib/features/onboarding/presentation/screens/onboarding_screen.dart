import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/services/user_profile_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _isMemoryMaster = true; // Default to Memory Master profile

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final userProfileService = Provider.of<UserProfileService>(context);
    
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
                      AppColors.getColorWithOpacity(AppColors.surface, 0.8),
                    ),
                  ),
                  const Spacer(flex: 2),
                  
                  // Login Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.getColorWithOpacity(Colors.white, 0.2),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        // Navigate to home (GoRouter will handle redirect logic)
                        context.go('/home');
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
                      color: AppColors.getPrimaryWithOpacity(0.3),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        context.goNamed('features-slideshow');
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
                        AppColors.getColorWithOpacity(AppColors.surface, 0.8),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          
          // Developer profile toggle in top left corner
          Positioned(
            top: 60,
            left: 16,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isMemoryMaster = !_isMemoryMaster;
                  userProfileService.switchUser(_isMemoryMaster 
                      ? UserProfile.MEMORY_MASTER.id 
                      : UserProfile.ENERGY_ENTHUSIAST.id);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.getColorWithOpacity(Colors.white, 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.getColorWithOpacity(Colors.white, 0.3),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.person_alt_circle,
                      color: AppColors.surface,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isMemoryMaster ? 'MM' : 'EE',
                      style: AppTextStyles.withColor(
                        AppTextStyles.bodySmall,
                        AppColors.surface,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 36,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _isMemoryMaster 
                            ? AppColors.primary
                            : AppColors.getColorWithOpacity(Colors.white, 0.3),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 200),
                            left: _isMemoryMaster ? 18 : 2,
                            top: 2,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 