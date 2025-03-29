import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'dart:math' show Random;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../services/tutorial_service.dart';
import '../widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Data Models
class ProgressDataPoint {
  final DateTime timestamp;
  final double value;
  final double? previousValue;

  ProgressDataPoint({
    required this.timestamp,
    required this.value,
    this.previousValue,
  });
}

class ProgressDataSet {
  final List<ProgressDataPoint> points;
  final double maxValue;
  final double minValue;
  final String timeRange;
  final String category;

  ProgressDataSet({
    required this.points,
    required this.maxValue,
    required this.minValue,
    required this.timeRange,
    required this.category,
  });

  double get valueRange => maxValue - minValue;
}

// Dummy Data Generator
class ProgressDataGenerator {
  static final Random _random = Random();

  static double _generateNextValue(double previousValue) {
    final change = (_random.nextDouble() * 30) - 15;
    return (previousValue + change).clamp(20, 100);
  }

  static ProgressDataSet generateDummyData({
    required String category,
    required String timeRange,
    DateTime? startDate,
  }) {
    startDate ??= DateTime.now();
    final points = <ProgressDataPoint>[];
    double previousValue = 60.0;
    
    int numberOfPoints;
    Duration interval;
    
    switch (timeRange) {
      case 'Week':
        numberOfPoints = 7;
        interval = const Duration(days: 1);
        break;
      case 'Month':
        numberOfPoints = 30;
        interval = const Duration(days: 1);
        break;
      case 'Year':
        numberOfPoints = 12;
        interval = const Duration(days: 30);
        break;
      default:
        numberOfPoints = 7;
        interval = const Duration(days: 1);
    }

    DateTime currentDate = startDate;
    for (int i = 0; i < numberOfPoints; i++) {
      final value = _generateNextValue(previousValue);
      points.add(ProgressDataPoint(
        timestamp: currentDate,
        value: value,
        previousValue: previousValue,
      ));
      previousValue = value;
      currentDate = currentDate.subtract(interval);
    }

    final values = points.map((p) => p.value).toList();
    final maxValue = values.reduce((max, value) => value > max ? value : max);
    final minValue = values.reduce((min, value) => value < min ? value : min);
    
    final valueRange = maxValue - minValue;
    final paddedMin = (minValue - valueRange * 0.1).clamp(0.0, 100.0);
    final paddedMax = (maxValue + valueRange * 0.1).clamp(0.0, 100.0);

    return ProgressDataSet(
      points: points.reversed.toList(),
      maxValue: paddedMax,
      minValue: paddedMin,
      timeRange: timeRange,
      category: category,
    );
  }
}

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({
    super.key,
    required this.tabController,
  });

  final CupertinoTabController tabController;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String _selectedCategory = 'Memory';
  String _selectedTimeRange = 'Week';
  late ProgressDataSet _currentData;
  late ScrollController _scrollController;

  // Add GlobalKeys for tutorial targets
  final GlobalKey aiInsightKey = GlobalKey();
  final GlobalKey progressChartKey = GlobalKey();
  final GlobalKey statsGridKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _currentData = ProgressDataGenerator.generateDummyData(
      category: _selectedCategory,
      timeRange: _selectedTimeRange,
    );
    _scrollController = ScrollController();

    // Show tutorial when the screen is first built if enabled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (TutorialService.shouldShowTutorial(TutorialService.PROGRESS_TUTORIAL)) {
        _showTutorial();
        TutorialService.markTutorialAsShown(TutorialService.PROGRESS_TUTORIAL);
      }
    });
  }

  void _showTutorial() {
    TutorialService.createProgressTutorial(
      context,
      [aiInsightKey, progressChartKey, statsGridKey],
      _scrollController,
    ).show(context: context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateData() {
    setState(() {
      _currentData = ProgressDataGenerator.generateDummyData(
        category: _selectedCategory,
        timeRange: _selectedTimeRange,
      );
    });
  }

  LineChartData _createChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: (_currentData.maxValue - _currentData.minValue) / 4,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < _currentData.points.length) {
                final date = _currentData.points[value.toInt()].timestamp;
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _formatDate(date, _currentData.timeRange),
                    style: AppTextStyles.withColor(
                      AppTextStyles.bodySmall,
                      AppColors.getPrimaryWithOpacity(AppColors.inactiveOpacity),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: (_currentData.maxValue - _currentData.minValue) / 4,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: AppTextStyles.withColor(
                  AppTextStyles.bodySmall,
                  AppColors.getPrimaryWithOpacity(AppColors.inactiveOpacity),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (_currentData.points.length - 1).toDouble(),
      minY: _currentData.minValue,
      maxY: _currentData.maxValue,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(_currentData.points.length, (index) {
            return FlSpot(
              index.toDouble(),
              _currentData.points[index].value,
            );
          }),
          isCurved: true,
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary],
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.getPrimaryWithOpacity(0.2),
                AppColors.getPrimaryWithOpacity(0.0),
              ],
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          tooltipPadding: const EdgeInsets.all(8),
          tooltipBorder: BorderSide(
            color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
            width: 0.5,
          ),
          tooltipMargin: 0,
          tooltipRoundedRadius: 8,
          tooltipHorizontalAlignment: FLHorizontalAlignment.center,
          tooltipHorizontalOffset: 0,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final value = touchedSpot.y;
              return LineTooltipItem(
                value.toStringAsFixed(1),
                AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.primary),
                children: [
                  TextSpan(
                    text: '\nScore',
                    style: AppTextStyles.withColor(
                      AppTextStyles.bodySmall,
                      AppColors.getPrimaryWithOpacity(AppColors.inactiveOpacity),
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {},
        handleBuiltInTouches: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          GradientBackground(
            customGradient: AppColors.primaryGradient,
            hasSafeArea: false,
            child: Container(),
          ),
          CustomScrollView(
            controller: _scrollController,
            primary: false,
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                  localizations.progress,
                  style: AppTextStyles.withColor(AppTextStyles.heading1, AppColors.textPrimary),
                ),
                middle: Text(
                  localizations.progress,
                  style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                ),
                alwaysShowMiddle: false,
                backgroundColor: Colors.transparent,
                border: null,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      
                      // AI Progress Comment Card
                      SizedBox(
                        width: double.infinity,
                        child: FrostedCard(
                          key: aiInsightKey,
                          borderRadius: 20,
                          backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                          border: Border.all(
                            color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
                            width: 0.5,
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.getPrimaryWithOpacity(AppColors.inactiveOpacity),
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
                                      'AI Insight',
                                      style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.primary),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Great progress in memory exercises!',
                                style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your consistent practice is showing results. Focus on pattern recognition exercises to maximize improvement.',
                                style: AppTextStyles.secondaryText,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
              // Graph Card with key
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    height: 340,
                    child: FrostedCard(
                      key: progressChartKey,
                      borderRadius: 20,
                      backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                      border: Border.all(
                        color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
                        width: 0.5,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedCategory,
                                    style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '+15% This Week',
                                    style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.primary),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showCupertinoModalPopup<void>(
                                        context: context,
                                        builder: (BuildContext context) => CupertinoActionSheet(
                                          title: const Text('Export Progress'),
                                          message: const Text('Choose how you want to share your progress data'),
                                          actions: <CupertinoActionSheetAction>[
                                            CupertinoActionSheetAction(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Save as PDF'),
                                            ),
                                            CupertinoActionSheetAction(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Share via Email'),
                                            ),
                                          ],
                                          cancelButton: CupertinoActionSheetAction(
                                            isDestructiveAction: true,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                        ),
                                      );
                                    },
                                    child: SFIcon(
                                      SFIcons.sf_square_and_arrow_up,
                                      fontSize: 20,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: () {
                                      showCupertinoModalPopup<void>(
                                        context: context,
                                        builder: (BuildContext context) => Container(
                                          height: 216,
                                          padding: const EdgeInsets.only(top: 6.0),
                                          margin: EdgeInsets.only(
                                            bottom: MediaQuery.of(context).viewInsets.bottom,
                                          ),
                                          color: CupertinoColors.systemBackground,
                                          child: SafeArea(
                                            top: false,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: CupertinoPicker(
                                                    magnification: 1.22,
                                                    squeeze: 1.2,
                                                    useMagnifier: true,
                                                    itemExtent: 32.0,
                                                    scrollController: FixedExtentScrollController(
                                                      initialItem: ['Memory', 'Focus', 'Problem']
                                                          .indexOf(_selectedCategory),
                                                    ),
                                                    onSelectedItemChanged: (int selectedItem) {
                                                      setState(() {
                                                        _selectedCategory = ['Memory', 'Focus', 'Problem'][selectedItem];
                                                        _updateData();
                                                      });
                                                    },
                                                    children: const [
                                                      Text('Memory'),
                                                      Text('Focus'),
                                                      Text('Problem'),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: CupertinoPicker(
                                                    magnification: 1.22,
                                                    squeeze: 1.2,
                                                    useMagnifier: true,
                                                    itemExtent: 32.0,
                                                    scrollController: FixedExtentScrollController(
                                                      initialItem: ['Week', 'Month', 'Year']
                                                          .indexOf(_selectedTimeRange),
                                                    ),
                                                    onSelectedItemChanged: (int selectedItem) {
                                                      setState(() {
                                                        _selectedTimeRange = ['Week', 'Month', 'Year'][selectedItem];
                                                        _updateData();
                                                      });
                                                    },
                                                    children: const [
                                                      Text('Week'),
                                                      Text('Month'),
                                                      Text('Year'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: SFIcon(
                                      SFIcons.sf_slider_horizontal_3,
                                      fontSize: 20,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: LineChart(
                                _createChartData(),
                                duration: const Duration(milliseconds: 500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
              // Stats Grid with key
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.count(
                    key: statsGridKey,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.25,
                    children: [
                      _buildStatCard(
                        'Current Score',
                        _currentData.points.last.value.toStringAsFixed(0),
                        SFIcons.sf_chart_bar,
                      ),
                      _buildStatCard(
                        'Best Score',
                        _currentData.maxValue.toStringAsFixed(0),
                        SFIcons.sf_star,
                      ),
                      _buildStatCard(
                        'Daily Streak',
                        '7 days',
                        SFIcons.sf_flame,
                      ),
                      _buildStatCard(
                        'Exercises',
                        '28',
                        SFIcons.sf_square_stack_3d_up,
                      ),
                    ],
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(bottom: 32),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return FrostedCard(
      borderRadius: 20,
      backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
      border: Border.all(
        color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
        width: 0.5,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SFIcon(
            icon,
            fontSize: 22,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.secondaryText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date, String timeRange) {
    switch (timeRange) {
      case 'Week':
        return '${date.day}/${date.month}';
      case 'Month':
        return '${date.day}';
      case 'Year':
        return '${date.month}/${date.year.toString().substring(2)}';
      default:
        return '';
    }
  }
} 