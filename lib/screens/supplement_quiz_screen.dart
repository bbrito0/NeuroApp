import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/widgets.dart';
import '../main.dart';
import 'seller_page_screen.dart';

class SupplementQuizScreen extends StatefulWidget {
  const SupplementQuizScreen({super.key});

  @override
  State<SupplementQuizScreen> createState() => _SupplementQuizScreenState();
}

class _SupplementQuizScreenState extends State<SupplementQuizScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Alignment> _beginAlignment;
  late final Animation<Alignment> _endAlignment;
  late final PageController _pageController;
  int _currentPage = 0;
  
  late List<Map<String, dynamic>> _questions;

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
    
    _pageController = PageController();
    // Initialize questions as an empty list
    _questions = [];
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize questions with localized text
    if (_questions.isEmpty) {
      _initQuestions();
    }
  }

  void _initQuestions() {
    final localizations = AppLocalizations.of(context)!;
    
    _questions = [
      {
        'question': localizations.primaryHealthGoalQuestion,
        'options': [
          localizations.improveCognitiveFunction,
          localizations.betterSleepQuality,
          localizations.moreEnergy,
          localizations.reduceStressAnxiety,
          localizations.overallHealthOptimization
        ],
        'selectedIndex': -1,
      },
      {
        'question': localizations.symptomsQuestion,
        'options': [
          localizations.brainFogSymptom,
          localizations.lowEnergySymptom,
          localizations.troubleSleepingSymptom,
          localizations.moodFluctuationsSymptom,
          localizations.noSymptomsOption
        ],
        'selectedIndex': -1,
      },
      {
        'question': localizations.stressLevelQuestion,
        'options': [
          localizations.veryHighStress,
          localizations.highStress,
          localizations.moderateStress,
          localizations.lowStress,
          localizations.veryLowStress
        ],
        'selectedIndex': -1,
      },
      {
        'question': localizations.sleepQualityQuestion,
        'options': [
          localizations.excellentSleep,
          localizations.goodSleep,
          localizations.fairSleep,
          localizations.poorSleep,
          localizations.veryPoorSleep
        ],
        'selectedIndex': -1,
      },
      {
        'question': localizations.dietQuestion,
        'options': [
          localizations.veryHealthyDiet,
          localizations.mostlyHealthyDiet,
          localizations.averageDiet,
          localizations.belowAverageDiet,
          localizations.poorDiet
        ],
        'selectedIndex': -1,
      },
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToSellerPage() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const SellerPageScreen(
          recommendedSupplement: 'REVITA',
        ),
      ),
    );
  }

  void _navigateToLimitedFeatures() {
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => MainScreen(key: UniqueKey(), isLimitedMode: true),
        fullscreenDialog: true,
      ),
    );
  }

  bool _canProceed() {
    return _questions[_currentPage]['selectedIndex'] != -1;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      navigationBar: CustomNavigationBar(
        title: localizations.supplementQuizTitle,
        subtitle: localizations.supplementQuizSubtitle,
        currentStep: _currentPage + 1,
        totalSteps: _questions.length,
        onBackPressed: () {
          if (_currentPage > 0) {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {
            Navigator.of(context).pop();
          }
        },
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _questions.length,
                        physics: const NeverScrollableScrollPhysics(),
                        clipBehavior: Clip.none,
                        onPageChanged: (page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Transform.translate(
                            offset: const Offset(0, -2),
                            child: _buildQuestionPage(index)
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      if (_currentPage > 0)
                        Expanded(
                          child: ActionButton(
                            text: localizations.back,
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: ActionButtonStyle.filled,
                            backgroundColor: AppColors.surface,
                            textColor: AppColors.primary,
                            isFullWidth: true,
                          ),
                        ),
                      if (_currentPage > 0)
                        const SizedBox(width: 16),
                      Expanded(
                        child: ActionButton(
                          text: _currentPage == _questions.length - 1 ? localizations.seeResults : localizations.next,
                          onPressed: _canProceed()
                              ? () {
                                  if (_currentPage < _questions.length - 1) {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    _navigateToSellerPage();
                                  }
                                }
                              : null,
                          style: ActionButtonStyle.filled,
                          backgroundColor: AppColors.primary,
                          textColor: AppColors.surface,
                          isFullWidth: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionPage(int index) {
    final localizations = AppLocalizations.of(context)!;
    final question = _questions[index];
    
    return FrostedCard(
      borderRadius: 16,
      backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.primaryCardOpacity),
      padding: const EdgeInsets.all(24),
      border: Border.all(
        color: AppColors.getPrimaryWithOpacity(0.15),
        width: 0.5,
      ),
      shadows: AppColors.cardShadow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: AppColors.primarySurfaceGradient(startOpacity: 0.2, endOpacity: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SFIcon(
                  SFIcons.sf_questionmark_circle_fill,
                  fontSize: 12,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  localizations.question(index + 1, _questions.length),
                  style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            question['question'],
            style: AppTextStyles.withColor(
              AppTextStyles.heading2,
              AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  question['options'].length,
                  (optionIndex) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          _questions[index]['selectedIndex'] = optionIndex;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.getSurfaceWithOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: question['selectedIndex'] == optionIndex
                                ? AppColors.primary
                                : AppColors.getPrimaryWithOpacity(0.2),
                            width: question['selectedIndex'] == optionIndex ? 2 : 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    question['options'][optionIndex],
                                    style: AppTextStyles.withColor(
                                      AppTextStyles.heading3,
                                      question['selectedIndex'] == optionIndex
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            SFIcon(
                              SFIcons.sf_circle_fill,
                              fontSize: 20,
                              color: question['selectedIndex'] == optionIndex
                                  ? AppColors.primary
                                  : AppColors.secondaryLabel,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 