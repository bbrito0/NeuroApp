import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, LinearProgressIndicator, AlwaysStoppedAnimation;
import 'dart:ui';
import 'dart:async';
import 'dart:math' show sin, pi;
import 'package:flutter_sficon/flutter_sficon.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/widgets.dart';
import '../main.dart';
import 'home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SetupLoadingScreen extends StatefulWidget {
  const SetupLoadingScreen({super.key});

  @override
  State<SetupLoadingScreen> createState() => _SetupLoadingScreenState();
}

class _SetupLoadingScreenState extends State<SetupLoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _beginAlignment;
  late Animation<Alignment> _endAlignment;
  late Animation<double> _pulseAnimation;
  
  double _progress = 0.0;
  int _currentMessageIndex = 0;
  int _currentTipIndex = 0;
  bool _isCompleted = false;
  
  // Loading messages and tips are now defined within the build method to use localizations
  
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
    
    // Add pulsing animation with slower frequency
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    // Start loading sequence
    _startLoadingSequence();
    
    // Start health tips carousel
    _startTipsCarousel();
  }

  void _startLoadingSequence() {
    const totalDuration = Duration(seconds: 15); // Increased to 15 seconds
    
    // More frequent updates for smoother animation (20ms = 50 fps)
    Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (_progress < 1.0) {
        setState(() {
          // Use a curved loading progress for natural feel
          // This creates an ease-in-out effect for the progress bar
          final targetProgress = timer.tick / (totalDuration.inMilliseconds / 20);
          final smoothProgress = _applySmoothingCurve(targetProgress);
          
          _progress = smoothProgress.clamp(0.0, 1.0);
          
          // Update message index based on progress (4 messages total)
          _currentMessageIndex = (_progress * 4).floor();
          if (_currentMessageIndex >= 4) {
            _currentMessageIndex = 3;
          }
        });
      } else {
        timer.cancel();
        setState(() {
          _isCompleted = true;
        });
        
        // Increased delay before navigating to HomeScreen
        Future.delayed(const Duration(milliseconds: 1500), () {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
              builder: (context) => MainScreen(
                key: UniqueKey(),
                isLimitedMode: false,
              ),
              fullscreenDialog: true,
            ),
          );
        });
      }
    });
  }
  
  // Apply smoothing curve to progress animation
  double _applySmoothingCurve(double progress) {
    // Ease-in-out cubic curve for smoother progress
    if (progress < 0.5) {
      return 4 * progress * progress * progress;
    } else {
      final f = ((2 * progress) - 2);
      return 0.5 * f * f * f + 1;
    }
  }
  
  void _startTipsCarousel() {
    // Change health tip every 3 seconds
    Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      if (!_isCompleted) {
        setState(() {
          _currentTipIndex = (_currentTipIndex + 1) % 6; // 6 health tips total
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    // Initialize localized loading messages
    final List<String> loadingMessages = [
      localizations.analyzed,
      localizations.personalizing,
      localizations.optimizing,
      localizations.finalizing,
    ];
    
    // Health tip titles are localized, but content remains hardcoded until gen-l10n is run
    final List<String> tipTitles = [
      localizations.didYouKnow,
      localizations.healthFact,
      localizations.supplementBenefit,
      localizations.wellnessTip,
      localizations.brainPower,
      localizations.didYouKnow,
    ];
    
    // Health tip content (hardcoded until localization is generated)
    final List<String> tipContents = [
      'Omega-3 fatty acids found in ChronoWell supplements support brain health and cognitive function.',
      'Regular cognitive training can increase neuroplasticity, helping your brain form new neural connections.',
      'Vitamin D3 in our supplements helps maintain cognitive function and reduces risk of cognitive decline.',
      'Combining ChronoWell supplements with 7-8 hours of quality sleep maximizes cognitive benefits.',
      'Bacopa Monnieri, a key ingredient in REVITA, has been shown to improve memory formation and recall.',
      'Our personalized approach matches your specific cognitive needs with targeted supplement formulations.',
    ];

    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
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
          // Loading content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with pulse animation
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _isCompleted ? 1.0 : 1.0 + (0.05 * sin(_controller.value * 2 * pi)),
                          child: child,
                        );
                      },
                      child: Image.asset(
                        'assets/images/LogoWhite.png',
                        width: 160,
                        height: 160,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Health Tip Card - Made bigger with improved contrast
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.3, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: FrostedCard(
                        key: ValueKey<int>(_currentTipIndex),
                        borderRadius: 20,
                        backgroundColor: AppColors.getSurfaceWithOpacity(0.6),
                        padding: const EdgeInsets.all(28),
                        border: Border.all(
                          color: AppColors.getPrimaryWithOpacity(0.3),
                          width: 1.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: AppColors.primarySurfaceGradient(startOpacity: 0.8, endOpacity: 0.8),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                tipTitles[_currentTipIndex],
                                style: AppTextStyles.withColor(
                                  AppTextStyles.bodyMedium,
                                  Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              tipContents[_currentTipIndex],
                              style: AppTextStyles.withColor(
                                AppTextStyles.bodyLarge,
                                AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Loading status and progress
                    FrostedCard(
                      borderRadius: 24,
                      backgroundColor: AppColors.getSurfaceWithOpacity(0.7),
                      padding: const EdgeInsets.all(28),
                      border: Border.all(
                        color: AppColors.getPrimaryWithOpacity(0.2),
                        width: 1.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Loading message with fade transition
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 600),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 0.2),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              _isCompleted ? localizations.setupComplete : loadingMessages[_currentMessageIndex],
                              key: ValueKey<String>(_isCompleted ? 'complete' : loadingMessages[_currentMessageIndex]),
                              style: AppTextStyles.withColor(
                                AppTextStyles.heading2,
                                AppColors.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 28),
                          
                          // Progress indicator with gradient
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: LinearProgressIndicator(
                              value: _progress,
                              backgroundColor: AppColors.getPrimaryWithOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                              minHeight: 12,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Larger progress percentage
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _isCompleted ? 1.0 : _pulseAnimation.value,
                                child: child,
                              );
                            },
                            child: Text(
                              _isCompleted ? localizations.ready : '${(_progress * 100).toInt()}%',
                              style: AppTextStyles.withColor(
                                _isCompleted 
                                    ? AppTextStyles.heading1
                                    : AppTextStyles.heading1,
                                AppColors.primary,
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