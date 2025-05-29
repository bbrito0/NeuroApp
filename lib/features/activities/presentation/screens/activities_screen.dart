import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';

// GoRouter imports
import 'package:go_router/go_router.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({
    super.key,
  });

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  // Constants for UI dimensions
  static const double cardBorderRadius = 20.0;
  static const double standardPadding = 16.0;
  static const double iconSize = 20.0;
  static const double iconContainerSize = 24.0;
  static const double chevronIconSize = 14.0;
  static const double verticalSpacing = 16.0;
  static const double smallVerticalSpacing = 4.0;
  static const double horizontalSpacing = 16.0;
  static const double smallHorizontalSpacing = 8.0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
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
                  onPressed: () => context.go('/home'),
                  child: const Icon(
                    CupertinoIcons.back,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(standardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.featuredActivities,
                        style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
                      ),
                      const SizedBox(height: verticalSpacing),
                      _buildActivityCard(
                        context,
                        localizations.cognitiveAssessmentTitle,
                        localizations.cognitiveAssessmentDesc,
                        SFIcons.sf_puzzlepiece,
                        () {
                          context.go('/activities/challenges');
                        },
                      ),
                      const SizedBox(height: verticalSpacing),
                      _buildActivityCard(
                        context,
                        localizations.meditationTitle,
                        localizations.meditationDesc,
                        SFIcons.sf_leaf,
                        () {
                          context.go('/activities/meditations');
                        },
                      ),
                      const SizedBox(height: verticalSpacing),
                      _buildActivityCard(
                        context,
                        localizations.learningResourcesTitle,
                        localizations.learningResourcesDesc,
                        SFIcons.sf_book,
                        () {
                          context.go('/activities/resources');
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
        borderRadius: cardBorderRadius,
        backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
        padding: const EdgeInsets.all(standardPadding),
        border: Border.all(
          color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
          width: 0.5,
        ),
        child: Row(
          children: [
            Container(
              width: iconContainerSize,
              height: iconContainerSize,
              alignment: Alignment.center,
              child: SFIcon(
                icon,
                fontSize: iconSize,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: horizontalSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                  ),
                  const SizedBox(height: smallVerticalSpacing),
                  Text(
                    description,
                    style: AppTextStyles.secondaryText,
                  ),
                ],
              ),
            ),
            const SizedBox(width: smallHorizontalSpacing),
            SFIcon(
              SFIcons.sf_chevron_right,
              fontSize: chevronIconSize,
              color: AppColors.getPrimaryWithOpacity(AppColors.inactiveOpacity),
            ),
          ],
        ),
      ),
    );
  }
} 