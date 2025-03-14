import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'games/memory_match_game.dart';
import 'games/pattern_recall_game.dart';
import 'games/reaction_game.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../services/tutorial_service.dart';

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
          CupertinoScrollbar(
            thickness: 3.0,
            radius: const Radius.circular(1.5),
            mainAxisMargin: 2.0,
            child: CustomScrollView(
              controller: _scrollController,
              primary: false,
              physics: const BouncingScrollPhysics(),
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text(
                    'Cognitive Assessment',
                    style: AppTextStyles.withColor(AppTextStyles.heading1, AppColors.textPrimary),
                  ),
                  middle: Text(
                    'Cognitive Assessment',
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
                              'Lets Train That Brain',
                              style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          height: 180,
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
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final challenge = challenges[index];
                        return GestureDetector(
                          onTap: () => _navigateToChallenge(context, challenge.name),
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SFIcon(
                                      challenge.icon,
                                      fontSize: 28,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      challenge.name,
                                      style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      challenge.description,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.secondaryText,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Start',
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
                            ),
                          ),
                        );
                      },
                      childCount: challenges.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToChallenge(BuildContext context, String challengeName) {
    Widget screen;
    switch (challengeName) {
      case 'Memory Match':
        screen = const MemoryMatchGame();
        break;
      case 'Pattern Quest':
        screen = const PatternRecallGame();
        break;
      case 'Quick Reaction':
        screen = const ReactionGame();
        break;
      default:
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
    final challenge = challenges[index];
    return GestureDetector(
      onTap: () => _navigateToChallenge(context, challenge.name),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SFIcon(
                  challenge.icon,
                  fontSize: 28,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  challenge.name,
                  style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  challenge.description,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.secondaryText,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Start',
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
        ),
      ),
    );
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

final List<Challenge> challenges = [
  Challenge(
    name: 'Memory Match',
    description: 'Enhance your memory capacity',
    icon: SFIcons.sf_square_grid_2x2,
  ),
  Challenge(
    name: 'Quick Reaction',
    description: 'Test your reflexes',
    icon: SFIcons.sf_bolt,
  ),
  Challenge(
    name: 'Pattern Quest',
    description: 'Train pattern recognition',
    icon: SFIcons.sf_rectangle_grid_3x2,
  ),
  Challenge(
    name: 'Word Recall',
    description: 'Improve verbal memory',
    icon: SFIcons.sf_text_quote,
  ),
  Challenge(
    name: 'Focus Timer',
    description: 'Build concentration',
    icon: SFIcons.sf_timer,
  ),
  Challenge(
    name: 'Visual Puzzle',
    description: 'Train spatial thinking',
    icon: SFIcons.sf_puzzlepiece,
  ),
]; 