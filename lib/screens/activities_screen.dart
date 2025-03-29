import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'challenges_screen.dart';
import 'meditation_screen.dart';
import 'resources_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/widgets.dart';

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
    final localizations = AppLocalizations.of(context)!;
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Premium Gradient Background
          GradientBackground(
            customGradient: AppColors.primaryGradient,
            hasSafeArea: false,
            child: Container(),
          ),
          // Main Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                  localizations.activitiesScreen,
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
                        localizations.featuredActivities,
                        style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
                      ),
                      const SizedBox(height: 16),
                      _buildActivityCard(
                        context,
                        localizations.cognitiveAssessmentTitle,
                        localizations.cognitiveAssessmentDesc,
                        SFIcons.sf_puzzlepiece,
                        () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (context) => const ChallengesScreen(),
                              title: localizations.cognitiveAssessmentTitle,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildActivityCard(
                        context,
                        localizations.meditationTitle,
                        localizations.meditationDesc,
                        SFIcons.sf_leaf,
                        () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (context) => const MeditationScreen(),
                              title: localizations.meditationTitle,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildActivityCard(
                        context,
                        localizations.learningResourcesTitle,
                        localizations.learningResourcesDesc,
                        SFIcons.sf_book,
                        () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (context) => ResourcesScreen(tabController: widget.tabController),
                              title: localizations.resources,
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
      child: FrostedCard(
        borderRadius: 20,
        backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
        padding: const EdgeInsets.all(16),
        border: Border.all(
          color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
          width: 0.5,
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              child: SFIcon(
                icon,
                fontSize: 20,
                color: AppColors.primary,
              ),
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
    );
  }
} 