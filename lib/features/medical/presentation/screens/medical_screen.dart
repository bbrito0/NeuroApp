import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_sficon/flutter_sficon.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'family_medical_history_screen.dart';

// GoRouter imports
import 'package:go_router/go_router.dart';

class MedicalScreen extends StatefulWidget {
  const MedicalScreen({
    super.key,
  });

  @override
  State<MedicalScreen> createState() => _MedicalScreenState();
}

class _MedicalScreenState extends State<MedicalScreen> {
  // Add GlobalKeys for tutorial targets
  final GlobalKey _medicalReportsKey = GlobalKey();
  final GlobalKey _caregiverPortalKey = GlobalKey();
  final GlobalKey _upcomingMeetingsKey = GlobalKey();
  final GlobalKey _medicalHistoryKey = GlobalKey();
  
  final ScrollController _scrollController = ScrollController();
  
  // Constants for UI dimensions
  static const double cardBorderRadius = 20.0;
  static const double standardPadding = 16.0;
  static const double smallPadding = 12.0;
  static const double iconSize = 24.0;

  final List<Map<String, dynamic>> _caregivers = [
    {
      'name': 'Dr. Sarah Johnson',
      'specialty': 'Neurologist',
      'rating': 4.9,
      'reviews': 127,
      'available': true,
      'image': 'assets/images/doctor1.jpg',
    },
    {
      'name': 'Dr. Michael Chen',
      'specialty': 'Psychiatrist',
      'rating': 4.8,
      'reviews': 93,
      'available': true,
      'image': 'assets/images/doctor2.jpg',
    },
    // Add more caregivers as needed
  ];

  final List<Map<String, dynamic>> _upcomingMeetings = [
    {
      'doctor': 'Dr. Sarah Johnson',
      'date': '2024-03-20',
      'time': '10:30 AM',
      'type': 'Follow-up',
      'status': 'Confirmed',
    },
    // Add more meetings as needed
  ];

  @override
  void initState() {
    super.initState();
    
    // Show tutorial when the screen is first built if enabled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (TutorialService.shouldShowTutorial(TutorialService.MEDICAL_TUTORIAL)) {
        _showTutorial();
        TutorialService.markTutorialAsShown(TutorialService.MEDICAL_TUTORIAL);
      }
    });
  }

  void _showTutorial() {
    TutorialService.createMedicalScreenTutorial(
      context,
      [_medicalReportsKey, _caregiverPortalKey, _upcomingMeetingsKey, _medicalHistoryKey],
      _scrollController,
    ).show(context: context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Background gradient
          GradientBackground(
            customGradient: AppColors.primaryGradient,
            hasSafeArea: false,
            child: Container(),
          ),
          // Main Content
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                  localizations.medicalScreen,
                  style: AppTextStyles.withColor(
                    AppTextStyles.heading1,
                    AppColors.textPrimary,
                  ),
                ),
                middle: Text(
                  localizations.medicalScreen,
                  style: AppTextStyles.withColor(
                    AppTextStyles.heading3,
                    AppColors.textPrimary,
                  ),
                ),
                alwaysShowMiddle: false,
                backgroundColor: Colors.transparent,
                border: null,
                stretch: false,
                automaticallyImplyLeading: false,
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => context.go('/home'),
                  child: const Icon(
                    CupertinoIcons.back,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      // Medical Reports Section
                      _buildSectionTitle(localizations.medicalReports),
                      const SizedBox(height: 12),
                      Container(
                        key: _medicalReportsKey,
                        child: _buildMedicalReportsCard(),
                      ),
                      const SizedBox(height: 24),

                      // Caregiver Portal Section
                      _buildSectionTitle(localizations.caregiverPortal),
                      const SizedBox(height: 12),
                      SizedBox(
                        key: _caregiverPortalKey,
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _caregivers.length,
                          itemBuilder: (context, index) => _buildCaregiverCard(_caregivers[index]),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Upcoming Meetings Section
                      _buildSectionTitle(localizations.upcomingMeetings),
                      const SizedBox(height: 12),
                      Container(
                        key: _upcomingMeetingsKey,
                        child: Column(
                          children: _upcomingMeetings
                              .map((meeting) => _buildMeetingCard(meeting))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Medical History Form Section
                      _buildSectionTitle(localizations.medicalHistory),
                      const SizedBox(height: 12),
                      Container(
                        key: _medicalHistoryKey,
                        child: _buildMedicalHistoryForm(),
                      ),
                      const SizedBox(height: 32),
                      // Add safe area bottom padding
                      SizedBox(height: MediaQuery.of(context).padding.bottom + 70),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.withColor(
        AppTextStyles.heading2,
        AppColors.textPrimary,
      ),
    );
  }

  Widget _buildMedicalReportsCard() {
    final localizations = AppLocalizations.of(context);
    
    return FrostedCard(
      borderRadius: cardBorderRadius,
      padding: const EdgeInsets.all(standardPadding),
      backgroundColor: AppColors.getSurfaceWithOpacity(0.8),
      border: Border.all(
        color: AppColors.getPrimaryWithOpacity(0.1),
        width: 0.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(smallPadding),
                decoration: BoxDecoration(
                  color: AppColors.getPrimaryWithOpacity(0.1),
                  borderRadius: BorderRadius.circular(smallPadding),
                ),
                child: const SFIcon(
                  SFIcons.sf_doc_text,
                  fontSize: iconSize,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: smallPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.latestReport,
                      style: AppTextStyles.withColor(
                        AppTextStyles.heading3,
                        AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      localizations.reportDate,
                      style: AppTextStyles.secondaryText,
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  // Handle view report
                },
                child: Container(
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
                        localizations.viewButton,
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCaregiverCard(Map<String, dynamic> caregiver) {
    final localizations = AppLocalizations.of(context);
    
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: FrostedCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(16),
        backgroundColor: AppColors.getSurfaceWithOpacity(0.8),
        border: Border.all(
          color: AppColors.getPrimaryWithOpacity(0.1),
          width: 0.5,
        ),
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
                        caregiver['name'],
                        style: AppTextStyles.withColor(
                          AppTextStyles.heading3,
                          AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        caregiver['specialty'],
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
                  '${caregiver['rating']} (${localizations.reviews(caregiver['reviews'])})',
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
                    color: caregiver['available']
                        ? AppColors.getColorWithOpacity(const Color(0xFF34C759), 0.1)
                        : AppColors.getPrimaryWithOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    caregiver['available'] ? localizations.availableNow : localizations.unavailable,
                    style: AppTextStyles.withColor(
                      AppTextStyles.bodySmall,
                      caregiver['available']
                          ? const Color(0xFF34C759)
                          : AppColors.primary,
                    ),
                  ),
                ),
                const Spacer(),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    // Handle schedule
                  },
                  child: Container(
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
                          localizations.scheduleButton,
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingCard(Map<String, dynamic> meeting) {
    final localizations = AppLocalizations.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FrostedCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(16),
        backgroundColor: AppColors.getSurfaceWithOpacity(0.8),
        border: Border.all(
          color: AppColors.getPrimaryWithOpacity(0.1),
          width: 0.5,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.getPrimaryWithOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const SFIcon(
                SFIcons.sf_video_fill,
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
                    meeting['doctor'],
                    style: AppTextStyles.withColor(
                      AppTextStyles.heading3,
                      AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    localizations.meetingTime(meeting['date'], meeting['time']),
                    style: AppTextStyles.secondaryText,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.getColorWithOpacity(const Color(0xFF34C759), 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      meeting['status'],
                      style: AppTextStyles.withColor(
                        AppTextStyles.bodySmall,
                        const Color(0xFF34C759),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                // Handle join meeting
              },
              child: Container(
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
                      localizations.joinButton,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalHistoryForm() {
    final localizations = AppLocalizations.of(context);
    
    return FrostedCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      backgroundColor: AppColors.getSurfaceWithOpacity(0.8),
      border: Border.all(
        color: AppColors.getPrimaryWithOpacity(0.1),
        width: 0.5,
      ),
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
                  SFIcons.sf_list_clipboard,
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
                      localizations.familyMedicalHistory,
                      style: AppTextStyles.withColor(
                        AppTextStyles.heading3,
                        AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      localizations.lastUpdated("March 18, 2024"),
                      style: AppTextStyles.secondaryText,
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const FamilyMedicalHistoryScreen(),
                    ),
                  );
                },
                child: Container(
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
                        localizations.editButton,
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
              ),
            ],
          ),
        ],
      ),
    );
  }
} 