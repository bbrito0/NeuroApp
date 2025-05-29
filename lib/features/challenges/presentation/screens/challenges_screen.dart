import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/services/feature_access_service.dart';
import '../../../../core/datasources/static/feature_mapping.dart';
import '../../../../core/widgets/widgets.dart';

// GoRouter imports
import 'package:go_router/go_router.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  // UI Constants
  static const double standardPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double tinyPadding = 2.0;
  static const double cardBorderRadius = 20.0;
  static const double borderWidth = 0.5;
  static const double mediumSpacing = 12.0;
  static const double largeSpacing = 24.0;
  static const double featureTagPaddingHorizontal = 8.0;
  static const double featureTagPaddingVertical = 3.0;
  static const double featureTagBorderRadius = 8.0;
  static const double largeIconSize = 30.0;
  static const double smallIconSize = 12.0;
  static const double featureTagTop = 12.0;
  static const double featureTagLeft = 12.0;
  
  late ScrollController _scrollController;

  // Single GlobalKey for tutorial target
  final GlobalKey challengesOverviewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Show tutorial when the screen is first built if enabled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (TutorialService.shouldShowTutorial(TutorialService.COGNITIVE_TUTORIAL)) {
        _showTutorial();
        TutorialService.markTutorialAsShown(TutorialService.COGNITIVE_TUTORIAL);
      }
    });
  }

  void _showTutorial() {
    TutorialService.createChallengesTutorial(
      context,
      [challengesOverviewKey],
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
          // Premium Gradient Background
          GradientBackground(
            customGradient: AppColors.primaryGradient,
            hasSafeArea: false,
            child: Container(),
          ),
          // Main Content
          CustomScrollView(
            controller: _scrollController,
            primary: false,
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                  localizations.cognitiveAssessment,
                  style: AppTextStyles.withColor(AppTextStyles.heading1, AppColors.textPrimary),
                ),
                middle: Text(
                  localizations.cognitiveAssessment,
                  style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                ),
                backgroundColor: Colors.transparent,
                border: null,
                alwaysShowMiddle: false,
                stretch: false,
                automaticallyImplyLeading: false,
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => context.pop(),
                  child: const Icon(
                    CupertinoIcons.back,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  key: challengesOverviewKey,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: standardPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: smallPadding),
                          Text(
                            localizations.letsTrainBrain,
                            style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
                          ),
                          const SizedBox(height: standardPadding),
                          Text(
                            localizations.featuredChallenges,
                            style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                          ),
                          const SizedBox(height: mediumSpacing),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: standardPadding),
                      child: SizedBox(
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildChallengeCard(0, context),
                            ),
                            const SizedBox(width: standardPadding),
                            Expanded(
                              child: _buildChallengeCard(1, context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(standardPadding, largeSpacing, standardPadding, smallPadding),
                  child: Text(
                    localizations.allChallenges,
                    style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(standardPadding),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    // Define max width for items, Flutter fits columns accordingly
                    maxCrossAxisExtent: 200.0, // Adjust as needed for desired width
                    // Let mainAxisExtent (height) be determined by content
                    crossAxisSpacing: standardPadding,
                    mainAxisSpacing: standardPadding,
                    // childAspectRatio: childAspectRatio, // REMOVED: Allows variable height
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final challenge = getChallenges(context)[index];
                      return GestureDetector(
                        onTap: () => _navigateToChallenge(context, challenge.name),
                        child: _buildGridChallengeCard(challenge),
                      );
                    },
                    childCount: getChallenges(context).length,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToChallenge(BuildContext context, String challengeName) {
    // TODO: Implement new challenge screens
    // For now, show a dialog indicating the feature is coming soon
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(challengeName),
        content: const Text('This challenge will be available soon with new enhanced features.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(int index, BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final featureAccessService = Provider.of<FeatureAccessService>(context);
    final challenge = getChallenges(context)[index];
    final hasAccess = featureAccessService.canAccess(challenge.featureId);
    final requiredSupplements = featureAccessService.getRequiredSupplementsForFeature(challenge.featureId);
    
    Widget cardContent = FrostedCard(
      borderRadius: cardBorderRadius,
      padding: EdgeInsets.zero,
      backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
      border: Border.all(
        color: AppColors.getPrimaryWithOpacity(0.1),
        width: borderWidth,
      ),
      child: Stack(
        children: [
          // Featured label
          Positioned(
            top: featureTagTop,
            left: featureTagLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: featureTagPaddingHorizontal, 
                vertical: featureTagPaddingVertical
              ),
              decoration: BoxDecoration(
                color: AppColors.getPrimaryWithOpacity(0.15),
                borderRadius: BorderRadius.circular(featureTagBorderRadius),
              ),
              child: Text(
                localizations.featured,
                style: AppTextStyles.withColor(
                  AppTextStyles.bodySmall,
                  AppColors.primary,
                ),
              ),
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.fromLTRB(standardPadding, 40, standardPadding, standardPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SFIcon(
                  challenge.icon,
                  fontSize: largeIconSize,
                  color: AppColors.primary,
                ),
                const SizedBox(height: smallPadding),
                Text(
                  challenge.name,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                ),
                const SizedBox(height: tinyPadding),
                Text(
                  challenge.description,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.secondaryText,
                ),
                const SizedBox(height: smallPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localizations.start,
                      style: AppTextStyles.withColor(
                        AppTextStyles.bodySmall,
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: smallPadding / 2),
                    const SFIcon(
                      SFIcons.sf_chevron_right,
                      fontSize: smallIconSize,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    
    if (!hasAccess) {
      cardContent = LockedFeatureOverlay(
        requiredSupplements: requiredSupplements,
        child: cardContent,
      );
    }
    
    return GestureDetector(
      onTap: hasAccess ? () => _navigateToChallenge(context, challenge.name) : null,
      child: cardContent,
    );
  }

  Widget _buildGridChallengeCard(Challenge challenge) {
    final localizations = AppLocalizations.of(context);
    final featureAccessService = Provider.of<FeatureAccessService>(context);
    final hasAccess = featureAccessService.canAccess(challenge.featureId);
    final requiredSupplements = featureAccessService.getRequiredSupplementsForFeature(challenge.featureId);
    
    Widget cardContent = FrostedCard(
      borderRadius: cardBorderRadius,
      padding: const EdgeInsets.all(standardPadding),
      backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
      border: Border.all(
        color: AppColors.getPrimaryWithOpacity(0.1),
        width: borderWidth,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SFIcon(
            challenge.icon,
            fontSize: largeIconSize,
            color: AppColors.primary,
          ),
          const SizedBox(height: smallPadding),
          Text(
            challenge.name,
            style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: tinyPadding),
          Text(
            challenge.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.secondaryText,
          ),
          const SizedBox(height: smallPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                localizations.start,
                style: AppTextStyles.withColor(
                  AppTextStyles.bodySmall,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: smallPadding / 2),
              const SFIcon(
                SFIcons.sf_chevron_right,
                fontSize: smallIconSize,
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
    
    if (!hasAccess) {
      cardContent = LockedFeatureOverlay(
        requiredSupplements: requiredSupplements,
        child: cardContent,
      );
    }
    
    return GestureDetector(
      onTap: hasAccess ? () => _navigateToChallenge(context, challenge.name) : null,
      child: cardContent,
    );
  }
  
  List<Challenge> getChallenges(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return [
      Challenge(
        name: localizations.memoryMatch,
        description: localizations.memoryMatchDesc,
        icon: SFIcons.sf_square_grid_2x2,
        featureId: FeatureMapping.FEATURE_MEMORY_MATCH,
      ),
      Challenge(
        name: localizations.quickReaction,
        description: localizations.quickReactionDesc,
        icon: SFIcons.sf_bolt,
        featureId: FeatureMapping.FEATURE_QUICK_REACTION,
      ),
      Challenge(
        name: localizations.patternQuest,
        description: localizations.patternQuestDesc,
        icon: SFIcons.sf_rectangle_grid_3x2,
        featureId: FeatureMapping.FEATURE_PATTERN_QUEST,
      ),
      Challenge(
        name: localizations.wordRecall,
        description: localizations.wordRecallDesc,
        icon: SFIcons.sf_text_quote,
        featureId: FeatureMapping.FEATURE_WORD_RECALL,
      ),
      Challenge(
        name: localizations.focusTimer,
        description: localizations.focusTimerDesc,
        icon: SFIcons.sf_timer,
        featureId: FeatureMapping.FEATURE_FOCUS_TIMER,
      ),
      Challenge(
        name: localizations.visualPuzzle,
        description: localizations.visualPuzzleDesc,
        icon: SFIcons.sf_puzzlepiece,
        featureId: FeatureMapping.FEATURE_VISUAL_PUZZLE,
      ),
    ];
  }
}

class Challenge {
  final String name;
  final String description;
  final IconData icon;
  final String featureId;

  const Challenge({
    required this.name,
    required this.description,
    required this.icon,
    required this.featureId,
  });
} 