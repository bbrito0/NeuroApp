import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';

// Question Type Enum
enum QuestionType { single, multi }

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
    final localizations = AppLocalizations.of(context);
    
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
        'selectedIndices': <int>{},
        'type': QuestionType.multi,
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
        'selectedIndices': <int>{},
        'type': QuestionType.multi,
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
        'type': QuestionType.single,
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
        'type': QuestionType.single,
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
        'type': QuestionType.single,
      },
      // Medical Questions converted to quiz format
      {
        'question': localizations.ageRangeQuestion,
        'options': [
          localizations.ageRange18to25, 
          localizations.ageRange26to35, 
          localizations.ageRange36to45, 
          localizations.ageRange46to55, 
          localizations.ageRange56plus
        ],
        'selectedIndex': -1,
        'type': QuestionType.single,
      },
      {
        'question': localizations.genderIdentityQuestion,
        'options': [
          localizations.genderMale, 
          localizations.genderFemale, 
          localizations.genderOther, 
          localizations.genderPreferNotToSay
        ],
        'selectedIndex': -1,
        'type': QuestionType.single,
      },
      {
        'question': localizations.activityLevelQuestion,
        'options': [
          localizations.activityLevelSedentary,
          localizations.activityLevelLightlyActive,
          localizations.activityLevelModeratelyActive,
          localizations.activityLevelVeryActive,
          localizations.activityLevelExtraActive
        ],
        'selectedIndex': -1,
        'type': QuestionType.single,
      },
      {
        'question': localizations.dietaryPreferencesQuestion,
        'options': [
          localizations.dietOmnivore,
          localizations.dietVegetarian,
          localizations.dietVegan,
          localizations.dietKetoLowCarb,
          localizations.dietPaleo,
          localizations.dietGlutenFree,
          localizations.dietNoPreference
        ],
        'selectedIndices': <int>{},
        'type': QuestionType.multi,
      },
      {
        'question': localizations.healthConditionsQuestion,
        'options': [
          localizations.conditionHighBloodPressure,
          localizations.conditionDiabetes,
          localizations.conditionThyroidIssues,
          localizations.conditionHeartConditions,
          localizations.conditionDigestiveIssues,
          localizations.conditionAnxietyDepression,
          localizations.conditionSleepDisorders,
          localizations.conditionJointPain,
          localizations.conditionNone
        ],
        'selectedIndex': -1,
        'type': QuestionType.single,
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
    context.goNamed(
      'seller-page',
      pathParameters: {'supplement': 'REVITA'},
    );
  }

  bool _canProceed() {
    final question = _questions[_currentPage];
    final type = question['type'] as QuestionType;
    
    if (type == QuestionType.single) {
      return question['selectedIndex'] != -1;
    } else {
      // For multi-select questions, require at least one selection
      // unless it's the last option (typically "None of the above")
      Set<int> selectedIndices = question['selectedIndices'] as Set<int>;
      return selectedIndices.isNotEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
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
            context.pop();
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
    final localizations = AppLocalizations.of(context);
    final question = _questions[index];
    final questionType = question['type'] as QuestionType;
    
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
                const SFIcon(
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
          // Help text for multi-select questions
          if (questionType == QuestionType.multi) ...[
            const SizedBox(height: 8),
            Text(
              localizations.selectAllThatApply,
              style: AppTextStyles.withColor(
                AppTextStyles.bodyMedium,
                AppColors.getColorWithOpacity(AppColors.textPrimary, 0.7),
              ),
            ),
          ],
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
                          if (questionType == QuestionType.single) {
                            question['selectedIndex'] = optionIndex;
                          } else {
                            // For multi-select questions
                            final selectedIndices = question['selectedIndices'] as Set<int>;
                            // Special case: if selecting "None of the above" or similar exclusive options
                            if (_isExclusiveOption(question, optionIndex)) {
                              // Clear other selections and select only this one
                              selectedIndices.clear();
                              selectedIndices.add(optionIndex);
                            } else {
                              // If selecting any other option, remove exclusive options
                              selectedIndices.removeWhere((index) => _isExclusiveOption(question, index));
                              
                              // Toggle the current selection
                              if (selectedIndices.contains(optionIndex)) {
                                selectedIndices.remove(optionIndex);
                              } else {
                                selectedIndices.add(optionIndex);
                              }
                            }
                          }
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.getSurfaceWithOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _isOptionSelected(question, optionIndex)
                                ? AppColors.primary
                                : AppColors.getPrimaryWithOpacity(0.2),
                            width: _isOptionSelected(question, optionIndex) ? 2 : 0.5,
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
                                      _isOptionSelected(question, optionIndex)
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Different icon for single vs multi selection
                            SFIcon(
                              _isOptionSelected(question, optionIndex)
                                ? SFIcons.sf_checkmark_circle_fill
                                : SFIcons.sf_circle,
                              fontSize: 20,
                              color: _isOptionSelected(question, optionIndex)
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
  
  // Helper to check if an option is selected
  bool _isOptionSelected(Map<String, dynamic> question, int optionIndex) {
    final type = question['type'] as QuestionType;
    
    if (type == QuestionType.single) {
      return question['selectedIndex'] == optionIndex;
    } else {
      final Set<int> selectedIndices = question['selectedIndices'] as Set<int>;
      return selectedIndices.contains(optionIndex);
    }
  }
  
  // Check if an option is exclusive (like "None of the above")
  bool _isExclusiveOption(Map<String, dynamic> question, int optionIndex) {
    final optionText = question['options'][optionIndex].toString().toLowerCase();
    return optionText.contains("none") || 
           optionText.contains("no specific") || 
           optionText.contains("prefer not");
  }
} 