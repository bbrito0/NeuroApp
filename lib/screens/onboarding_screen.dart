import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

// Add MainScreen import
import '../main.dart';
import '../services/tutorial_service.dart';
import './qr_scanner_screen.dart';  // Add QRScannerScreen import

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
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
                    'AI. Health Assistant APP',
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
                        'Login',
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodyLarge,
                          AppColors.surface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Scan Supplements Button
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
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const QRScannerScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Scan supplements',
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
                      'Forgot password?',
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