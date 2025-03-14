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
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Premium Gradient Background with Frosted Glass Effect
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
                              'assets/images/ChronoWell_logo-25[3].png',
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
                      child: ClipRRect(
                          key: welcomeCardKey,
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
                                            'AI Coach',
                                            style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.primary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          Navigator.of(context, rootNavigator: true).push(
                                            CupertinoPageRoute(
                                              builder: (context) => ProfileScreen(
                                                tabController: widget.tabController,
                                              ),
                                            ),
                                          );
                                        },
                                        child: SFIcon(
                                          SFIcons.sf_person_circle_fill,
                                          fontSize: 28,
                                          color: AppColors.primary,
                                        ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'You\'re making great progress!',
                                  style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Yet I can see you still have not done your daily check-in. Ready to start?',
                                  style: AppTextStyles.secondaryText,
                                ),
                                const SizedBox(height: 16),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
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
                                          title: const Text('Error'),
                                          content: Text('Failed to start daily check-in: $e'),
                                          actions: [
                                            CupertinoDialogAction(
                                              child: const Text('OK'),
                                              onPressed: () => Navigator.pop(context),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.primarySurfaceGradient(startOpacity: 0.2, endOpacity: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Daily Check-in',
                                          style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.primary),
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
                                'Daily Challenges',
                                style: AppTextStyles.heading1,
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Row(
                                  children: [
                                    Text(
                                      'View All',
                                      style: AppTextStyles.actionButton,
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
                          SizedBox(
                            height: 250,
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (int page) {
                                setState(() {
                                  _currentPage = page;
                                });
                              },
                              children: [
                                _buildChallengeCard(
                                  context,
                                  'Memory Master',
                                  'Enhance your memory skills',
                                  0.65,
                                  [
                                    'Complete Memory Match Game',
                                    'Read Memory Enhancement Article',
                                    'Practice Visualization Exercise',
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
                                _buildChallengeCard(
                                  context,
                                  'Focus Champion',
                                  'Improve your concentration',
                                  0.45,
                                  [
                                    'Complete 10min Meditation',
                                    'Practice Mindful Reading',
                                    'Do a Focus Exercise',
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
                                _buildChallengeCard(
                                  context,
                                  'Problem Solver',
                                  'Boost analytical thinking',
                                  0.30,
                                  [
                                    'Complete Pattern Recognition',
                                    'Solve Daily Puzzle',
                                    'Read Logic Article',
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
                              'Cognitive\nAssessment',
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
                                    title: 'Cognitive Assessment',
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
                              'Learning\nResources',
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
                                'Latest Updates',
                                style: AppTextStyles.heading2,
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Row(
                                  children: [
                                    Text(
                                      'View All',
                                      style: AppTextStyles.actionButton,
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
                            'New Challenge Available',
                            'Pattern Recognition Master',
                            'Try our latest cognitive exercise designed to enhance your pattern recognition abilities.',
                            '2h ago',
                            AppColors.primary,
                          ),
                          const SizedBox(height: 12),
                          _buildNewsItem(
                            context,
                            'Weekly Report Ready',
                            'Performance Insights',
                            'Your personalized cognitive performance report for this week is now available.',
                            '1d ago',
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.primarySurfaceGradient(startOpacity: 0.5, endOpacity: 0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.getPrimaryWithOpacity(0.15),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.getSurfaceWithOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.withColor(AppTextStyles.bodyLarge, AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Explore',
                  style: AppTextStyles.secondaryText,
                ),
                const SizedBox(width: 4),
                SFIcon(
                  SFIcons.sf_chevron_right,
                  fontSize: 12,
                  color: AppColors.secondaryLabel,
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
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
            boxShadow: [
              BoxShadow(
                color: AppColors.getSurfaceWithOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
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
        ),
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
                    'Start $title?',
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
                    'Are you ready to begin this challenge? Make sure you have enough time to complete it without interruptions.',
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
                          'Estimated time: 10-15 min',
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
                    'Not Now',
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
                    'Start Challenge',
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
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
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                              style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.secondaryLabel),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.getPrimaryWithOpacity(0.1),
                      borderRadius: BorderRadius.circular(3),
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
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(progress * 100).toInt()}% Complete',
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
                                  style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.textPrimary),
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
          ),
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
                'Daily Reminder',
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
                'Have you taken your ChronoWell today?',
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
                    Text(
                      'Recommended time: 8:00 AM',
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
                'Skip Today',
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
                'Yes, Taken',
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
                'Important Reminder',
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
                'Taking ChronoWell daily is crucial for optimal results. Regular use helps maintain cognitive improvement and builds lasting benefits.',
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
                'I\'ll Take It Now',
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
                'Skip Anyway',
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
                            '$_currentStreak Day Streak!',
                            style: AppTextStyles.withColor(
                              AppTextStyles.withWeight(AppTextStyles.heading1, FontWeight.w500),
                              AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Keep Going! Almost hitting a new 7 day streak!',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodyMedium,
                          AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Month name
                      Text(
                        '${_getMonthName(currentMonth)} $currentYear',
                        style: AppTextStyles.withColor(
                          AppTextStyles.withWeight(AppTextStyles.heading3, FontWeight.w500),
                          AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Weekday headers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
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
                          'Close',
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

  // Helper method to get month name
  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
} 
