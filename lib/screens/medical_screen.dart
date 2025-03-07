import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class MedicalScreen extends StatefulWidget {
  const MedicalScreen({
    super.key,
    required this.tabController,
  });

  final CupertinoTabController tabController;

  @override
  State<MedicalScreen> createState() => _MedicalScreenState();
}

class _MedicalScreenState extends State<MedicalScreen> {
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
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
          ),
          // Frosted Glass Overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.frostedGlassGradient,
              ),
            ),
          ),
          // Main Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                  'Medical Portal',
                  style: AppTextStyles.withColor(
                    AppTextStyles.heading1,
                    AppColors.textPrimary,
                  ),
                ),
                middle: Text(
                  'Medical Portal',
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
                  onPressed: () => widget.tabController.index = 0,
                  child: Icon(
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
                      _buildSectionTitle('Medical Reports'),
                      const SizedBox(height: 12),
                      _buildMedicalReportsCard(),
                      const SizedBox(height: 24),

                      // Caregiver Portal Section
                      _buildSectionTitle('Caregiver Portal'),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _caregivers.length,
                          itemBuilder: (context, index) => _buildCaregiverCard(_caregivers[index]),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Upcoming Meetings Section
                      _buildSectionTitle('Upcoming Meetings'),
                      const SizedBox(height: 12),
                      Column(
                        children: _upcomingMeetings
                            .map((meeting) => _buildMeetingCard(meeting))
                            .toList(),
                      ),
                      const SizedBox(height: 24),

                      // Medical History Form Section
                      _buildSectionTitle('Medical History'),
                      const SizedBox(height: 12),
                      _buildMedicalHistoryForm(),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                AppColors.getSurfaceWithOpacity(0.8),
                AppColors.getSurfaceWithOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.getPrimaryWithOpacity(0.1),
              width: 0.5,
            ),
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
                    child: SFIcon(
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
                            'View',
                            style: AppTextStyles.withColor(
                              AppTextStyles.bodyMedium,
                              AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          SFIcon(
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
      ),
    );
  }

  Widget _buildCaregiverCard(Map<String, dynamic> caregiver) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.getSurfaceWithOpacity(0.8),
                  AppColors.getSurfaceWithOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.getPrimaryWithOpacity(0.1),
                width: 0.5,
              ),
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
                      child: Center(
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
                    SFIcon(
                      SFIcons.sf_star_fill,
                      fontSize: 14,
                      color: const Color(0xFFFFB800),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${caregiver['rating']} (${caregiver['reviews']} reviews)',
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
                            ? const Color(0xFF34C759).withOpacity(0.1)
                            : AppColors.getPrimaryWithOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        caregiver['available'] ? 'Available Now' : 'Unavailable',
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
                              'Schedule',
                              style: AppTextStyles.withColor(
                                AppTextStyles.bodyMedium,
                                AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            SFIcon(
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
        ),
      ),
    );
  }

  Widget _buildMeetingCard(Map<String, dynamic> meeting) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.getSurfaceWithOpacity(0.8),
                  AppColors.getSurfaceWithOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.getPrimaryWithOpacity(0.1),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.getPrimaryWithOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SFIcon(
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
                        '${meeting['date']} at ${meeting['time']}',
                        style: AppTextStyles.secondaryText,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF34C759).withOpacity(0.1),
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
                          'Join',
                          style: AppTextStyles.withColor(
                            AppTextStyles.bodyMedium,
                            AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        SFIcon(
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
        ),
      ),
    );
  }

  Widget _buildMedicalHistoryForm() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.getSurfaceWithOpacity(0.8),
                AppColors.getSurfaceWithOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.getPrimaryWithOpacity(0.1),
              width: 0.5,
            ),
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
                    child: SFIcon(
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
                          'Family Medical History',
                          style: AppTextStyles.withColor(
                            AppTextStyles.heading3,
                            AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Last updated: March 18, 2024',
                          style: AppTextStyles.secondaryText,
                        ),
                      ],
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      // Handle edit form
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
                            'Edit',
                            style: AppTextStyles.withColor(
                              AppTextStyles.bodyMedium,
                              AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          SFIcon(
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
      ),
    );
  }
} 