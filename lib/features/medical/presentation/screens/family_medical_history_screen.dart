import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../../../../core/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FamilyMedicalHistoryScreen extends StatefulWidget {
  const FamilyMedicalHistoryScreen({super.key});

  @override
  State<FamilyMedicalHistoryScreen> createState() =>
      _FamilyMedicalHistoryScreenState();
}

class _FamilyMedicalHistoryScreenState extends State<FamilyMedicalHistoryScreen> {
  // Add state lists for selected items
  List<String> _selectedConditions = [];
  List<String> _selectedAllergies = [];
  List<String> _selectedMedications = [];

  // --- Define Sample Options (Replace with actual data source later) ---
  final List<String> _conditionOptions = [
    'Diabetes', 'High Blood Pressure', 'Heart Disease', 'Asthma', 'Cancer', 'Arthritis', 'Thyroid Issues', 'Migraines', 'Alzheimer\'s/Dementia'
  ];
  final List<String> _allergyOptions = [
    'Penicillin', 'Sulfa Drugs', 'Aspirin', 'Pollen', 'Dust Mites', 'Peanuts', 'Shellfish', 'Latex'
  ];
  final List<String> _medicationOptions = [
    'Blood Thinners (Sensitivity)', 'Beta Blockers (Sensitivity)', 'Pain Relievers (Sensitivity)', 'Antibiotics (Sensitivity)', 'Statins (Sensitivity)'
  ];
  // -------------------------------------------------------------------

  // UI Constants - Reuse from MedicalRecordScreen or define similar ones
  static const double standardPadding = 24.0;
  static const double mediumPadding = 16.0;
  static const double largeSpacing = 24.0;
  static const double mediumSpacing = 16.0;
  static const double borderRadius = 20.0;
  static const double borderWidth = 0.5;
  static const double buttonHeight = 44.0;

  @override
  void dispose() {
    // Remove controller disposal
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent, // Use transparent for gradient background
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          localizations.familyMedicalHistory, // Use localization
          style: AppTextStyles.heading3,
        ),
        backgroundColor: Colors.transparent, // Make nav bar transparent
        border: null, // Remove border
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: Stack(
        children: [
          // Background Gradient
          GradientBackground(
            customGradient: AppColors.primaryGradient,
            hasSafeArea: false,
            child: Container(),
          ),
          // Frosted Effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.frostedGlassGradient,
              ),
            ),
          ),
          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: standardPadding),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: FrostedCard(
                        borderRadius: borderRadius,
                        padding: const EdgeInsets.all(standardPadding),
                        backgroundColor: AppColors.getColorWithOpacity(Colors.white, 0.8),
                        border: Border.all(
                          color: AppColors.getPrimaryWithOpacity(0.2),
                          width: borderWidth,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader(
                              localizations.familyMedicalHistory,
                              localizations.familyMedicalHistoryDesc,
                              SFIcons.sf_heart_text_square_fill,
                            ),
                            const SizedBox(height: largeSpacing),
                            _buildMultiSelectField(
                              label: localizations.knownConditions,
                              selectedItems: _selectedConditions,
                              onTap: () => _showMultiSelectPicker(
                                title: localizations.knownConditions,
                                options: _conditionOptions,
                                currentSelection: _selectedConditions,
                                onSelectionChanged: (List<String> selected) {
                                  setState(() {
                                    _selectedConditions = selected;
                                  });
                                },
                              ),
                              placeholder: localizations.familyConditionsPlaceholder,
                            ),
                            const SizedBox(height: mediumSpacing),
                            _buildMultiSelectField(
                              label: localizations.knownAllergies,
                              selectedItems: _selectedAllergies,
                              onTap: () => _showMultiSelectPicker(
                                title: localizations.knownAllergies,
                                options: _allergyOptions,
                                currentSelection: _selectedAllergies,
                                onSelectionChanged: (List<String> selected) {
                                  setState(() {
                                    _selectedAllergies = selected;
                                  });
                                },
                              ),
                              placeholder: localizations.familyAllergiesPlaceholder,
                            ),
                            const SizedBox(height: mediumSpacing),
                            _buildMultiSelectField(
                              label: localizations.relevantMedications,
                              selectedItems: _selectedMedications,
                              onTap: () => _showMultiSelectPicker(
                                title: localizations.relevantMedications,
                                options: _medicationOptions,
                                currentSelection: _selectedMedications,
                                onSelectionChanged: (List<String> selected) {
                                  setState(() {
                                    _selectedMedications = selected;
                                  });
                                },
                              ),
                              placeholder: localizations.familyMedicationsPlaceholder,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: largeSpacing),
                  // Save Button
                  ActionButton(
                    text: localizations.save,
                    onPressed: () {
                      // Save logic remains the same (now uses state lists)
                      // TODO: Implement actual save logic
                      Navigator.pop(context); // Go back after saving
                    },
                    style: ActionButtonStyle.filled,
                    backgroundColor: AppColors.primary,
                    textColor: AppColors.surface,
                    isFullWidth: true,
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

  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.getPrimaryWithOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SFIcon(
            icon,
            fontSize: 24,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: mediumSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.withColor(
                  AppTextStyles.heading3,
                  AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.secondaryText,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- New Multi-Select Field Widget ---
  Widget _buildMultiSelectField({
    required String label,
    required List<String> selectedItems,
    required VoidCallback onTap,
    required String placeholder,
  }) {
    bool hasSelection = selectedItems.isNotEmpty;
    String displayText = hasSelection
        ? selectedItems.join(', ')
        : placeholder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: buttonHeight), // Ensure minimum height
            padding: const EdgeInsets.symmetric(horizontal: mediumPadding, vertical: 12.0), // Adjust vertical padding
            decoration: BoxDecoration(
              color: AppColors.getSurfaceWithOpacity(0.1),
              borderRadius: BorderRadius.circular(mediumPadding),
              border: Border.all(
                color: AppColors.getPrimaryWithOpacity(0.2),
                width: borderWidth,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    displayText,
                    style: hasSelection
                        ? AppTextStyles.bodyMedium
                        : AppTextStyles.secondaryText.copyWith(fontSize: 14),
                    maxLines: 3, // Allow multiple lines for display
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  CupertinoIcons.chevron_down,
                  size: 16,
                  color: AppColors.secondaryLabel,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- New Multi-Select Picker Method ---
  void _showMultiSelectPicker({
    required String title,
    required List<String> options,
    required List<String> currentSelection,
    required ValueChanged<List<String>> onSelectionChanged,
  }) {
    final localizations = AppLocalizations.of(context);
    List<String> tempSelection = List.from(currentSelection); // Use temporary list for changes
    final boldBodyStyle = AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold);

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: AppColors.surface, // Use a solid surface color for the modal
                borderRadius: const BorderRadius.vertical(top: Radius.circular(borderRadius)),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.getPrimaryWithOpacity(0.1), width: 0.5)), // Use existing color
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          child: Text(
                            localizations.cancel,
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(title, style: boldBodyStyle), // Use bold style
                        CupertinoButton(
                          child: Text(
                            localizations.done,
                            style: boldBodyStyle.copyWith(color: AppColors.primary), // Use bold style
                          ),
                          onPressed: () {
                            onSelectionChanged(tempSelection);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  // Options List
                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final isSelected = tempSelection.contains(option);
                        return GestureDetector( // Use GestureDetector for tap
                          onTap: () {
                            setDialogState(() {
                              if (isSelected) {
                                tempSelection.remove(option);
                              } else {
                                tempSelection.add(option);
                              }
                            });
                          },
                          child: Container(
                            color: Colors.transparent, // Make background transparent for tap effect
                            padding: const EdgeInsets.symmetric(horizontal: mediumPadding, vertical: 12.0),
                            child: Row(
                              children: [
                                Icon( // Leading Icon
                                  isSelected
                                      ? CupertinoIcons.check_mark_circled_solid
                                      : CupertinoIcons.circle,
                                  color: isSelected ? AppColors.primary : AppColors.secondaryLabel,
                                  size: 22, // Adjust icon size
                                ),
                                const SizedBox(width: mediumPadding), // Space between icon and text
                                Expanded(
                                  child: Text(option, style: AppTextStyles.bodyMedium),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  // --- End New Components ---
} 