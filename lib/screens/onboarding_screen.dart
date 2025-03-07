import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

// Add MainScreen import
import '../main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Alignment> _beginAlignment;
  late final Animation<Alignment> _endAlignment;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
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
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.frostedGlassGradient,
              ),
            ),
          ),
          // Logo in background
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 260,
                width: 260,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/ChronoWell_logo-25[3].png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Login Button
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              CupertinoPageRoute(
                                builder: (context) {
                                  final tabController = CupertinoTabController(initialIndex: 0);
                                  return MainScreen(key: UniqueKey());
                                },
                                fullscreenDialog: true,
                              ),
                            );
                          },
                          child: Text(
                            'Login',
                            style: AppTextStyles.withColor(
                              AppTextStyles.heading3,
                              AppColors.surface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Create Account Button
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                              AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
                            width: 0.5,
                          ),
                        ),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            // TODO: Implement account creation
                          },
                          child: Text(
                            'Create Account',
                            style: AppTextStyles.withColor(
                              AppTextStyles.heading3,
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 