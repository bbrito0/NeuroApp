import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'challenges_screen.dart';
import 'meditation_screen.dart';
import 'resources_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({
    super.key,
    required this.tabController,
  });

  final CupertinoTabController tabController;

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Premium Gradient Background
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
                  'Activities',
                  style: AppTextStyles.withColor(AppTextStyles.heading1, AppColors.textPrimary),
                ),
                backgroundColor: Colors.transparent,
                border: null,
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Featured Activities',
                        style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
                      ),
                      const SizedBox(height: 16),
                      _buildActivityCard(
                        context,
                        'Cognitive Assessment',
                        'Test and improve your cognitive abilities',
                        SFIcons.sf_puzzlepiece,
                        () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (context) => const ChallengesScreen(),
                              title: 'Cognitive Assessment',
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildActivityCard(
                        context,
                        'Meditation',
                        'Practice mindfulness and relaxation',
                        SFIcons.sf_leaf,
                        () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (context) => const MeditationScreen(),
                              title: 'Meditation',
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildActivityCard(
                        context,
                        'Learning Resources',
                        'Explore educational content and guides',
                        SFIcons.sf_book,
                        () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (context) => ResourcesScreen(tabController: widget.tabController),
                              title: 'Resources',
                            ),
                          );
                        },
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

  Widget _buildActivityCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
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
                  AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                  AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                SFIcon(
                  icon,
                  fontSize: 22,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: AppTextStyles.secondaryText,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SFIcon(
                  SFIcons.sf_chevron_right,
                  fontSize: 14,
                  color: AppColors.getPrimaryWithOpacity(AppColors.inactiveOpacity),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 