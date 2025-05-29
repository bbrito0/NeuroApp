import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:math';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../widgets/welcome_card.dart';
import 'package:flutter_sficon/flutter_sficon.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingFeaturesSlideshow extends StatefulWidget {
  const OnboardingFeaturesSlideshow({super.key});

  @override
  State<OnboardingFeaturesSlideshow> createState() => _OnboardingFeaturesSlideshowState();
}

class _OnboardingFeaturesSlideshowState extends State<OnboardingFeaturesSlideshow> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 6; // Welcome + 5 feature cards
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  static const double pageIndicatorWidth = 20.0;
  static const double pageIndicatorHeight = 10.0;
  static const double pageIndicatorInactiveWidth = 10.0;
  static const double pageIndicatorBorderRadius = 5.0;
  static const double pageIndicatorMargin = 4.0;
  
  List<FeatureCard> _getFeatureCards(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return [
      FeatureCard(
        title: localizations.featurePersonalizedTitle,
        description: localizations.featurePersonalizedDesc,
        icon: SFIcons.sf_person_text_rectangle,
        background: const Color(0xFF12A2B7),
      ),
      FeatureCard(
        title: localizations.featureAICoachTitle,
        description: localizations.featureAICoachDesc,
        icon: SFIcons.sf_calendar_badge_plus,
        background: const Color(0xFF22C55E),
      ),
      FeatureCard(
        title: localizations.featureMyHubTitle,
        description: localizations.featureMyHubDesc,
        icon: SFIcons.sf_chart_bar,
        background: const Color(0xFF9333EA),
      ),
      FeatureCard(
        title: localizations.featureCommunityTitle,
        description: localizations.featureCommunityDesc,
        icon: SFIcons.sf_person_3,
        background: const Color(0xFF3B82F6),
      ),
      FeatureCard(
        title: localizations.featureMedicalTitle,
        description: localizations.featureMedicalDesc,
        icon: SFIcons.sf_heart,
        background: const Color(0xFFEF4444),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    _animationController.forward();
    
    _pageController.addListener(() {
      // Trigger animation when page changes
      if (_pageController.page!.round() != _currentPage) {
        _animationController.reset();
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToFinalize() {
    context.goNamed('code-scanner');
  }



  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        border: null,
        middle: Text(
          localizations.onboardingTitle,
          style: AppTextStyles.withColor(
            AppTextStyles.heading3,
            AppColors.textPrimary,
          ),
        ),
        trailing: _currentPage > 0 ? CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _navigateToFinalize,
          child: Text(
            localizations.skip,
            style: AppTextStyles.withColor(
              AppTextStyles.bodyMedium,
              AppColors.primary,
            ),
          ),
        ) : null,
      ),
      child: Stack(
        children: [
          GradientBackground(
            style: BackgroundStyle.premium,
            hasSafeArea: false,
            child: Container(),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _numPages,
                      physics: _currentPage == 0 ? const NeverScrollableScrollPhysics() : null,
                      clipBehavior: Clip.none,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                        // Reset and forward animation for the new page
                        _animationController.reset();
                        _animationController.forward();
                      },
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // Return welcome slide for index 0
                          return Transform.translate(
                            offset: const Offset(0, -2),
                            child: WelcomeCard(
                              onGetStarted: () {
                                _pageController.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          );
                        } else {
                          // Return feature cards for index 1-6
                          return Transform.translate(
                            offset: const Offset(0, -2),
                            child: _buildFeatureCard(index - 1),
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _buildPageIndicator(),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
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
                    child: _currentPage == 0 
                      ? const SizedBox() // Hide button on welcome slide
                      : _currentPage == _numPages - 1
                        ? ActionButton(
                            key: const ValueKey('continue_button'),
                            text: localizations.continueScanCode,
                            isFullWidth: true,
                            style: ActionButtonStyle.filled,
                            onPressed: _navigateToFinalize,
                            backgroundColor: AppColors.primary,
                            textColor: AppColors.surface,
                          )
                        : ActionButton(
                            key: ValueKey<int>(_currentPage),
                            text: localizations.next,
                            isFullWidth: true,
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(int index) {
    final feature = _getFeatureCards(context)[index];
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Feature image/illustration replaced with animated widget
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated Background circles
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.getColorWithOpacity(feature.background, 0.2),
                          AppColors.getColorWithOpacity(feature.background, 0.05),
                        ],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                  // Feature animated widget instead of image
                  SizedBox(
                    width: 320, // Fixed width to match feature cards below
                    child: Hero(
                      tag: 'feature_${feature.title}',
                      child: _getAnimatedWidgetForIndex(index, feature.background),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Feature details - Make the card smaller
            Center(
              child: SizedBox(
                width: 320, // Match width with widgets above (changed from 330)
                height: 180,
                child: FrostedCard(
                  borderRadius: 24,
                  backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.primaryCardOpacity),
                  padding: const EdgeInsets.all(20),
                  border: Border.all(
                    color: AppColors.getPrimaryWithOpacity(0.15),
                    width: 0.5,
                  ),
                  hierarchy: CardHierarchy.primary,
                  shadows: AppColors.cardShadow,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.getColorWithOpacity(feature.background, 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SFIcon(
                              feature.icon,
                              fontSize: 24,
                              color: feature.background,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              feature.title,
                              style: AppTextStyles.withColor(
                                AppTextStyles.heading2,
                                AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: Text(
                          feature.description,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _getAnimatedWidgetForIndex(int index, Color color) {
    switch (index) {
      case 0: // Personalized Features
        return PersonalizedFeaturesWidget(color: color);
      case 1: // AI Coach
        return AICoachWidget(color: color);
      case 2: // Progress Tracking
        return ProgressTrackingWidget(color: color);
      case 3: // Community
        return CommunityWidget(color: color);
      case 4: // Medical Screen
        return MedicalScreenWidget(color: color);
      default:
        return Container();
    }
  }

  Widget _buildPageIndicator() {
    List<Widget> indicators = [];
    
    // Only show indicators after the welcome slide
    if (_currentPage > 0) {
      for (int i = 1; i < _numPages; i++) {
        indicators.add(
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: i == _currentPage ? pageIndicatorWidth : pageIndicatorInactiveWidth,
            height: pageIndicatorHeight,
            margin: const EdgeInsets.symmetric(horizontal: pageIndicatorMargin),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(pageIndicatorBorderRadius),
              color: i == _currentPage 
                ? AppColors.primary
                : AppColors.getPrimaryWithOpacity(0.3),
              boxShadow: i == _currentPage
                ? [
                    BoxShadow(
                      color: AppColors.getColorWithOpacity(AppColors.primary, 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
            ),
          ),
        );
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: indicators,
      );
    } else {
      // Return empty container for welcome slide
      return const SizedBox();
    }
  }
}

class FeatureCard {
  final String title;
  final String description;
  final IconData icon;
  final String? image;
  final Color background;

  FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    this.image,
    required this.background,
  });
}

// Animated widget for Personalized Features card
class PersonalizedFeaturesWidget extends StatefulWidget {
  final Color color;
  
  const PersonalizedFeaturesWidget({
    Key? key, 
    required this.color,
  }) : super(key: key);

  @override
  State<PersonalizedFeaturesWidget> createState() => _PersonalizedFeaturesWidgetState();
}

/// Define as fases da animação.
enum AnimationPhase { highlight, connect, activate }

class _PersonalizedFeaturesWidgetState extends State<PersonalizedFeaturesWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  // Coordenadas centrais e raio para o círculo onde os suplementos são posicionados.
  static const double centerX = 160.0;
  static const double centerY = 110.0;
  static const double radius = 100.0;
  
  // Dados dos suplementos
  final List<Map<String, dynamic>> _supplements = [
    {
      'name': 'REVERSE',
      'benefit': 'Rejuvenate',
      'color': const Color(0xFF8A2BE2), // Purple
      'featureIndex': 0, // Memory
    },
    {
      'name': 'REVITA',
      'benefit': 'Energize',
      'color': const Color(0xFFFF1493), // Deep Pink
      'featureIndex': 1, // Energy
    },
    {
      'name': 'RESTORE',
      'benefit': 'Focus',
      'color': const Color(0xFFFF8C00), // Dark Orange
      'featureIndex': 2, // Focus
    },
    {
      'name': 'RESET',
      'benefit': 'Sleep',
      'color': const Color(0xFFFFD700), // Gold
      'featureIndex': 3, // Sleep
    },
    {
      'name': 'REGEN',
      'benefit': 'Strengthen',
      'color': const Color(0xFF4682B4), // Steel Blue
      'featureIndex': 4, // Stress
    },
  ];
  
  // Lista de features que são ativadas pelos suplementos
  final List<Map<String, dynamic>> _features = [
    {'name': 'Memory', 'active': false},
    {'name': 'Energy', 'active': false},
    {'name': 'Focus', 'active': false},
    {'name': 'Sleep', 'active': false},
    {'name': 'Stress', 'active': false},
  ];
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..forward(); // Play once instead of repeating
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Calcula o estado atual da animação com base no valor do controlador.
  Map<String, dynamic> _calculateAnimationState() {
    // Converte o progresso global para um progresso por suplemento.
    final double overallProgress = _controller.value * _supplements.length;
    final int activeIndex = min(overallProgress.floor(), _supplements.length - 1);
    final double phaseProgress = overallProgress - activeIndex;

    AnimationPhase phase;
    if (phaseProgress < 0.3) {
      phase = AnimationPhase.highlight;
    } else if (phaseProgress < 0.6) {
      phase = AnimationPhase.connect;
    } else {
      phase = AnimationPhase.activate;
    }

    // Atualiza o estado de ativação dos features com base no progresso.
    for (int i = 0; i < _supplements.length; i++) {
      int featureIndex = _supplements[i]['featureIndex'] as int;
      if (featureIndex >= 0 && featureIndex < _features.length) {
        _features[featureIndex]['active'] =
            (i < activeIndex) || (i == activeIndex && phase == AnimationPhase.activate);
      }
    }

    return {
      'activeIndex': activeIndex,
      'phaseProgress': phaseProgress,
      'phase': phase,
      'connectedCount': activeIndex + 1,
    };
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final state = _calculateAnimationState();
        final int activeIndex = state['activeIndex'] as int;
        final AnimationPhase phase = state['phase'] as AnimationPhase;
        final double phaseProgress = state['phaseProgress'] as double;
        final bool centerPulsing = phase == AnimationPhase.connect && phaseProgress > 0.5;

        return FrostedCard(
          borderRadius: 20,
          backgroundColor: AppColors.getSurfaceWithOpacity(0.8),
          padding: const EdgeInsets.all(16),
          border: Border.all(
            color: AppColors.getPrimaryWithOpacity(0.1),
            width: 0.5,
          ),
          shadows: AppColors.subtleShadow,
          child: SizedBox(
            width: 320,
            height: 340,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Hub central
                Positioned(
                  left: centerX - 30,
                  top: centerY - 30,
                  child: _CenterWidget(
                    pulsing: centerPulsing,
                    color: widget.color,
                  ),
                ),
                
                // Connection lines - only show active connection
                if (activeIndex >= 0 && phase != AnimationPhase.highlight)
                  _buildConnectionLine(activeIndex, phase, phaseProgress),
                
                // Supplements around center
                for (int i = 0; i < _supplements.length; i++)
                  _buildSupplementWidget(i, activeIndex, phase, phaseProgress),
                
                // Feature bubbles at bottom
                Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(_features.length, (index) {
                      final feature = _features[index];
                      // Find if a supplement is linked to this feature and is currently active
                      final isActiveFeature = activeIndex >= 0 && 
                        phase == AnimationPhase.activate && 
                        _supplements[activeIndex]['featureIndex'] == index;
                      
                      // Feature is active if it's been activated
                      final isActive = feature['active'] as bool;
                      
                      return _buildFeatureBubble(
                        feature['name'] as String,
                        isActive,
                        index,
                        isActiveFeature,
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Constrói o widget para cada suplemento com base no índice e no estado atual da animação.
  Widget _buildSupplementWidget(int index, int activeIndex, AnimationPhase phase, double phaseProgress) {
    final supplement = _supplements[index];
    final Color supplementColor = supplement['color'] as Color;
    final bool isActive = index == activeIndex;
    final bool isConnected = index < activeIndex || isActive;
    
    // Calcula a posição no círculo
    final angle = (2 * pi / _supplements.length) * index;
    double x = centerX + radius * cos(angle) - 30;
    double y = centerY + radius * sin(angle) - 15;
    
    // Para o suplemento ativo, anima a transição em direção ao centro
    if (isActive && phase == AnimationPhase.connect) {
      // Normaliza o progresso da fase de conexão
      final progress = (phaseProgress - 0.3) / 0.3;
      const targetX = centerX - 30;
      const targetY = centerY - 15;
      x = x + (targetX - x) * progress;
      y = y + (targetY - y) * progress;
    }

    return Positioned(
      left: x,
      top: y,
      child: AnimatedOpacity(
        opacity: isConnected ? 1.0 : 0.5,
        duration: const Duration(milliseconds: 500),
        child: Stack(
          children: [
            // The pill itself - with fixed width to ensure consistent size
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 60, // Fixed width for all pills
              height: 26, // Fixed height for all pills
              decoration: BoxDecoration(
                color: AppColors.getColorWithOpacity(supplementColor, isActive ? 1.0 : (isConnected ? 0.8 : 0.2)),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.getColorWithOpacity(supplementColor, isActive ? 1.0 : (isConnected ? 0.8 : 0.4)),
                  width: isActive ? 1.5 : 1.0,
                ),
                boxShadow: isActive ? [
                  BoxShadow(
                    color: AppColors.getColorWithOpacity(supplementColor, 0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ] : (isConnected ? [
                  BoxShadow(
                    color: AppColors.getColorWithOpacity(supplementColor, 0.3),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ] : []),
              ),
              child: Center(
                child: Text(
                  supplement['name'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isActive || isConnected ? Colors.white : supplementColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            
            // Animated particles when connected
            if (isActive && phase == AnimationPhase.connect)
              Positioned.fill(
                child: FlowParticles(
                  color: supplementColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionLine(int activeIndex, AnimationPhase phase, double phaseProgress) {
    final supplement = _supplements[activeIndex];
    final Color supplementColor = supplement['color'] as Color;
    
    // Calculate supplement position
    final angle = (2 * pi / _supplements.length) * activeIndex;
    final supplementX = centerX + radius * cos(angle);
    final supplementY = centerY + radius * sin(angle);
    
    // Calculate progress for the line animation
    double lineProgress;
    if (phase == AnimationPhase.connect) {
      lineProgress = (phaseProgress - 0.3) / 0.3;
    } else {
      lineProgress = 1.0;
    }
    
    return CustomPaint(
      painter: ConnectionLinePainter(
        color: AppColors.getColorWithOpacity(supplementColor, 0.7),
        startX: supplementX,
        startY: supplementY,
        endX: centerX,
        endY: centerY,
        progress: lineProgress,
        isSmooth: true,
      ),
      size: const Size(320, 340),
    );
  }
  
  Widget _buildFeatureBubble(String name, bool isActive, int index, bool isAnimating) {
    // Get a different color for each feature bubble based on index
    final List<Color> featureColors = [
      const Color(0xFF8A2BE2), // Purple - Memory
      const Color(0xFFFF1493), // Deep Pink - Energy
      const Color(0xFFFF8C00), // Dark Orange - Focus
      const Color(0xFFFFD700), // Gold - Sleep
      const Color(0xFF4682B4), // Steel Blue - Stress
    ];
    
    return AnimatedScale(
      scale: isAnimating ? 1.2 : (isActive ? 1.0 : 0.9),
      duration: const Duration(milliseconds: 300),
      child: AnimatedOpacity(
        opacity: isActive ? 1.0 : 0.5,
        duration: const Duration(milliseconds: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Feature bubble
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppColors.getColorWithOpacity(featureColors[index], isAnimating ? 0.4 : 0.2) : AppColors.getPrimaryWithOpacity(0.1),
                border: Border.all(
                  color: isActive ? featureColors[index] : AppColors.getPrimaryWithOpacity(0.2),
                  width: isAnimating ? 1.5 : 1.0,
                ),
                boxShadow: isAnimating ? [
                  BoxShadow(
                    color: AppColors.getColorWithOpacity(featureColors[index], 0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ] : (isActive ? [
                  BoxShadow(
                    color: AppColors.getColorWithOpacity(featureColors[index], 0.3),
                    blurRadius: 6,
                    spreadRadius: 0.5,
                  ),
                ] : null),
              ),
              child: Center(
                child: SFIcon(
                  _getIconForFeature(name),
                  fontSize: 16,
                  color: isActive ? featureColors[index] : AppColors.getPrimaryWithOpacity(0.4),
                ),
              ),
            ),
            const SizedBox(height: 3),
            // Feature name
            Text(
              name,
              style: TextStyle(
                color: isActive ? AppColors.textPrimary : AppColors.secondaryLabel,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForFeature(String feature) {
    switch (feature) {
      case 'Memory':
        return SFIcons.sf_brain;
      case 'Energy':
        return SFIcons.sf_bolt;
      case 'Focus':
        return SFIcons.sf_scope;
      case 'Sleep':
        return SFIcons.sf_moon_fill;
      case 'Stress':
        return SFIcons.sf_waveform_path;
      default:
        return SFIcons.sf_star;
    }
  }
}

/// Widget para o hub central que pulsa durante a fase de ligação.
class _CenterWidget extends StatelessWidget {
  final bool pulsing;
  final Color color;

  const _CenterWidget({
    Key? key, 
    required this.pulsing,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Pulse rings if active
        if (pulsing)
          CustomPaint(
            painter: PulseRingPainter(
              color: color,
              progress: 0.5,
              centerX: 30,
              centerY: 30,
              maxRadius: 50,
            ),
            size: const Size(60, 60),
          ),
          
        // Central hub
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.getColorWithOpacity(AppColors.primary, 0.4),
            boxShadow: [
              BoxShadow(
                color: AppColors.getColorWithOpacity(AppColors.primary, pulsing ? 0.4 : 0.2),
                blurRadius: pulsing ? 12 : 8,
                spreadRadius: pulsing ? 3 : 1,
              ),
            ],
            border: Border.all(
              color: AppColors.getColorWithOpacity(Colors.white, 0.4),
              width: 1.5,
            ),
          ),
          child: const Center(
            child: SFIcon(
              SFIcons.sf_person_fill,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for drawing connection lines with animation
class ConnectionLinePainter extends CustomPainter {
  final Color color;
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final double progress;
  final bool isSmooth;
  
  ConnectionLinePainter({
    required this.color,
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.progress,
    this.isSmooth = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    
    // Calculate the current end point based on progress
    final currentEndX = startX + (endX - startX) * progress;
    final currentEndY = startY + (endY - startY) * progress;
    
    if (isSmooth) {
      // Draw a smooth bezier curve
      final path = Path();
      path.moveTo(startX, startY);
      
      // Control points for bezier curve
      final controlX = (startX + currentEndX) / 2;
      final controlY = (startY + currentEndY) / 2;
      
      // Add some natural curve
      final dx = (currentEndX - startX);
      final dy = (currentEndY - startY);
      final distance = sqrt(dx * dx + dy * dy);
      final offsetFactor = distance / 8;
      
      // Perpendicular offset direction
      final offsetX = -dy / distance * offsetFactor;
      final offsetY = dx / distance * offsetFactor;
      
      path.quadraticBezierTo(
        controlX + offsetX, 
        controlY + offsetY, 
        currentEndX, 
        currentEndY
      );
      
      canvas.drawPath(path, paint);
      
      // Draw particles along the path
      _drawParticles(canvas, paint);
    } else {
      // Draw straight line with progress
      canvas.drawLine(
        Offset(startX, startY),
        Offset(currentEndX, currentEndY),
        paint
      );
      
      _drawParticles(canvas, paint);
    }
  }
  
  void _drawParticles(Canvas canvas, Paint linePaint) {
    // Create 3 particles along the line
    for (int i = 0; i < 3; i++) {
      // Adjust position based on progress and offset for each particle
      final particleProgress = (progress - i * 0.2).clamp(0.0, 1.0);
      
      // Only draw if particle is on the line
      if (particleProgress > 0) {
        final particleX = startX + (endX - startX) * particleProgress;
        final particleY = startY + (endY - startY) * particleProgress;
        
        // Draw particle
        final particlePaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;
        
        // Particle size based on position
        final particleSize = 2.0 * (1 - (2 * particleProgress - 1).abs());
        
        canvas.drawCircle(
          Offset(particleX, particleY),
          particleSize,
          particlePaint,
        );
      }
    }
  }
  
  @override
  bool shouldRepaint(ConnectionLinePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Painter for the pulsing effect around the center
class PulseRingPainter extends CustomPainter {
  final Color color;
  final double progress;
  final double centerX;
  final double centerY;
  final double maxRadius;
  
  PulseRingPainter({
    required this.color,
    required this.progress,
    required this.centerX,
    required this.centerY,
    required this.maxRadius,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.getColorWithOpacity(color, (1 - progress) * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    // Draw expanding circle
    final radius = maxRadius * progress;
    canvas.drawCircle(
      Offset(centerX, centerY),
      radius,
      paint,
    );
  }
  
  @override
  bool shouldRepaint(PulseRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Animated particles flowing along a path
class FlowParticles extends StatefulWidget {
  final Color color;
  
  const FlowParticles({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  State<FlowParticles> createState() => _FlowParticlesState();
}

class _FlowParticlesState extends State<FlowParticles> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    // Create some particles
    _particles = List.generate(3, (index) => Particle(widget.color));
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class Particle {
  final Color color;
  final double size;
  final double speed;
  final double angle;
  
  Particle(this.color)
      : size = 2.0 + Random().nextDouble() * 2,
        speed = 0.3 + Random().nextDouble() * 0.3,
        angle = Random().nextDouble() * pi;
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  
  ParticlePainter({
    required this.particles,
    required this.progress,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Start position - from the edge of the pill
      final startX = size.width * 0.2 + Random().nextDouble() * size.width * 0.6;
      final startY = size.height * 0.2 + Random().nextDouble() * size.height * 0.6;
      
      // End position - toward center of pill
      final endX = size.width / 2;
      final endY = size.height / 2;
      
      // Current position with looping animation
      final relativeProgress = (progress + particles.indexOf(particle) / particles.length) % 1.0;
      
      final currentX = startX + (endX - startX) * relativeProgress;
      final currentY = startY + (endY - startY) * relativeProgress;
      
      // Paint particle
      final paint = Paint()
        ..color = AppColors.getColorWithOpacity(particle.color, 0.7 - 0.7 * relativeProgress)
        ..style = PaintingStyle.fill;
      
      // Draw the particle
      canvas.drawCircle(
        Offset(currentX, currentY),
        particle.size * (1 - relativeProgress),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

// Animated widget for AI Coach card
class AICoachWidget extends StatefulWidget {
  final Color color;
  
  const AICoachWidget({
    Key? key, 
    required this.color,
  }) : super(key: key);

  @override
  State<AICoachWidget> createState() => _AICoachWidgetState();
}

class _AICoachWidgetState extends State<AICoachWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  final List<Map<String, String>> _chatMessages = [
    {
      'role': 'coach',
      'message': 'How are you feeling today?',
    },
    {
      'role': 'user',
      'message': 'A bit stressed lately.',
    },
    {
      'role': 'coach',
      'message': 'I can suggest some relaxation techniques that might help.',
    },
    {
      'role': 'user',
      'message': 'That would be great!',
    },
    {
      'role': 'coach',
      'message': 'Try this 2-minute breathing exercise...',
    },
  ];
  
  int _visibleMessages = 0;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && _visibleMessages < _chatMessages.length) {
        setState(() {
          _visibleMessages++;
        });
        
        if (_visibleMessages < _chatMessages.length) {
          _controller.reset();
          _controller.forward();
        }
      }
    });
    
    // Start with first message
    _visibleMessages = 1;
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FrostedCard(
        borderRadius: 20,
        backgroundColor: AppColors.getSurfaceWithOpacity(0.8),
        padding: const EdgeInsets.all(16),
        border: Border.all(
          color: AppColors.getPrimaryWithOpacity(0.1),
          width: 0.5,
        ),
        shadows: AppColors.subtleShadow,
        child: SizedBox(
          width: 300,
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Coach header
              Row(
                children: [
                  _buildCoachAvatar(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Coach',
                          style: AppTextStyles.withColor(
                            AppTextStyles.heading3,
                            AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Your personal health guide',
                          style: AppTextStyles.withColor(
                            AppTextStyles.bodySmall,
                            AppColors.secondaryLabel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.getColorWithOpacity(widget.color, 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: SFIcon(
                      SFIcons.sf_plus,
                      fontSize: 12,
                      color: widget.color,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 14),
              
              // Chat messages
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(_visibleMessages, (index) {
                      // Show the message with fade-in animation if it's the last one
                      final isLast = index == _visibleMessages - 1;
                      final message = _chatMessages[index];
                      final isCoach = message['role'] == 'coach';
                      
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: isLast ? _animation.value : 1.0,
                        child: Align(
                          alignment: isCoach ? Alignment.centerLeft : Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isCoach 
                                  ? AppColors.getSurfaceWithOpacity(0.5)
                                  : AppColors.getColorWithOpacity(widget.color, 0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isCoach 
                                    ? AppColors.getPrimaryWithOpacity(0.1)
                                    : AppColors.getColorWithOpacity(widget.color, 0.3),
                                width: 0.5,
                              ),
                            ),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.6,
                            ),
                            child: Text(
                              message['message']!,
                              style: AppTextStyles.withColor(
                                AppTextStyles.bodyMedium,
                                isCoach ? AppColors.textPrimary : widget.color,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              
              // Input field
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.getSurfaceWithOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.getPrimaryWithOpacity(0.1),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Type a message...',
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodyMedium,
                          AppColors.secondaryLabel,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.getColorWithOpacity(widget.color, 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: SFIcon(
                        SFIcons.sf_arrow_up,
                        fontSize: 16,
                        color: widget.color,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Suggestions
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Wrap(
                  spacing: 8,
                  children: [
                    _buildSuggestionChip('Sleep better'),
                    _buildSuggestionChip('Reduce stress'),
                    _buildSuggestionChip('Memory tips'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCoachAvatar() {
    return Stack(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.getColorWithOpacity(widget.color, 0.7),
                widget.color,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.getColorWithOpacity(widget.color, 0.3),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: const Center(
            child: SFIcon(
              SFIcons.sf_person_fill,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSuggestionChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.getColorWithOpacity(widget.color, 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.getColorWithOpacity(widget.color, 0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.withColor(
          AppTextStyles.bodySmall,
          widget.color,
        ),
      ),
    );
  }
}

// Animated widget for Progress Tracking card
class ProgressTrackingWidget extends StatefulWidget {
  final Color color;
  
  const ProgressTrackingWidget({
    Key? key, 
    required this.color,
  }) : super(key: key);

  @override
  State<ProgressTrackingWidget> createState() => _ProgressTrackingWidgetState();
}

class _ProgressTrackingWidgetState extends State<ProgressTrackingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  final List<FlSpot> _dataPoints = [
    const FlSpot(0, 65),
    const FlSpot(1, 72),
    const FlSpot(2, 68),
    const FlSpot(3, 75),
    const FlSpot(4, 78),
    const FlSpot(5, 85),
    const FlSpot(6, 82),
  ];
  
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Progress Chart
          FrostedCard(
            borderRadius: 20,
            backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
            padding: const EdgeInsets.all(16),
            border: Border.all(
              color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
              width: 0.5,
            ),
            shadows: AppColors.subtleShadow,
            child: SizedBox(
              width: 300,
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Memory',
                            style: AppTextStyles.withColor(
                              AppTextStyles.heading2,
                              AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '+15% This Week',
                            style: AppTextStyles.withColor(
                              AppTextStyles.bodyMedium,
                              AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SFIcon(
                            SFIcons.sf_slider_horizontal_3,
                            fontSize: 20,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, _) {
                        return Opacity(
                          opacity: _animation.value,
                          child: LineChart(
                            _createChartData(),
                          ),
                        );
                      },
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
  
  LineChartData _createChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < _days.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _days[value.toInt()],
                    style: AppTextStyles.withColor(
                      AppTextStyles.bodySmall,
                      AppColors.getPrimaryWithOpacity(AppColors.inactiveOpacity),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 10,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: AppTextStyles.withColor(
                  AppTextStyles.bodySmall,
                  AppColors.getPrimaryWithOpacity(AppColors.inactiveOpacity),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (_dataPoints.length - 1).toDouble(),
      minY: 50,
      maxY: 90,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(_dataPoints.length, (index) {
            return FlSpot(
              _dataPoints[index].x,
              50 + (_dataPoints[index].y - 50) * _animation.value,
            );
          }),
          isCurved: true,
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primary],
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.getPrimaryWithOpacity(0.2),
                AppColors.getPrimaryWithOpacity(0.0),
              ],
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipPadding: const EdgeInsets.all(8),
          tooltipBorder: BorderSide(
            color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
            width: 0.5,
          ),
          tooltipMargin: 0,
          tooltipRoundedRadius: 8,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final value = touchedSpot.y;
              return LineTooltipItem(
                value.toStringAsFixed(1),
                AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.primary),
                children: [
                  TextSpan(
                    text: '\nScore',
                    style: AppTextStyles.withColor(
                      AppTextStyles.bodySmall,
                      AppColors.getPrimaryWithOpacity(AppColors.inactiveOpacity),
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
    );
  }
}

// Animated widget for Community card
class CommunityWidget extends StatefulWidget {
  final Color color;
  
  const CommunityWidget({
    Key? key, 
    required this.color,
  }) : super(key: key);

  @override
  State<CommunityWidget> createState() => _CommunityWidgetState();
}

class _CommunityWidgetState extends State<CommunityWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  final List<String> _tags = ['Memory', 'Sleep', 'Stress', 'Focus', 'Nutrition'];
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Community Forum Card
              FrostedCard(
                borderRadius: 20,
                backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                padding: const EdgeInsets.all(16),
                border: Border.all(
                  color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
                  width: 0.5,
                ),
                shadows: AppColors.subtleShadow,
                child: SizedBox(
                  width: 320,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.getPrimaryWithOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const SFIcon(
                              SFIcons.sf_bubble_left_and_bubble_right_fill,
                              fontSize: 24,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Community Forum',
                                  style: AppTextStyles.withColor(
                                    AppTextStyles.heading3,
                                    AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Connect and learn',
                                  style: AppTextStyles.secondaryText,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 14),
                      
                      // Search Bar
                      FrostedCard(
                        borderRadius: 12,
                        backgroundColor: AppColors.getSurfaceWithOpacity(0.5),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: Border.all(
                          color: AppColors.getPrimaryWithOpacity(0.1),
                          width: 0.5,
                        ),
                        shadows: const [],
                        child: Row(
                          children: [
                            const SFIcon(
                              SFIcons.sf_magnifyingglass,
                              fontSize: 16,
                              color: AppColors.secondaryLabel,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Search topics',
                                style: AppTextStyles.withColor(
                                  AppTextStyles.bodyMedium,
                                  AppColors.secondaryLabel,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 14),
                      
                      // Tags
                      SizedBox(
                        height: 30,
                        child: Transform.translate(
                          offset: Offset(30 * (1 - _animation.value), 0),
                          child: Opacity(
                            opacity: _animation.value,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _tags.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: index == 0 
                                        ? AppColors.getPrimaryWithOpacity(0.2)
                                        : AppColors.getSurfaceWithOpacity(0.5),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: index == 0
                                          ? AppColors.primary
                                          : AppColors.getPrimaryWithOpacity(0.1),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    _tags[index],
                                    style: AppTextStyles.withColor(
                                      AppTextStyles.bodySmall,
                                      index == 0 ? AppColors.primary : AppColors.textPrimary,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 14),
                      
                      // Forum Post
                      Transform.translate(
                        offset: Offset(0, 30 * (1 - _animation.value)),
                        child: Opacity(
                          opacity: _animation.value,
                          child: FrostedCard(
                            borderRadius: 16,
                            backgroundColor: AppColors.getSurfaceWithOpacity(0.7),
                            padding: const EdgeInsets.all(14), // Reduce padding from 16 to 14
                            border: Border.all(
                              color: AppColors.getPrimaryWithOpacity(0.1),
                              width: 0.5,
                            ),
                            shadows: const [],
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // User Avatar
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.getPrimaryWithOpacity(0.2),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'JD',
                                      style: AppTextStyles.withColor(
                                        AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                        AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                
                                // Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'John Doe',
                                            style: AppTextStyles.withColor(
                                              AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                              AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '2h ago',
                                            style: AppTextStyles.withColor(
                                              AppTextStyles.bodySmall,
                                              AppColors.secondaryLabel,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Has anyone tried combining meditation with the memory exercises? I\'ve noticed some improvements!',
                                        style: AppTextStyles.withColor(
                                          AppTextStyles.bodyMedium,
                                          AppColors.textPrimary,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const SFIcon(
                                            SFIcons.sf_hand_thumbsup,
                                            fontSize: 14,
                                            color: AppColors.secondaryLabel,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '24',
                                            style: AppTextStyles.withColor(
                                              AppTextStyles.bodySmall,
                                              AppColors.secondaryLabel,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          const SFIcon(
                                            SFIcons.sf_bubble_left,
                                            fontSize: 14,
                                            color: AppColors.secondaryLabel,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '8',
                                            style: AppTextStyles.withColor(
                                              AppTextStyles.bodySmall,
                                              AppColors.secondaryLabel,
                                            ),
                                          ),
                                        ],
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Animated widget for Medical Screen card
class MedicalScreenWidget extends StatefulWidget {
  final Color color;
  
  const MedicalScreenWidget({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  State<MedicalScreenWidget> createState() => _MedicalScreenWidgetState();
}

class _MedicalScreenWidgetState extends State<MedicalScreenWidget> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Medical Records Card
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - _animation.value)),
                child: Opacity(
                  opacity: _animation.value,
                  child: FrostedCard(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(16),
                    backgroundColor: AppColors.getSurfaceWithOpacity(1.0),
                    border: Border.all(
                      color: AppColors.getPrimaryWithOpacity(0.1),
                      width: 0.5,
                    ),
                    shadows: AppColors.subtleShadow,
                    child: SizedBox(
                      width: 320,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.getPrimaryWithOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const SFIcon(
                                  SFIcons.sf_doc_text,
                                  fontSize: 24,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Latest Report',
                                      style: AppTextStyles.withColor(
                                        AppTextStyles.heading3,
                                        AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      'March 15, 2024',
                                      style: AppTextStyles.secondaryText,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.primarySurfaceGradient(startOpacity: 0.2, endOpacity: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'View',
                                      style: AppTextStyles.withColor(
                                        AppTextStyles.bodyMedium,
                                        AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const SFIcon(
                                      SFIcons.sf_chevron_right,
                                      fontSize: 14,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),
          
          // Caregiver Card
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - _animation.value)),
                child: Opacity(
                  opacity: _animation.value,
                  child: FrostedCard(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(16),
                    backgroundColor: AppColors.getSurfaceWithOpacity(1.0),
                    border: Border.all(
                      color: AppColors.getPrimaryWithOpacity(0.1),
                      width: 0.5,
                    ),
                    shadows: AppColors.subtleShadow,
                    child: SizedBox(
                      width: 320,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: AppColors.primarySurfaceGradient(),
                                ),
                                child: const Center(
                                  child: SFIcon(
                                    SFIcons.sf_person_fill,
                                    fontSize: 30,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dr. Sarah Johnson',
                                      style: AppTextStyles.withColor(
                                        AppTextStyles.heading3,
                                        AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      'Neurologist',
                                      style: AppTextStyles.secondaryText,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const SFIcon(
                                SFIcons.sf_star_fill,
                                fontSize: 14,
                                color: Color(0xFFFFB800),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '4.9 (127 reviews)',
                                style: AppTextStyles.withColor(
                                  AppTextStyles.bodySmall,
                                  AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.getColorWithOpacity(const Color(0xFF34C759), 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Available Now',
                                  style: AppTextStyles.withColor(
                                    AppTextStyles.bodySmall,
                                    const Color(0xFF34C759),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.primarySurfaceGradient(startOpacity: 0.2, endOpacity: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Schedule',
                                      style: AppTextStyles.withColor(
                                        AppTextStyles.bodyMedium,
                                        AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const SFIcon(
                                      SFIcons.sf_chevron_right,
                                      fontSize: 14,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} 