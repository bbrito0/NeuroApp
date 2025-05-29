import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../../../../core/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Enumeration for gender selection
enum Gender { male, female, other }

/// Enumeration for activity level selection
enum ActivityLevel { sedentary, moderatelyActive, highlyActive }

/// Enumeration for diet type selection
enum DietType { keto, vegan, balanced, other }

/// Medical record screen that collects essential health information during onboarding.
/// 
/// This multi-step form collects:
/// - Personal information (age, gender, weight, height)
/// - Activity level assessment
/// - Dietary preferences and restrictions
/// 
/// The information is used to personalize supplement recommendations
/// and tailor the user experience within the app.
class MedicalRecordScreen extends StatefulWidget {
  const MedicalRecordScreen({super.key});

  @override
  State<MedicalRecordScreen> createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Alignment> _beginAlignment;
  late final Animation<Alignment> _endAlignment;
  
  int _currentStep = 1;
  final int _totalSteps = 3;

  // Step 1: Personal Information
  final TextEditingController _ageController = TextEditingController();
  Gender? _selectedGender;
  final TextEditingController _weightController = TextEditingController();
  bool _isWeightMetric = true; // true for kg, false for lbs
  final TextEditingController _heightController = TextEditingController();
  bool _isHeightMetric = true; // true for cm, false for ft

  // Step 2: Activity Level
  ActivityLevel? _activityLevel;

  // Step 3: Diet
  DietType? _dietType;
  final TextEditingController _otherDietController = TextEditingController();
  
  // UI Constants
  static const double standardPadding = 24.0;
  static const double mediumPadding = 16.0;
  static const double smallPadding = 12.0;
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double borderRadius = 20.0;
  static const double smallBorderRadius = 8.0;
  static const double borderWidth = 0.5;
  static const double pickerHeight = 250.0;
  static const double pickerHeaderHeight = 48.0;
  static const double itemExtent = 40.0;
  static const double borderWidthSelected = 2.0;
  static const double buttonHeight = 44.0;
  static const double iconSize = 20.0;
  static const double smallIconSize = 12.0;
  static const Duration animationDuration = Duration(seconds: 20);

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

    // Preselect gender
    _selectedGender = Gender.male;
  }

  @override
  void dispose() {
    _controller.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _otherDietController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      // Validate current step before proceeding
      if (_currentStep == 1) {
        if (_ageController.text.isEmpty ||
            _selectedGender == null ||
            _weightController.text.isEmpty ||
            _heightController.text.isEmpty) {
          // Show error message
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text(AppLocalizations.of(context).incompleteInformation),
              content: Text(AppLocalizations.of(context).fillAllFields),
              actions: [
                CupertinoDialogAction(
                  child: Text(AppLocalizations.of(context).ok),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
          return;
        }
      } else if (_currentStep == 2 && _activityLevel == null) {
        // Show error message for activity level
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(AppLocalizations.of(context).activityLevelRequired),
            content: Text(AppLocalizations.of(context).selectActivityLevel),
            actions: [
              CupertinoDialogAction(
                child: Text(AppLocalizations.of(context).ok),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
        return;
      } else if (_currentStep == 3 && _dietType == null) {
        // Show error message for diet type
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(AppLocalizations.of(context).dietTypeRequired),
            content: Text(AppLocalizations.of(context).selectDietType),
            actions: [
              CupertinoDialogAction(
                child: Text(AppLocalizations.of(context).ok),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
        return;
      }

      setState(() {
        _currentStep++;
      });
    } else {
      _showFinalizeAccountDialog();
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _showPicker({
    required String title,
    required List<String> items,
    required ValueChanged<int> onSelectedItemChanged,
    String? selectedValue,
  }) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: pickerHeight,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(borderRadius),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: pickerHeaderHeight,
              padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.getPrimaryWithOpacity(0.1),
                    width: borderWidth,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      AppLocalizations.of(context).cancel,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      AppLocalizations.of(context).done,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                backgroundColor: AppColors.surface,
                itemExtent: itemExtent,
                scrollController: FixedExtentScrollController(
                  initialItem: selectedValue != null 
                      ? items.indexOf(selectedValue)
                      : 0,
                ),
                onSelectedItemChanged: onSelectedItemChanged,
                children: items.map((item) => 
                  Center(
                    child: Text(
                      item,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerField({
    required String placeholder,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            height: buttonHeight,
            padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
            decoration: BoxDecoration(
              color: AppColors.getPrimaryWithOpacity(0.1),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: AppColors.getPrimaryWithOpacity(0.2),
                width: borderWidth,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    value.isEmpty ? placeholder : value,
                    style: value.isEmpty 
                        ? AppTextStyles.secondaryText
                        : AppTextStyles.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: smallSpacing),
                const SFIcon(
                  SFIcons.sf_chevron_down,
                  color: AppColors.secondaryLabel,
                  fontSize: smallIconSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      navigationBar: CustomNavigationBar(
        currentStep: _currentStep,
        totalSteps: _totalSteps,
        title: localizations.medicalHistory,
        subtitle: localizations.medicalHistoryInfo,
        onBackPressed: () => context.pop(),
      ),
      child: Stack(
        children: [
          // Background with gradient and frosted effect
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: standardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: largeSpacing),
                  // Step content
                  Expanded(
                    child: FrostedCard(
                      borderRadius: mediumPadding,
                      padding: const EdgeInsets.all(standardPadding),
                      backgroundColor: AppColors.getColorWithOpacity(Colors.white, 0.8),
                      border: Border.all(
                        color: AppColors.getPrimaryWithOpacity(0.2),
                        width: borderWidth,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Step title and description
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: smallPadding, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: AppColors.primarySurfaceGradient(startOpacity: 0.2, endOpacity: 0.2),
                                borderRadius: BorderRadius.circular(smallBorderRadius),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SFIcon(
                                    SFIcons.sf_heart_fill,
                                    fontSize: smallIconSize,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    localizations.stepCount(_currentStep.toString(), _totalSteps.toString()),
                                    style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: mediumSpacing),
                            // Step content
                            _currentStep == 1
                                ? _buildPersonalInformationStep()
                                : _currentStep == 2
                                    ? _buildActivityLevelStep()
                                    : _buildDietaryPreferencesStep(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: largeSpacing),
                  // Navigation buttons
                  Row(
                    children: [
                      if (_currentStep > 1)
                        Expanded(
                          child: ActionButton(
                            text: localizations.back,
                            onPressed: _previousStep,
                            style: ActionButtonStyle.filled,
                            backgroundColor: AppColors.getColorWithOpacity(Colors.white, 0.8),
                            textColor: AppColors.primary,
                            isFullWidth: true,
                          ),
                        ),
                      if (_currentStep > 1)
                        const SizedBox(width: mediumSpacing),
                      Expanded(
                        child: ActionButton(
                          text: _currentStep == _totalSteps ? localizations.finish : localizations.next,
                          onPressed: _isFormValid()
                              ? () {
                                  if (_currentStep < _totalSteps) {
                                    _nextStep();
                                  } else {
                                    _showFinalizeAccountDialog();
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
                  const SizedBox(height: mediumSpacing),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInformationStep() {
    final localizations = AppLocalizations.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Age Input
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.whatIsYourAge,
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    localizations.ageHelpsPersonalize,
                    style: AppTextStyles.secondaryText,
                  ),
                ],
              ),
            ),
            const SizedBox(width: mediumSpacing),
            SizedBox(
              width: 120,
              child: _buildPickerField(
                placeholder: localizations.selectAge,
                value: _ageController.text,
                onTap: () {
                  _showPicker(
                    title: localizations.age,
                    items: List.generate(83, (i) => (i + 18).toString()),
                    selectedValue: _ageController.text,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _ageController.text = (index + 18).toString();
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: largeSpacing),

        // Gender Selection
        Text(
          localizations.whatIsYourGender,
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: smallSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 302,
              child: SlidingToggle(
                options: [
                  localizations.male,
                  localizations.female,
                  localizations.otherGender
                ],
                initialSelection: _selectedGender != null ? _selectedGender!.index : 0,
                onToggle: (index) {
                  setState(() {
                    _selectedGender = Gender.values[index];
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: largeSpacing),

        // Weight Input
        Text(
          localizations.whatIsYourWeight,
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: smallSpacing),
        Row(
          children: [
            Expanded(
              child: _buildPickerField(
                placeholder: localizations.selectYourWeight,
                value: _weightController.text,
                onTap: () {
                  _showPicker(
                    title: '${localizations.weight} (${_isWeightMetric ? localizations.kg : localizations.lbs})',
                    items: List.generate(
                      _isWeightMetric ? 200 : 440,
                      (i) => (_isWeightMetric ? i + 30 : i + 66).toString(),
                    ),
                    selectedValue: _weightController.text,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _weightController.text = (_isWeightMetric 
                            ? index + 30 
                            : index + 66).toString();
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: mediumSpacing),
            SizedBox(
              width: 120,
              child: SlidingToggle(
                options: [localizations.kg, localizations.lbs],
                initialSelection: _isWeightMetric ? 0 : 1,
                onToggle: (index) {
                  setState(() {
                    _isWeightMetric = index == 0;
                    // Convert weight if needed
                    if (_weightController.text.isNotEmpty) {
                      final weight = double.parse(_weightController.text);
                      _weightController.text = (_isWeightMetric 
                          ? weight * 0.453592 
                          : weight * 2.20462).round().toString();
                    }
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: largeSpacing),

        // Height Input
        Text(
          localizations.whatIsYourHeight,
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: smallSpacing),
        Row(
          children: [
            Expanded(
              child: _buildPickerField(
                placeholder: localizations.selectYourHeight,
                value: _heightController.text,
                onTap: () {
                  _showPicker(
                    title: '${localizations.height} (${_isHeightMetric ? localizations.cm : localizations.ft})',
                    items: List.generate(
                      _isHeightMetric ? 121 : 48,
                      (i) => (_isHeightMetric ? i + 130 : (i + 48) / 12).toStringAsFixed(_isHeightMetric ? 0 : 1),
                    ),
                    selectedValue: _heightController.text,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _heightController.text = (_isHeightMetric 
                            ? index + 130 
                            : (index + 48) / 12).toStringAsFixed(_isHeightMetric ? 0 : 1);
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: mediumSpacing),
            SizedBox(
              width: 120,
              child: SlidingToggle(
                options: [localizations.cm, localizations.ft],
                initialSelection: _isHeightMetric ? 0 : 1,
                onToggle: (index) {
                  setState(() {
                    _isHeightMetric = index == 0;
                    // Convert height if needed
                    if (_heightController.text.isNotEmpty) {
                      final height = double.parse(_heightController.text);
                      _heightController.text = (_isHeightMetric 
                          ? height * 30.48 
                          : height / 30.48).toStringAsFixed(_isHeightMetric ? 0 : 1);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityLevelStep() {
    final localizations = AppLocalizations.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.activityLevel,
          style: AppTextStyles.heading1,
        ),
        const SizedBox(height: smallSpacing),
        Text(
          localizations.selectYourActivityLevel,
          style: AppTextStyles.secondaryText,
        ),
        const SizedBox(height: largeSpacing),
        _buildActivityOption(
          ActivityLevel.sedentary,
          localizations.sedentary,
          localizations.sedentaryDesc,
          SFIcons.sf_house_fill,
        ),
        const SizedBox(height: mediumSpacing),
        _buildActivityOption(
          ActivityLevel.moderatelyActive,
          localizations.moderatelyActive,
          localizations.moderatelyActiveDesc,
          SFIcons.sf_figure_walk,
        ),
        const SizedBox(height: mediumSpacing),
        _buildActivityOption(
          ActivityLevel.highlyActive,
          localizations.highlyActive,
          localizations.highlyActiveDesc,
          SFIcons.sf_figure_walk_circle_fill,
        ),
      ],
    );
  }

  Widget _buildActivityOption(ActivityLevel level, String title, String description, IconData icon) {
    final isSelected = _activityLevel == level;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        setState(() {
          _activityLevel = level;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(mediumPadding),
        decoration: BoxDecoration(
          color: AppColors.getSurfaceWithOpacity(0.1),
          borderRadius: BorderRadius.circular(mediumPadding),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.getPrimaryWithOpacity(0.2),
            width: isSelected ? borderWidthSelected : borderWidth,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.withColor(
                      AppTextStyles.heading3,
                      isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.secondaryText,
                  ),
                ],
              ),
            ),
            const SizedBox(width: mediumSpacing),
            SFIcon(
              icon,
              fontSize: iconSize,
              color: isSelected ? AppColors.primary : AppColors.secondaryLabel,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietaryPreferencesStep() {
    final localizations = AppLocalizations.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.dietaryPreferences,
          style: AppTextStyles.heading1,
        ),
        const SizedBox(height: smallSpacing),
        Text(
          localizations.selectYourDietType,
          style: AppTextStyles.secondaryText,
        ),
        const SizedBox(height: largeSpacing),
        _buildDietOption(
          DietType.keto,
          localizations.keto,
          localizations.ketoDesc,
          SFIcons.sf_chart_pie_fill,
        ),
        const SizedBox(height: mediumSpacing),
        _buildDietOption(
          DietType.vegan,
          localizations.vegan,
          localizations.veganDesc,
          SFIcons.sf_leaf_fill,
        ),
        const SizedBox(height: mediumSpacing),
        _buildDietOption(
          DietType.balanced,
          localizations.balanced,
          localizations.balancedDesc,
          SFIcons.sf_square_grid_3x3_fill,
        ),
        const SizedBox(height: mediumSpacing),
        _buildDietOption(
          DietType.other,
          localizations.other,
          localizations.specifyDiet,
          SFIcons.sf_plus_circle_fill,
        ),
        if (_dietType == DietType.other) ...[
          const SizedBox(height: mediumSpacing),
          Container(
            decoration: BoxDecoration(
              color: AppColors.getSurfaceWithOpacity(0.1),
              borderRadius: BorderRadius.circular(smallPadding),
              border: Border.all(
                color: AppColors.getPrimaryWithOpacity(0.2),
                width: borderWidth,
              ),
            ),
            child: CupertinoTextField(
              controller: _otherDietController,
              placeholder: localizations.enterDietType,
              padding: const EdgeInsets.all(mediumPadding),
              decoration: null,
              style: AppTextStyles.bodyMedium,
              placeholderStyle: AppTextStyles.secondaryText,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDietOption(DietType type, String title, String description, IconData icon) {
    final isSelected = _dietType == type;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        setState(() {
          _dietType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(mediumPadding),
        decoration: BoxDecoration(
          color: AppColors.getSurfaceWithOpacity(0.1),
          borderRadius: BorderRadius.circular(mediumPadding),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.getPrimaryWithOpacity(0.2),
            width: isSelected ? borderWidthSelected : borderWidth,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.withColor(
                      AppTextStyles.heading3,
                      isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.secondaryText,
                  ),
                ],
              ),
            ),
            const SizedBox(width: mediumSpacing),
            SFIcon(
              icon,
              fontSize: iconSize,
              color: isSelected ? AppColors.primary : AppColors.secondaryLabel,
            ),
          ],
        ),
      ),
    );
  }

  bool _isFormValid() {
    if (_currentStep == 1) {
      return _ageController.text.isNotEmpty &&
          _selectedGender != null &&
          _weightController.text.isNotEmpty &&
          _heightController.text.isNotEmpty;
    } else if (_currentStep == 2) {
      return _activityLevel != null;
    } else if (_currentStep == 3) {
      if (_dietType == DietType.other) {
        return _otherDietController.text.isNotEmpty;
      }
      return _dietType != null;
    }
    return false;
  }

  void _showFinalizeAccountDialog() {
    final localizations = AppLocalizations.of(context);
    
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          localizations.profileComplete,
          style: AppTextStyles.bodyLarge,
        ),
        content: Text(
          localizations.profileCompleteDesc,
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              localizations.continueText,
              style: AppTextStyles.bodyMedium,
            ),
            onPressed: () {
              context.pop(); // Close dialog
              // Navigate to setup loading screen
              context.goNamed('setup-loading');
            },
          ),
        ],
      ),
    );
  }
} 