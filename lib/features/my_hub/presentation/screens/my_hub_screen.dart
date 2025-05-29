import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'dart:math' show sin, Random;
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/services/user_profile_service.dart';
import '../../../../core/services/wellness_score_service.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/widgets/supplement_influenced_score_widget.dart' as score;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// GoRouter imports
import 'package:go_router/go_router.dart';
import '../../../../app_router.dart';

class MyHubScreen extends StatefulWidget {
  const MyHubScreen({
    super.key,
  });

  @override
  State<MyHubScreen> createState() => _MyHubScreenState();
}

class _MyHubScreenState extends State<MyHubScreen> {
  late PageController _pageController;
  late ScrollController _scrollController;
  int _currentPage = 0;
  
  // Add GlobalKeys for tutorial targets
  final GlobalKey overallScoreKey = GlobalKey();
  final GlobalKey progressKey = GlobalKey();
  final GlobalKey goalsKey = GlobalKey();
  final GlobalKey communityKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 1.0,
      initialPage: 0,
    );
    _scrollController = ScrollController();
    
    // Show tutorial when the screen is first built if enabled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (TutorialService.shouldShowTutorial(TutorialService.MY_HUB_TUTORIAL)) {
        _showTutorial();
        TutorialService.markTutorialAsShown(TutorialService.MY_HUB_TUTORIAL);
      }
    });
  }

  void _showTutorial() {
    TutorialService.createMyHubTutorial(
      context,
      [overallScoreKey, progressKey, goalsKey, communityKey],
      _scrollController,
    ).show(context: context);
  }

  @override
  void dispose() {
    _pageController.dispose();
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
                  localizations.myHub,
                  style: AppTextStyles.withColor(AppTextStyles.heading1, AppColors.textPrimary),
                ),
                middle: Text(
                  localizations.myHub,
                  style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Score Overview Section with key
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          key: overallScoreKey,
                          margin: const EdgeInsets.only(bottom: 24),
                          child: Consumer<UserProfileService>(
                            builder: (context, userProfileService, _) {
                              return Consumer<WellnessScoreService>(
                                builder: (context, wellnessScoreService, _) {
                                  return score.SupplementInfluencedScoreWidget(
                                    size: score.ScoreWidgetSize.large,
                                    userProfileService: userProfileService,
                                    wellnessScoreService: wellnessScoreService,
                                    showCategoryBreakdown: true,
                                    showSupplementInfluence: true,
                                  );
                                }
                              );
                            }
                          ),
                        ),
                      ),
                      // Progress Overview Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            localizations.progressOverview,
                            style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Row(
                              children: [
                                Text(
                                  localizations.seeDetails,
                                  style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.primary),
                                ),
                                const SizedBox(width: 4),
                                const SFIcon(
                                  SFIcons.sf_chevron_right,
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                            onPressed: () {
                              AppNavigation.toProgress(context);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        key: progressKey,
                        height: 260,
                        child: Stack(
                          children: [
                            Container(
                              height: 260,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              margin: const EdgeInsets.only(bottom: 8),
                              child: PageView.builder(
                                itemCount: 3,
                                physics: const BouncingScrollPhysics(),
                                padEnds: false,
                                clipBehavior: Clip.none,
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  String title;
                                  if (index == 0) {
                                    title = localizations.categoryMemory;
                                  } else if (index == 1) {
                                    title = localizations.categoryFocus;
                                  } else {
                                    title = localizations.problemSolving;
                                  }
                                  
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Transform.translate(
                                      offset: const Offset(0, -2),
                                      child: FrostedCard(
                                        borderRadius: 20,
                                        backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.primaryCardOpacity),
                                        padding: const EdgeInsets.all(16),
                                        border: Border.all(
                                          color: AppColors.getPrimaryWithOpacity(0.15),
                                          width: 0.5,
                                        ),
                                        shadows: AppColors.cardShadow,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        title,
                                                        style: AppTextStyles.withColor(
                                                          AppTextStyles.bodyMedium,
                                                          AppColors.secondaryLabel,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        index == 0 ? '+15%' : index == 1 ? '+8%' : '+12%',
                                                        style: AppTextStyles.withColor(
                                                          AppTextStyles.heading3,
                                                          AppColors.getPrimaryWithOpacity(0.7),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 2),
                                                    child: SFIcon(
                                                      index == 0 ? SFIcons.sf_brain : 
                                                      index == 1 ? SFIcons.sf_scope : 
                                                      SFIcons.sf_puzzlepiece,
                                                      fontSize: 16,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                                child: LineChart(
                                                  LineChartData(
                                                    gridData: const FlGridData(show: false),
                                                    titlesData: const FlTitlesData(show: false),
                                                    borderData: FlBorderData(show: false),
                                                    lineBarsData: [
                                                      LineChartBarData(
                                                        spots: List.generate(12, (i) {
                                                          final progress = index == 0 ? 0.65 : index == 1 ? 0.55 : 0.60;
                                                          final baseValue = progress * 100;
                                                          final wave = sin(i * 0.5) * 20;
                                                          final variance = Random().nextDouble() * 12 - 6;
                                                          return FlSpot(
                                                            i.toDouble(),
                                                            (baseValue + wave + variance).clamp(0, 100),
                                                          );
                                                        }),
                                                        isCurved: true,
                                                        curveSmoothness: 0.35,
                                                        color: AppColors.primary,
                                                        barWidth: 2.5,
                                                        isStrokeCapRound: true,
                                                        dotData: const FlDotData(show: false),
                                                        belowBarData: BarAreaData(
                                                          show: true,
                                                          gradient: LinearGradient(
                                                            begin: Alignment.topCenter,
                                                            end: Alignment.bottomCenter,
                                                            colors: [
                                                              AppColors.getPrimaryWithOpacity(0.15),
                                                              AppColors.getPrimaryWithOpacity(0.02),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Page Indicators
                            Positioned(
                              bottom: 16,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (index) {
                                  return Container(
                                    width: 6,
                                    height: 6,
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.getPrimaryWithOpacity(index == _currentPage ? 0.9 : AppColors.inactiveOpacity),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Goals Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            localizations.myGoals,
                            style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Row(
                              children: [
                                Text(
                                  localizations.editGoals,
                                  style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.primary),
                                ),
                                const SizedBox(width: 4),
                                const SFIcon(
                                  SFIcons.sf_square_and_pencil,
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                            onPressed: () {
                              _showEditGoalsModal(context);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      FrostedCard(
                        key: goalsKey,
                        borderRadius: 20,
                        backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                        border: Border.all(
                          color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
                          width: 0.5,
                        ),
                        child: Column(
                          children: [
                            _buildGoalItem(
                              localizations.categoryMemory,
                              localizations.memoryGoalTitle,
                              localizations.targetScore('85'),
                              SFIcons.sf_brain,
                              0.75,
                            ),
                            Container(
                              height: 0.5,
                              color: AppColors.getColorWithOpacity(AppColors.separator, 0.2),
                            ),
                            _buildGoalItem(
                              localizations.categoryFocus,
                              localizations.focusGoalTitle,
                              localizations.targetScore('80'),
                              SFIcons.sf_scope,
                              0.68,
                            ),
                            Container(
                              height: 0.5,
                              color: AppColors.getColorWithOpacity(AppColors.separator, 0.2),
                            ),
                            _buildGoalItem(
                              localizations.problemSolving,
                              localizations.problemSolvingGoalTitle,
                              localizations.targetScore('90'),
                              SFIcons.sf_puzzlepiece,
                              0.76,
                            ),
                          ],
                        ),
                      ),
                      // Add spacing before Community and Profile Section
                      const SizedBox(height: 32),
                      // Community and Profile Section
                      Row(
                        key: communityKey,
                        children: [
                          Expanded(
                            child: _buildQuickAccessCard(
                              context,
                              localizations.communityHub,
                              const SFIcon(
                                SFIcons.sf_person_2,
                                fontSize: 20,
                                color: Color(0xFF0D5A71),
                              ),
                              AppColors.primary,
                              () {
                                AppNavigation.toCommunity(context);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildQuickAccessCard(
                              context,
                              localizations.profileSettings,
                              const SFIcon(
                                SFIcons.sf_person_circle,
                                fontSize: 20,
                                color: Color(0xFF0D5A71),
                              ),
                              AppColors.primary,
                              () {
                                AppNavigation.toProfile(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Add bottom padding to prevent cut-off
                      SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
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

  Widget _buildGoalItem(
    String category,
    String description,
    String target,
    IconData icon,
    double progress,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SFIcon(
            icon,
            fontSize: 24,
            color: AppColors.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.secondaryText,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.getPrimaryWithOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        target,
                        style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.getPrimaryWithOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.primarySurfaceGradient(),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditGoalsModal(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            color: AppColors.getSurfaceWithOpacity(0.98),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.getColorWithOpacity(AppColors.separator, 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        localizations.cancelButton,
                        style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.primary),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      localizations.editGoals,
                      style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        localizations.saveButton,
                        style: AppTextStyles.withColor(
                          AppTextStyles.withWeight(AppTextStyles.bodyMedium, FontWeight.w600),
                          AppColors.primary,
                        ),
                      ),
                      onPressed: () {
                        // Save goals logic here
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 0.5,
                color: AppColors.getColorWithOpacity(AppColors.separator, 0.2),
              ),
              Expanded(
                child: ListView(
                  children: [
                    _buildGoalEditItem(
                      localizations.categoryMemory,
                      localizations.currentGoal(localizations.memoryGoalTitle),
                      localizations.targetScore('85'),
                      SFIcons.sf_brain,
                    ),
                    _buildGoalEditItem(
                      localizations.categoryFocus,
                      localizations.currentGoal(localizations.focusGoalTitle),
                      localizations.targetScore('80'),
                      SFIcons.sf_scope,
                    ),
                    _buildGoalEditItem(
                      localizations.problemSolving,
                      localizations.currentGoal(localizations.problemSolvingGoalTitle),
                      localizations.targetScore('90'),
                      SFIcons.sf_puzzlepiece,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalEditItem(
    String category,
    String currentGoal,
    String currentTarget,
    IconData icon,
  ) {
    final localizations = AppLocalizations.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.getColorWithOpacity(AppColors.separator, 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SFIcon(
                icon,
                fontSize: 24,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Text(
                category,
                style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CupertinoTextField(
            placeholder: localizations.enterYourGoal,
            decoration: BoxDecoration(
              color: AppColors.getSurfaceWithOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.getColorWithOpacity(AppColors.separator, 0.2),
                width: 0.5,
              ),
            ),
            style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.textPrimary),
            placeholderStyle: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.secondaryLabel),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                localizations.targetScoreLabel,
                style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.textPrimary),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 80,
                child: CupertinoTextField(
                  placeholder: '0-100',
                  keyboardType: TextInputType.number,
                  decoration: BoxDecoration(
                    color: AppColors.getSurfaceWithOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.getColorWithOpacity(AppColors.separator, 0.2),
                      width: 0.5,
                    ),
                  ),
                  style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.textPrimary),
                  placeholderStyle: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.secondaryLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard(
    BuildContext context,
    String title,
    SFIcon icon,
    Color color,
    VoidCallback onTap,
  ) {
    final localizations = AppLocalizations.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: FrostedCard(
        padding: const EdgeInsets.all(20),
        borderRadius: 24,
        backgroundColor: const Color.fromARGB(255, 18, 162, 183),
        border: Border.all(
          color: AppColors.getColorWithOpacity(AppColors.surface, 0.3),
          width: 0.5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.withColor(AppTextStyles.bodyLarge, AppColors.surface),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  localizations.explore,
                  style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.getColorWithOpacity(AppColors.surface, 0.8)),
                ),
                const SizedBox(width: 4),
                SFIcon(
                  SFIcons.sf_chevron_right,
                  fontSize: 12,
                  color: AppColors.getColorWithOpacity(AppColors.surface, 0.8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}