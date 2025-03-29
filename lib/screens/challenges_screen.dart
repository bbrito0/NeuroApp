import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'games/memory_match_game.dart';
import 'games/pattern_recall_game.dart';
import 'games/reaction_game.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../services/tutorial_service.dart';
import '../widgets/widgets.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: Icon(
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            localizations.letsTrainBrain,
                            style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            localizations.featuredChallenges,
                            style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: 190,
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildChallengeCard(0, context),
                            ),
                            const SizedBox(width: 16),
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
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    localizations.allChallenges,
                    style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
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
    final localizations = AppLocalizations.of(context)!;
    Widget screen;
    
    if (challengeName == localizations.memoryMatch) {
      screen = const MemoryMatchGame();
    } else if (challengeName == localizations.patternQuest) {
      screen = const PatternRecallGame();
    } else if (challengeName == localizations.quickReaction) {
      screen = const ReactionGame();
    } else {
      return;
    }

    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => screen,
        title: challengeName,
      ),
    );
  }

  Widget _buildChallengeCard(int index, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final challenge = getChallenges(context)[index];
    
    return GestureDetector(
      onTap: () => _navigateToChallenge(context, challenge.name),
      child: FrostedCard(
        borderRadius: 20,
        padding: EdgeInsets.zero,
        backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
        border: Border.all(
          color: AppColors.getPrimaryWithOpacity(0.1),
          width: 0.5,
        ),
        child: Stack(
          children: [
            // Featured label
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
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
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SFIcon(
                    challenge.icon,
                    fontSize: 30,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    challenge.name,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    challenge.description,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.secondaryText,
                  ),
                  const Spacer(),
                  const SizedBox(height: 8),
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
                      const SizedBox(width: 4),
                      SFIcon(
                        SFIcons.sf_chevron_right,
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridChallengeCard(Challenge challenge) {
    final localizations = AppLocalizations.of(context)!;
    
    return FrostedCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
      border: Border.all(
        color: AppColors.getPrimaryWithOpacity(0.1),
        width: 0.5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SFIcon(
            challenge.icon,
            fontSize: 30,
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            challenge.name,
            style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            challenge.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.secondaryText,
          ),
          const Spacer(),
          const SizedBox(height: 8),
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
              const SizedBox(width: 4),
              SFIcon(
                SFIcons.sf_chevron_right,
                fontSize: 12,
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  List<Challenge> getChallenges(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return [
      Challenge(
        name: localizations.memoryMatch,
        description: localizations.memoryMatchDesc,
        icon: SFIcons.sf_square_grid_2x2,
      ),
      Challenge(
        name: localizations.quickReaction,
        description: localizations.quickReactionDesc,
        icon: SFIcons.sf_bolt,
      ),
      Challenge(
        name: localizations.patternQuest,
        description: localizations.patternQuestDesc,
        icon: SFIcons.sf_rectangle_grid_3x2,
      ),
      Challenge(
        name: localizations.wordRecall,
        description: localizations.wordRecallDesc,
        icon: SFIcons.sf_text_quote,
      ),
      Challenge(
        name: localizations.focusTimer,
        description: localizations.focusTimerDesc,
        icon: SFIcons.sf_timer,
      ),
      Challenge(
        name: localizations.visualPuzzle,
        description: localizations.visualPuzzleDesc,
        icon: SFIcons.sf_puzzlepiece,
      ),
    ];
  }
}

class Challenge {
  final String name;
  final String description;
  final IconData icon;

  const Challenge({
    required this.name,
    required this.description,
    required this.icon,
  });
} 