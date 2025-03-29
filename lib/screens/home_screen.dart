import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:neural_app/screens/challenges_screen.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:neural_app/screens/games/memory_match_game.dart';
import 'package:neural_app/screens/games/pattern_recall_game.dart';
import 'package:neural_app/screens/meditation_screen.dart';
import 'package:neural_app/screens/ai_coach_screen.dart';
import 'package:neural_app/screens/tavus_call_screen.dart';
import '../services/tavus_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../screens/profile_screen.dart';
import '../services/tutorial_service.dart';
import '../services/theme_service.dart';
import '../widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.tabController,
  });

  final CupertinoTabController tabController;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late ScrollController _scrollController;
  int _currentPage = 0;
  final TavusService _tavusService = TavusService();
  final ThemeService _themeService = ThemeService();

  // Add GlobalKeys for tutorial targets
  final GlobalKey welcomeCardKey = GlobalKey();
  final GlobalKey dailyChallengesKey = GlobalKey();
  final GlobalKey quickActionsKey = GlobalKey();
  final GlobalKey latestUpdatesKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 1.0,
      initialPage: 0,
    );
    _scrollController = ScrollController();
    
    // Initialize completed days for the 5-day streak
    final now = DateTime.now();
    for (int i = 1; i <= 5; i++) {
      _completedDays.add(now.day - i);
    }
    
    // Initialize theme service
    _themeService.initialize();
    
    // Listen for theme changes
    _themeService.addListener(() {
      if (mounted) {
        setState(() {
          // Rebuild the entire screen when theme changes
        });
      }
    });
    
    // Show appropriate content after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (TutorialService.areTutorialsEnabled()) {
          // If in tutorial mode, show tutorial
          if (TutorialService.shouldShowTutorial(TutorialService.HOME_TUTORIAL)) {
            _showTutorial();
            TutorialService.markTutorialAsShown(TutorialService.HOME_TUTORIAL);
          }
        } else {
          // If not in tutorial mode, show reminder flow
          _showMedicationReminder();
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
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
          // Premium Gradient Background with Frosted Glass Effect
          GradientBackground(
            child: Container(),
            style: BackgroundStyle.premium,
            hasSafeArea: false,
          ),
          // Main Content
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 2));
                },
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Logo
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: SizedBox(
                          height:180,
                          width: 180,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/images/LogoWhite.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Welcome Message with Enhanced Glass Effect
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: FrostedCard(
                        key: welcomeCardKey,
                        borderRadius: 20,
                        padding: const EdgeInsets.all(20),
                        hierarchy: CardHierarchy.primary,
                        shadows: AppColors.cardShadow,
                        backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.primaryCardOpacity),
                        border: Border.all(
                          color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
                          width: 0.5,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                      gradient: AppColors.primarySurfaceGradient(startOpacity: 0.2, endOpacity: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SFIcon(
                                        SFIcons.sf_sparkles,
                                        fontSize: 14,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        AppLocalizations.of(context)!.aiCoach,
                                        style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.primary),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                // Theme toggle button
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.getSurfaceWithOpacity(0.8),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: SFIcon(
                                      AppColors.currentTheme == ThemeMode.dark 
                                          ? SFIcons.sf_sun_max_fill
                                          : SFIcons.sf_moon_fill,
                                      fontSize: 18,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _themeService.toggleTheme();
                                    });
                                  },
                                ),
                                const SizedBox(width: 12),
                                ActionButton(
                                  text: AppLocalizations.of(context)!.checkInButton,
                                  style: ActionButtonStyle.filled,
                                  backgroundColor: const Color.fromARGB(255, 18, 162, 183),
                                  textColor: AppColors.surface,
                                  isFullWidth: false,
                                  height: 36,
                                  onPressed: () async {
                                    try {
                                      // End any existing conversations first
                                      await _tavusService.endAllActiveConversations();

                                      final conversation = await _tavusService.createConversation(
                                        conversationName: 'Daily Check-in',
                                        conversationalContext: 'You are having a daily check-in video call with your AI health coach who helps you with mental wellness and cognitive training.',
                                        customGreeting: 'Hello! I\'m here for your daily check-in. How are you feeling today?',
                                      );

                                      if (!mounted) return;

                                      Navigator.of(context, rootNavigator: true).push(
                                        CupertinoPageRoute(
                                          builder: (context) => TavusCallScreen(
                                            conversationUrl: conversation.conversationUrl,
                                            conversationId: conversation.conversationId,
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      if (!mounted) return;
                                      
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (context) => CupertinoAlertDialog(
                                          title: Text(AppLocalizations.of(context)!.error),
                                          content: Text(AppLocalizations.of(context)!.failedToStartCheckIn(e.toString())),
                                          actions: [
                                            CupertinoDialogAction(
                                              child: Text(AppLocalizations.of(context)!.ok),
                                              onPressed: () => Navigator.pop(context),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              AppLocalizations.of(context)!.welcomeCardTitle,
                              style: AppTextStyles.adaptive(AppTextStyles.heading2),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(context)!.welcomeCardSubtitle,
                              style: AppTextStyles.adaptive(AppTextStyles.secondaryText, isPrimary: false),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Daily Challenges Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                          key: dailyChallengesKey,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.dailyChallenges,
                                style: AppTextStyles.adaptive(AppTextStyles.heading1),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.viewAll,
                                      style: AppTextStyles.withColor(AppTextStyles.actionButton, AppColors.primary),
                                    ),
                                    const SizedBox(width: 4),
                                    SFIcon(
                                      SFIcons.sf_chevron_right,
                                      fontSize: 14,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true).push(
                                    CupertinoPageRoute(
                                      builder: (context) => const ChallengesScreen(),
                                      title: 'Challenges',
                                      fullscreenDialog: true,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 250,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            margin: const EdgeInsets.only(bottom: 8),
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (int page) {
                                setState(() {
                                  _currentPage = page;
                                });
                              },
                              padEnds: false,
                              pageSnapping: true,
                              physics: const BouncingScrollPhysics(),
                              clipBehavior: Clip.none,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Transform.translate(
                                    offset: const Offset(0, -2),
                                    child: _buildChallengeCard(
                                      context,
                                      localizations.memoryMaster,
                                      localizations.enhanceMemorySkills,
                                      0.65,
                                      [
                                        localizations.completeMemoryMatch,
                                        localizations.readMemoryArticle,
                                        localizations.practiceVisualization,
                                      ],
                                      SFIcons.sf_brain,
                                      AppColors.primary,
                                      () {
                                        Navigator.of(context, rootNavigator: true).push(
                                          CupertinoPageRoute(
                                            builder: (context) => const MemoryMatchGame(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Transform.translate(
                                    offset: const Offset(0, -2),
                                    child: _buildChallengeCard(
                                      context,
                                      localizations.focusChampion,
                                      localizations.improveConcentration,
                                      0.45,
                                      [
                                        localizations.completeMeditation,
                                        localizations.practiceMindfulReading,
                                        localizations.doFocusExercise,
                                      ],
                                      SFIcons.sf_rays,
                                      AppColors.primary,
                                      () {
                                        Navigator.of(context, rootNavigator: true).push(
                                          CupertinoPageRoute(
                                            builder: (context) => const MeditationScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Transform.translate(
                                    offset: const Offset(0, -2),
                                    child: _buildChallengeCard(
                                      context,
                                      localizations.problemSolver,
                                      localizations.boostAnalyticalThinking,
                                      0.30,
                                      [
                                        localizations.completePatternRecognition,
                                        localizations.solveDailyPuzzle,
                                        localizations.readLogicArticle,
                                      ],
                                      SFIcons.sf_puzzlepiece,
                                      AppColors.primary,
                                      () {
                                        Navigator.of(context, rootNavigator: true).push(
                                          CupertinoPageRoute(
                                            builder: (context) => const PatternRecallGame(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                              (index) => Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentPage == index
                                      ? AppColors.primary
                                      : AppColors.getPrimaryWithOpacity(0.2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Quick Actions
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                          key: quickActionsKey,
                        children: [
                          Expanded(
                            child: _buildQuickAccessCard(
                              context,
                              localizations.cognitiveAssessment,
                              SFIcon(
                                SFIcons.sf_puzzlepiece,
                                fontSize: 20,
                                color: const Color(0xFF0D5A71),
                              ),
                              AppColors.primary,
                              () {
                                Navigator.of(context, rootNavigator: true).push(
                                  CupertinoPageRoute(
                                    builder: (context) => const ChallengesScreen(),
                                    title: 'Challenges',
                                    fullscreenDialog: true,
                                    maintainState: true,
                                    allowSnapshotting: true,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildQuickAccessCard(
                              context,
                              localizations.learningResources,
                              SFIcon(
                                SFIcons.sf_book,
                                fontSize: 20,
                                color: const Color(0xFF0D5A71),
                              ),
                              AppColors.primary,
                              () {
                                widget.tabController.index = 3;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // News and Updates
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                          key: latestUpdatesKey,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.latestUpdates,
                                style: AppTextStyles.adaptive(AppTextStyles.heading2),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.viewAll,
                                      style: AppTextStyles.withColor(AppTextStyles.actionButton, AppColors.primary),
                                    ),
                                    const SizedBox(width: 4),
                                    SFIcon(
                                      SFIcons.sf_chevron_right,
                                      fontSize: 14,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildNewsItem(
                            context,
                            localizations.newChallengeAvailable,
                            localizations.patternRecognitionMaster,
                            localizations.tryLatestExercise,
                            localizations.hoursAgo('2'),
                            AppColors.primary,
                          ),
                          const SizedBox(height: 12),
                          _buildNewsItem(
                            context,
                            localizations.weeklyReportReady,
                            localizations.performanceInsights,
                            localizations.weeklyReportDescription,
                            localizations.daysAgo('1'),
                            AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Add safe area bottom padding
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 70),
                  ],
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
    final localizations = AppLocalizations.of(context)!;
    
    return GestureDetector(
      onTap: onTap,
      child: FrostedCard(
        padding: const EdgeInsets.all(20),
        borderRadius: 24,
        backgroundColor: const Color.fromARGB(255, 18, 162, 183),
        border: Border.all(
          color: AppColors.surface.withOpacity(0.3),
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
                  style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.surface.withOpacity(0.8)),
                ),
                const SizedBox(width: 4),
                SFIcon(
                  SFIcons.sf_chevron_right,
                  fontSize: 12,
                  color: AppColors.surface.withOpacity(0.8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsItem(
    BuildContext context,
    String category,
    String title,
    String description,
    String time,
    Color accentColor,
  ) {
    return FrostedCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: AppColors.primarySurfaceGradient(startOpacity: 0.6, endOpacity: 0.6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.getPrimaryWithOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  category,
                  style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF0D5A71)),
                ),
              ),
              const Spacer(),
              Text(
                time,
                style: AppTextStyles.secondaryText,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.secondaryLabel),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(
    BuildContext context,
    String title,
    String subtitle,
    double progress,
    List<String> tasks,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final localizations = AppLocalizations.of(context)!;
    
    return GestureDetector(
      onTap: () {
        showCupertinoDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: CupertinoAlertDialog(
              title: Column(
                children: [
                  SFIcon(
                    icon,
                    color: const Color(0xFF0D5A71),
                    fontSize: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations.startChallengePrompt(title),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.withColor(
                      AppTextStyles.withWeight(AppTextStyles.heading2, FontWeight.w500),
                      AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              content: Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    localizations.challengeReadyText,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.withColor(
                      AppTextStyles.bodyMedium,
                      AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.getPrimaryWithOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SFIcon(
                          SFIcons.sf_clock,
                          color: AppColors.primary,
                          fontSize: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          localizations.estimatedTime('10-15 min'),
                          style: AppTextStyles.withColor(
                            AppTextStyles.bodySmall,
                            AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text(
                    localizations.notNow,
                    style: AppTextStyles.withColor(
                      AppTextStyles.bodyMedium,
                      AppColors.secondaryLabel,
                    ),
                  ),
                  onPressed: () => Navigator.pop(dialogContext),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    localizations.startChallenge,
                    style: AppTextStyles.withColor(
                      AppTextStyles.bodyMedium,
                      AppColors.primary,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    onTap();
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: FrostedCard(
        borderRadius: 20,
        backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.primaryCardOpacity),
        padding: const EdgeInsets.all(20),
        border: Border.all(
          color: AppColors.getPrimaryWithOpacity(0.15),
          width: 0.5,
        ),
        hierarchy: CardHierarchy.primary,
        shadows: AppColors.cardShadow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SFIcon(
                  icon,
                  fontSize: 20,
                  color: const Color(0xFF0D5A71),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.adaptive(AppTextStyles.heading3),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTextStyles.adaptive(AppTextStyles.bodyMedium, isPrimary: false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 8, // Slightly taller
              decoration: BoxDecoration(
                color: AppColors.getPrimaryWithOpacity(0.1),
                borderRadius: BorderRadius.circular(4), // Slightly more rounded
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.getPrimaryWithOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4), // Match outer radius
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              localizations.percentComplete((progress * 100).toInt().toString()),
              style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.primary),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: tasks.map((task) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: SFIcon(
                            SFIcons.sf_checkmark_circle_fill,
                            fontSize: 14,
                            color: AppColors.getPrimaryWithOpacity(0.5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            task,
                            style: AppTextStyles.adaptive(AppTextStyles.bodyMedium),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTutorial() {
    TutorialService.createHomeScreenTutorial(
      context,
      [welcomeCardKey, dailyChallengesKey, quickActionsKey, latestUpdatesKey],
      _scrollController,
    ).show(context: context);
  }

  // Streak management
  int _currentStreak = 5; // Initialize with 5-day streak
  final Set<int> _completedDays = {};

  void _updateStreak() {
    final today = DateTime.now().day;
    if (!_completedDays.contains(today)) {
      _completedDays.add(today);
      // Check if yesterday was completed to continue streak
      if (_completedDays.contains(today - 1) || _currentStreak == 0) {
        _currentStreak++;
      }
    }
  }

  void _resetStreak() {
    setState(() {
      _currentStreak = 0;
    });
  }

  void _showMedicationReminder() {
    if (!mounted) return;
    final localizations = AppLocalizations.of(context)!;
    
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: CupertinoAlertDialog(
          title: Column(
            children: [
              SFIcon(
                SFIcons.sf_pills,
                color: AppColors.primary,
                fontSize: 24,
              ),
              const SizedBox(height: 8),
              Text(
                localizations.dailyReminder,
                textAlign: TextAlign.center,
                style: AppTextStyles.withColor(
                  AppTextStyles.withWeight(AppTextStyles.heading2, FontWeight.w500),
                  AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: Column(
            children: [
              const SizedBox(height: 12),
              Text(
                localizations.takenChronowell,
                textAlign: TextAlign.center,
                style: AppTextStyles.withColor(
                  AppTextStyles.bodyMedium,
                  AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.getPrimaryWithOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SFIcon(
                      SFIcons.sf_clock,
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        localizations.recommendedTime('8:00 AM'),
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodySmall,
                          AppColors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                localizations.skipToday,
                style: AppTextStyles.withColor(
                  AppTextStyles.bodyMedium,
                  AppColors.secondaryLabel,
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                _showSkipWarning();
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                localizations.yesTaken,
                style: AppTextStyles.withColor(
                  AppTextStyles.bodyMedium,
                  AppColors.primary,
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                if (mounted) {
                  _showStreakCalendar();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSkipWarning() {
    if (!mounted) return;
    final localizations = AppLocalizations.of(context)!;
    
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: CupertinoAlertDialog(
          title: Column(
            children: [
              SFIcon(
                SFIcons.sf_exclamationmark_circle,
                color: const Color(0xFFFF9500),
                fontSize: 24,
              ),
              const SizedBox(height: 8),
              Text(
                localizations.importantReminder,
                textAlign: TextAlign.center,
                style: AppTextStyles.withColor(
                  AppTextStyles.withWeight(AppTextStyles.heading2, FontWeight.w600),
                  AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: Column(
            children: [
              const SizedBox(height: 12),
              Text(
                localizations.takeChronowellDaily,
                textAlign: TextAlign.center,
                style: AppTextStyles.withColor(
                  AppTextStyles.bodyMedium,
                  AppColors.textPrimary,
                ),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                localizations.illTakeItNow,
                style: AppTextStyles.withColor(
                  AppTextStyles.bodyMedium,
                  AppColors.primary,
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                _updateStreak();
                _showStreakCalendar();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                localizations.skipAnyway,
                style: AppTextStyles.withColor(
                  AppTextStyles.bodyMedium,
                  AppColors.secondaryLabel,
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                _resetStreak();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showStreakCalendar() {
    if (!mounted) return;
    final localizations = AppLocalizations.of(context)!;
    
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;
    final daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;
    final firstDayOfMonth = DateTime(currentYear, currentMonth, 1);
    final firstWeekday = firstDayOfMonth.weekday;
    
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.2,
        left: 16,
        right: 16,
        child: SafeArea(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.getSurfaceWithOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.getSurfaceWithOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SFIcon(
                            SFIcons.sf_flame_fill,
                            color: const Color(0xFFFF9500),
                            fontSize: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            localizations.dayStreakText(_currentStreak.toString()),
                            style: AppTextStyles.withColor(
                              AppTextStyles.withWeight(AppTextStyles.heading1, FontWeight.w500),
                              AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        localizations.keepGoingStreak,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodyMedium,
                          AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Month name
                      Text(
                        '${_getLocalizedMonthName(currentMonth, localizations)} $currentYear',
                        style: AppTextStyles.withColor(
                          AppTextStyles.withWeight(AppTextStyles.heading3, FontWeight.w500),
                          AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Weekday headers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          localizations.monday,
                          localizations.tuesday,
                          localizations.wednesday,
                          localizations.thursday,
                          localizations.friday,
                          localizations.saturday,
                          localizations.sunday
                        ]
                          .map((day) => SizedBox(
                                width: 32,
                                child: Text(
                                  day,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.secondaryText,
                                ),
                              ))
                          .toList(),
                      ),
                      const SizedBox(height: 8),
                      // Calendar grid
                      ...List.generate(
                        (daysInMonth + firstWeekday - 1 + 6) ~/ 7,
                        (weekIndex) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(
                            7,
                            (dayIndex) {
                              final day = weekIndex * 7 + dayIndex - (firstWeekday - 2);
                              if (day < 1 || day > daysInMonth) {
                                return const SizedBox(width: 32);
                              }
                              final isToday = day == now.day;
                              final isPast = day < now.day;
                              final isCompleted = _completedDays.contains(day);
                              
                              return Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isCompleted
                                      ? AppColors.success.withOpacity(0.2)
                                      : isToday
                                          ? AppColors.getPrimaryWithOpacity(0.2)
                                          : null,
                                  borderRadius: BorderRadius.circular(16),
                                  border: isToday
                                      ? Border.all(
                                          color: AppColors.primary,
                                          width: 2,
                                        )
                                      : null,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        day.toString(),
                                        style: AppTextStyles.withColor(
                                          AppTextStyles.withWeight(
                                            AppTextStyles.bodyMedium,
                                            isToday ? FontWeight.w600 : FontWeight.w400,
                                          ),
                                          isCompleted
                                              ? AppColors.success
                                              : isToday
                                                  ? AppColors.primary
                                                  : isPast
                                                      ? AppColors.secondaryLabel
                                                      : AppColors.textPrimary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isCompleted)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: SizedBox(
                                          width: 10,
                                          height: 10,
                                          child: SFIcon(
                                            SFIcons.sf_checkmark,
                                            fontSize: 10,
                                            color: AppColors.success,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Text(
                          localizations.close,
                          style: AppTextStyles.actionButton,
                        ),
                        onPressed: () {
                          overlayEntry.remove();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }

  // Helper method to get localized month name
  String _getLocalizedMonthName(int month, AppLocalizations localizations) {
    switch (month) {
      case 1: return localizations.january;
      case 2: return localizations.february;
      case 3: return localizations.march;
      case 4: return localizations.april;
      case 5: return localizations.may;
      case 6: return localizations.june;
      case 7: return localizations.july;
      case 8: return localizations.august;
      case 9: return localizations.september;
      case 10: return localizations.october;
      case 11: return localizations.november;
      case 12: return localizations.december;
      default: return '';
    }
  }
} 
