import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:math' show Random;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// GoRouter imports
import 'package:go_router/go_router.dart';

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
  static const double minValue = 20.0;
  static const double maxValue = 100.0;
  static const double baseValue = 60.0;
  static const double maxChange = 30.0;
  static const double paddingFactor = 0.1;

  static double _generateNextValue(double previousValue) {
    final change = (_random.nextDouble() * maxChange) - (maxChange / 2);
    return (previousValue + change).clamp(minValue, maxValue);
  }

  static ProgressDataSet generateDummyData({
    required String category,
    required String timeRange,
    DateTime? startDate,
  }) {
    startDate ??= DateTime.now();
    final points = <ProgressDataPoint>[];
    double previousValue = baseValue;
    
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
    final paddedMin = (minValue - valueRange * paddingFactor).clamp(0.0, 100.0);
    final paddedMax = (maxValue + valueRange * paddingFactor).clamp(0.0, 100.0);

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
  });

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // UI Constants
  static const double standardPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double cardBorderRadius = 20.0;
  static const double borderWidth = 0.5;
  static const double chartHeight = 340.0;
  static const double sectionSpacing = 20.0;

  static const double smallSpacing = 12.0;
  static const double tinySpacing = 4.0;
  static const double iconSize = 22.0;
  static const double smallIconSize = 20.0;
  static const double tinyIconSize = 14.0;
  static const double tagRadius = 8.0;
  static const double tagPaddingHorizontal = 8.0;
  static const double tagPaddingVertical = 4.0;
  static const double tooltipPadding = 8.0;
  static const double tooltipBorderRadius = 8.0;
  static const double tooltipBorderWidth = 0.5;
  static const double chartLineWidth = 2.0;
  static const double chartTitleReservedSize = 30.0;
  static const double chartLeftTitleReservedSize = 40.0;
  static const double pickerHeight = 216.0;
  static const double pickerItemExtent = 32.0;
  static const double pickerMagnification = 1.22;
  static const double pickerSqueeze = 1.2;
  static const double chartTopPadding = 8.0;
  static const Duration chartAnimationDuration = Duration(milliseconds: 500);
  
  // Chart Constants
  static const List<String> categoryOptions = ['Memory', 'Focus', 'Problem'];
  static const List<String> timeRangeOptions = ['Week', 'Month', 'Year'];
  
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
            strokeWidth: borderWidth,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
            strokeWidth: borderWidth,
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
            reservedSize: chartTitleReservedSize,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < _currentData.points.length) {
                final date = _currentData.points[value.toInt()].timestamp;
                return Padding(
                  padding: const EdgeInsets.only(top: chartTopPadding),
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
            reservedSize: chartLeftTitleReservedSize,
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
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primary],
          ),
          barWidth: chartLineWidth,
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
          tooltipPadding: const EdgeInsets.all(tooltipPadding),
          tooltipBorder: BorderSide(
            color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
            width: tooltipBorderWidth,
          ),
          tooltipMargin: 0,
          tooltipRoundedRadius: tooltipBorderRadius,
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
    final localizations = AppLocalizations.of(context);
    
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
                  onPressed: () => context.pop(),
                  child: const Icon(
                    CupertinoIcons.back,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: standardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: standardPadding),
                      
                      // AI Progress Comment Card
                      SizedBox(
                        width: double.infinity,
                        child: FrostedCard(
                          key: aiInsightKey,
                          borderRadius: cardBorderRadius,
                          backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                          border: Border.all(
                            color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
                            width: borderWidth,
                          ),
                          padding: const EdgeInsets.all(standardPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: tagPaddingHorizontal, 
                                  vertical: tagPaddingVertical
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.getPrimaryWithOpacity(AppColors.inactiveOpacity),
                                  borderRadius: BorderRadius.circular(tagRadius),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SFIcon(
                                      SFIcons.sf_sparkles,
                                      fontSize: tinyIconSize,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: tinySpacing),
                                    Text(
                                      'AI Insight',
                                      style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.primary),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: smallSpacing),
                              Text(
                                'Great progress in memory exercises!',
                                style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                              ),
                              const SizedBox(height: tinySpacing),
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
                child: SizedBox(height: sectionSpacing),
              ),
              // Graph Card with key
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: standardPadding),
                  child: SizedBox(
                    height: chartHeight,
                    child: FrostedCard(
                      key: progressChartKey,
                      borderRadius: cardBorderRadius,
                      backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                      border: Border.all(
                        color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
                        width: borderWidth,
                      ),
                      padding: const EdgeInsets.all(standardPadding),
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
                                  const SizedBox(height: tinySpacing),
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
                                    child: const SFIcon(
                                      SFIcons.sf_square_and_arrow_up,
                                      fontSize: smallIconSize,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: standardPadding),
                                  GestureDetector(
                                    onTap: () {
                                      showCupertinoModalPopup<void>(
                                        context: context,
                                        builder: (BuildContext context) => Container(
                                          height: pickerHeight,
                                          padding: const EdgeInsets.only(top: tagPaddingVertical),
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
                                                    magnification: pickerMagnification,
                                                    squeeze: pickerSqueeze,
                                                    useMagnifier: true,
                                                    itemExtent: pickerItemExtent,
                                                    scrollController: FixedExtentScrollController(
                                                      initialItem: categoryOptions.indexOf(_selectedCategory),
                                                    ),
                                                    onSelectedItemChanged: (int selectedItem) {
                                                      setState(() {
                                                        _selectedCategory = categoryOptions[selectedItem];
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
                                                    magnification: pickerMagnification,
                                                    squeeze: pickerSqueeze,
                                                    useMagnifier: true,
                                                    itemExtent: pickerItemExtent,
                                                    scrollController: FixedExtentScrollController(
                                                      initialItem: timeRangeOptions.indexOf(_selectedTimeRange),
                                                    ),
                                                    onSelectedItemChanged: (int selectedItem) {
                                                      setState(() {
                                                        _selectedTimeRange = timeRangeOptions[selectedItem];
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
                                    child: const SFIcon(
                                      SFIcons.sf_slider_horizontal_3,
                                      fontSize: smallIconSize,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: sectionSpacing),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: smallPadding),
                              child: LineChart(
                                _createChartData(),
                                duration: chartAnimationDuration,
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
                child: SizedBox(height: sectionSpacing),
              ),
              // Stats Grid with key
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: standardPadding),
                  child: GridView.count(
                    key: statsGridKey,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: smallSpacing,
                    crossAxisSpacing: smallSpacing,
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
      borderRadius: cardBorderRadius,
      backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
      border: Border.all(
        color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
        width: borderWidth,
      ),
      padding: const EdgeInsets.all(standardPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SFIcon(
            icon,
            fontSize: iconSize,
            color: AppColors.primary,
          ),
          const SizedBox(height: smallSpacing),
          Text(
            value,
            style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
          ),
          const SizedBox(height: tinySpacing),
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