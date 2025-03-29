import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../main.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'onboarding_features_slideshow.dart';
import 'finalize_account_screen.dart';
import 'post_medical_decision_screen.dart';
import 'setup_loading_screen.dart';
import 'home_screen.dart';
import '../widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Gender { male, female, other }
enum ActivityLevel { sedentary, moderatelyActive, highlyActive }
enum DietType { keto, vegan, balanced, other }

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
              title: Text(AppLocalizations.of(context)!.incompleteInformation),
              content: Text(AppLocalizations.of(context)!.fillAllFields),
              actions: [
                CupertinoDialogAction(
                  child: Text(AppLocalizations.of(context)!.ok),
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
            title: Text(AppLocalizations.of(context)!.activityLevelRequired),
            content: Text(AppLocalizations.of(context)!.selectActivityLevel),
            actions: [
              CupertinoDialogAction(
                child: Text(AppLocalizations.of(context)!.ok),
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
            title: Text(AppLocalizations.of(context)!.dietTypeRequired),
            content: Text(AppLocalizations.of(context)!.selectDietType),
            actions: [
              CupertinoDialogAction(
                child: Text(AppLocalizations.of(context)!.ok),
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
        height: 250,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primary.withOpacity(0.1),
                    width: 0.5,
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
                      AppLocalizations.of(context)!.cancel,
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
                      AppLocalizations.of(context)!.done,
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
                itemExtent: 40,
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
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.getPrimaryWithOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 0.5,
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
                const SizedBox(width: 8),
                SFIcon(
                  SFIcons.sf_chevron_down,
                  color: AppColors.secondaryLabel,
                  fontSize: 12,
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
    final localizations = AppLocalizations.of(context)!;
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      navigationBar: CustomNavigationBar(
        currentStep: _currentStep,
        totalSteps: _totalSteps,
        title: localizations.medicalHistory,
        subtitle: localizations.medicalHistoryInfo,
        onBackPressed: () => Navigator.of(context).pop(),
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // Step content
                  Expanded(
                    child: FrostedCard(
                      borderRadius: 16,
                      padding: const EdgeInsets.all(24),
                      backgroundColor: Colors.white.withOpacity(0.8),
                      border: Border.all(
                        color: AppColors.getPrimaryWithOpacity(0.2),
                        width: 0.5,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Step title and description
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
                                    SFIcons.sf_heart_fill,
                                    fontSize: 12,
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
                            const SizedBox(height: 16),
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
                  const SizedBox(height: 24),
                  // Navigation buttons
                  Row(
                    children: [
                      if (_currentStep > 1)
                        Expanded(
                          child: ActionButton(
                            text: localizations.back,
                            onPressed: _previousStep,
                            style: ActionButtonStyle.filled,
                            backgroundColor: Colors.white.withOpacity(0.8),
                            textColor: AppColors.primary,
                            isFullWidth: true,
                          ),
                        ),
                      if (_currentStep > 1)
                        const SizedBox(width: 16),
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl<T extends Object>({
    required T? groupValue,
    required Map<T, String> options,
    required ValueChanged<T?> onValueChanged,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.transparent,
              width: 0.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: CupertinoSlidingSegmentedControl<T>(
              groupValue: groupValue,
              backgroundColor: AppColors.getPrimaryWithOpacity(0.2),
              thumbColor: AppColors.getPrimaryWithOpacity(0.6),
              padding: EdgeInsets.zero,
              
              children: options.map(
                (key, value) => MapEntry(
                  key,
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    child: Text(
                      value,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: key == groupValue 
                            ? AppColors.secondaryLabel
                            : AppColors.secondaryLabel,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              onValueChanged: onValueChanged,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInformationStep() {
    final localizations = AppLocalizations.of(context)!;
    
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
            const SizedBox(width: 16),
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
        const SizedBox(height: 24),

        // Gender Selection
        Text(
          localizations.whatIsYourGender,
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 8),
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
        const SizedBox(height: 24),

        // Weight Input
        Text(
          localizations.whatIsYourWeight,
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 8),
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
            const SizedBox(width: 16),
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
        const SizedBox(height: 24),

        // Height Input
        Text(
          localizations.whatIsYourHeight,
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 8),
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
            const SizedBox(width: 16),
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
    final localizations = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.activityLevel,
          style: AppTextStyles.heading1,
        ),
        const SizedBox(height: 8),
        Text(
          localizations.selectYourActivityLevel,
          style: AppTextStyles.secondaryText,
        ),
        const SizedBox(height: 24),
        _buildActivityOption(
          ActivityLevel.sedentary,
          localizations.sedentary,
          localizations.sedentaryDesc,
          SFIcons.sf_house_fill,
        ),
        const SizedBox(height: 16),
        _buildActivityOption(
          ActivityLevel.moderatelyActive,
          localizations.moderatelyActive,
          localizations.moderatelyActiveDesc,
          SFIcons.sf_figure_walk,
        ),
        const SizedBox(height: 16),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.getSurfaceWithOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.getPrimaryWithOpacity(0.2),
            width: isSelected ? 2 : 0.5,
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
            const SizedBox(width: 16),
            SFIcon(
              icon,
              fontSize: 20,
              color: isSelected ? AppColors.primary : AppColors.secondaryLabel,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietaryPreferencesStep() {
    final localizations = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.dietaryPreferences,
          style: AppTextStyles.heading1,
        ),
        const SizedBox(height: 8),
        Text(
          localizations.selectYourDietType,
          style: AppTextStyles.secondaryText,
        ),
        const SizedBox(height: 24),
        _buildDietOption(
          DietType.keto,
          localizations.keto,
          localizations.ketoDesc,
          SFIcons.sf_chart_pie_fill,
        ),
        const SizedBox(height: 16),
        _buildDietOption(
          DietType.vegan,
          localizations.vegan,
          localizations.veganDesc,
          SFIcons.sf_leaf_fill,
        ),
        const SizedBox(height: 16),
        _buildDietOption(
          DietType.balanced,
          localizations.balanced,
          localizations.balancedDesc,
          SFIcons.sf_square_grid_3x3_fill,
        ),
        const SizedBox(height: 16),
        _buildDietOption(
          DietType.other,
          localizations.other,
          localizations.specifyDiet,
          SFIcons.sf_plus_circle_fill,
        ),
        if (_dietType == DietType.other) ...[
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.getSurfaceWithOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.getPrimaryWithOpacity(0.2),
                width: 0.5,
              ),
            ),
            child: CupertinoTextField(
              controller: _otherDietController,
              placeholder: localizations.enterDietType,
              padding: const EdgeInsets.all(16),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.getSurfaceWithOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.getPrimaryWithOpacity(0.2),
            width: isSelected ? 2 : 0.5,
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
            const SizedBox(width: 16),
            SFIcon(
              icon,
              fontSize: 20,
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
    final localizations = AppLocalizations.of(context)!;
    
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
              Navigator.pop(context); // Close dialog
              // Navigate to setup loading screen
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (context) => const SetupLoadingScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} 