import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'dart:math' show pi, sin, Random;
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:fl_chart/fl_chart.dart';
import 'progress_screen.dart';
import 'profile_screen.dart';
import 'community_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class MyHubScreen extends StatefulWidget {
  const MyHubScreen({
    super.key,
    required this.tabController,
  });

  final CupertinoTabController tabController;

  @override
  State<MyHubScreen> createState() => _MyHubScreenState();
}

class _MyHubScreenState extends State<MyHubScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 1.0,
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
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
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                  'My Hub',
                  style: AppTextStyles.withColor(AppTextStyles.heading1, AppColors.textPrimary),
                ),
                middle: Text(
                  'My Hub',
                  style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Score Overview Section
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          margin: const EdgeInsets.only(bottom: 24),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Container(
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
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'Overall Score',
                                            style: AppTextStyles.secondaryText,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '73',
                                                style: AppTextStyles.withColor(
                                                  AppTextStyles.heading1,
                                                  AppColors.primary,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8),
                                                child: Text(
                                                  '/100',
                                                  style: AppTextStyles.withColor(
                                                    AppTextStyles.heading3,
                                                    AppColors.getPrimaryWithOpacity(0.7),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _buildCategoryScore(
                                            'Memory',
                                            75,
                                            SFIcons.sf_brain,
                                            AppColors.primary,
                                          ),
                                          Container(
                                            width: 0.5,
                                            height: 40,
                                            color: AppColors.separator,
                                          ),
                                          _buildCategoryScore(
                                            'Focus',
                                            68,
                                            SFIcons.sf_scope,
                                            AppColors.primary,
                                          ),
                                          Container(
                                            width: 0.5,
                                            height: 40,
                                            color: AppColors.separator,
                                          ),
                                          _buildCategoryScore(
                                            'Problem',
                                            76,
                                            SFIcons.sf_puzzlepiece,
                                            AppColors.primary,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Goals Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Goals',
                            style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Row(
                              children: [
                                Text(
                                  'Edit Goals',
                                  style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.primary),
                                ),
                                const SizedBox(width: 4),
                                SFIcon(
                                  SFIcons.sf_square_and_pencil,
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                            onPressed: () {
                              // Show edit goals modal
                              _showEditGoalsModal(context);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
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
                              children: [
                                _buildGoalItem(
                                  'Memory',
                                  'Improve short-term memory by 20%',
                                  'Target Score: 85',
                                  SFIcons.sf_brain,
                                  0.75,
                                ),
                                Container(
                                  height: 0.5,
                                  color: AppColors.separator.withOpacity(0.2),
                                ),
                                _buildGoalItem(
                                  'Focus',
                                  'Maintain focus for longer periods',
                                  'Target Score: 80',
                                  SFIcons.sf_scope,
                                  0.68,
                                ),
                                Container(
                                  height: 0.5,
                                  color: AppColors.separator.withOpacity(0.2),
                                ),
                                _buildGoalItem(
                                  'Problem Solving',
                                  'Master complex pattern recognition',
                                  'Target Score: 90',
                                  SFIcons.sf_puzzlepiece,
                                  0.76,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Progress Overview Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress Overview',
                            style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Row(
                              children: [
                                Text(
                                  'See Details',
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
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute(
                                  builder: (context) => ProgressScreen(
                                    tabController: widget.tabController,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 260,
                        child: Stack(
                          children: [
                            PageView.builder(
                              itemCount: 3,
                              physics: const BouncingScrollPhysics(),
                              padEnds: false,
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                      child: Container(
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
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.getSurfaceWithOpacity(0.04),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
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
                                                        index == 0 ? 'Memory' : index == 1 ? 'Focus' : 'Problem Solving',
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
                                                    gridData: FlGridData(show: false),
                                                    titlesData: FlTitlesData(show: false),
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
                                                        dotData: FlDotData(show: false),
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
                                  ),
                                );
                              },
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
                      // Community Card
                      _buildHubCard(
                        context,
                        'Community',
                        'Connect with others on similar journeys',
                        SFIcons.sf_person_2,
                        AppColors.primary,
                        () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (context) => const CommunityScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Profile Card
                      _buildHubCard(
                        context,
                        'Profile',
                        'Manage your personal settings and data',
                        SFIcons.sf_person_circle,
                        AppColors.primary,
                        () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (context) => ProfileScreen(
                                tabController: widget.tabController,
                              ),
                            ),
                          );
                        },
                      ),
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

  Widget _buildHubCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
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
                const SizedBox(width: 12),
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

  Widget _buildCategoryScore(
    String label,
    int score,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        SFIcon(
          icon,
          fontSize: 20,
          color: AppColors.primary,
        ),
        const SizedBox(height: 8),
        Text(
          score.toString(),
          style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.primary),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.secondaryText,
        ),
      ],
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
                  color: AppColors.separator.withOpacity(0.3),
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
                        'Cancel',
                        style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.primary),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Edit Goals',
                      style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        'Save',
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
                color: AppColors.separator.withOpacity(0.2),
              ),
              Expanded(
                child: ListView(
                  children: [
                    _buildGoalEditItem(
                      'Memory',
                      'Current Goal: Improve short-term memory by 20%',
                      'Target Score: 85',
                      SFIcons.sf_brain,
                    ),
                    _buildGoalEditItem(
                      'Focus',
                      'Current Goal: Maintain focus for longer periods',
                      'Target Score: 80',
                      SFIcons.sf_scope,
                    ),
                    _buildGoalEditItem(
                      'Problem Solving',
                      'Current Goal: Master complex pattern recognition',
                      'Target Score: 90',
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.separator.withOpacity(0.2),
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
            placeholder: 'Enter your goal',
            decoration: BoxDecoration(
              color: AppColors.getSurfaceWithOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.separator.withOpacity(0.2),
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
                'Target Score:',
                style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.textPrimary),
              ),
              const SizedBox(width: 12),
              Container(
                width: 80,
                child: CupertinoTextField(
                  placeholder: '0-100',
                  keyboardType: TextInputType.number,
                  decoration: BoxDecoration(
                    color: AppColors.getSurfaceWithOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.separator.withOpacity(0.2),
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
}