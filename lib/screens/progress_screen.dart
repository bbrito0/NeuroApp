import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'dart:math' show pi, sin, Random;
import 'package:fl_chart/fl_chart.dart';

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
    // Generate a value that's somewhat related to the previous value
    // This creates more realistic-looking data with more variation
    final change = (_random.nextDouble() * 30) - 15; // -15 to +15 for more variation
    return (previousValue + change).clamp(20, 100); // Keep between 20 and 100 for better visibility
  }

  static ProgressDataSet generateDummyData({
    required String category,
    required String timeRange,
    DateTime? startDate,
  }) {
    startDate ??= DateTime.now();
    final points = <ProgressDataPoint>[];
    double previousValue = 60.0; // Start from a middle-high point
    
    // Determine number of points based on time range
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

    // Generate data points
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

    // Calculate min and max values with padding
    final values = points.map((p) => p.value).toList();
    final maxValue = values.reduce((max, value) => value > max ? value : max);
    final minValue = values.reduce((min, value) => value < min ? value : min);
    
    // Add padding to min and max for better visualization
    final valueRange = maxValue - minValue;
    final paddedMin = (minValue - valueRange * 0.1).clamp(0.0, 100.0);
    final paddedMax = (maxValue + valueRange * 0.1).clamp(0.0, 100.0);

    return ProgressDataSet(
      points: points.reversed.toList(), // Reverse to get chronological order
      maxValue: paddedMax,
      minValue: paddedMin,
      timeRange: timeRange,
      category: category,
    );
  }
}

class WavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  WavePainter({
    required this.animation,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // Darker gradient background
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFFE8E8EA),  // Darker top color
        const Color(0xFFE2E2E4),  // Darker bottom color
      ],
    );
    
    final backgroundPaint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, backgroundPaint);

    final wavePaint = Paint()
      ..color = const Color(0xFFD8D8DA).withOpacity(0.45)
      ..style = PaintingStyle.fill;

    final path = Path();
    final path2 = Path();
    final path3 = Path();

    // First wave (most visible)
    for (var i = 0; i < size.width; i++) {
      final x = i.toDouble();
      final dx = (x / size.width);
      final sin1 = sin((dx * 2 * pi) + (animation.value * 2 * pi)); // Continuous wave
      final y = sin1 * 25 + size.height * 0.5; // Reduced amplitude
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Second wave (medium visibility)
    wavePaint.color = const Color(0xFFD0D0D2).withOpacity(0.35);
    for (var i = 0; i < size.width; i++) {
      final x = i.toDouble();
      final dx = (x / size.width);
      final sin2 = sin((dx * 2 * pi) + (animation.value * 2 * pi) + pi / 4); // Phase shifted
      final y = sin2 * 20 + size.height * 0.6; // Slightly offset
      if (i == 0) {
        path2.moveTo(x, y);
      } else {
        path2.lineTo(x, y);
      }
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    // Third wave (subtle)
    wavePaint.color = const Color(0xFFC8C8CA).withOpacity(0.25);
    for (var i = 0; i < size.width; i++) {
      final x = i.toDouble();
      final dx = (x / size.width);
      final sin3 = sin((dx * 2 * pi) + (animation.value * 2 * pi) - pi / 4); // Different phase
      final y = sin3 * 8 + size.height * 0.8; // Even more offset, smaller amplitude
      if (i == 0) {
        path3.moveTo(x, y);
      } else {
        path3.lineTo(x, y);
      }
    }
    path3.lineTo(size.width, size.height);
    path3.lineTo(0, size.height);
    path3.close();

    canvas.drawPath(path, wavePaint);
    canvas.drawPath(path2, wavePaint);
    canvas.drawPath(path3, wavePaint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
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

class _ProgressScreenState extends State<ProgressScreen> with TickerProviderStateMixin {
  late final AnimationController _waveController;
  String _selectedCategory = 'Memory';
  String _selectedTimeRange = 'Week';
  late ProgressDataSet _currentData;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // Increased duration for smoother movement
    )..repeat();

    // Initialize data
    _currentData = ProgressDataGenerator.generateDummyData(
      category: _selectedCategory,
      timeRange: _selectedTimeRange,
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
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

  LineChartData _createChartData(Color primaryColor) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: (_currentData.maxValue - _currentData.minValue) / 4,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: primaryColor.withOpacity(0.1),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: primaryColor.withOpacity(0.1),
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
                    style: TextStyle(
                      color: primaryColor.withOpacity(0.5),
                      fontSize: 10,
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
              style: TextStyle(
                  color: primaryColor.withOpacity(0.5),
                  fontSize: 10,
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
            colors: [primaryColor, primaryColor],
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
                primaryColor.withOpacity(0.2),
                primaryColor.withOpacity(0.0),
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
            color: primaryColor.withOpacity(0.1),
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
                TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: '\nScore',
                    style: TextStyle(
                      color: primaryColor.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
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
    final primaryColor = const Color(0xFF30B0C7);
    
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFE8E8EA).withOpacity(0.92),
      child: Stack(
        children: [
          // Wave Background
          Positioned.fill(
            child: CustomPaint(
              painter: WavePainter(
                animation: _waveController,
                color: const Color(0xFFE5E5E7),
              ),
            ),
          ),
          
          // Main Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: const Text(
                  'Progress',
                  style: TextStyle(
                    fontFamily: '.SF Pro Text',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.41,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                middle: const Text(
                  'Progress',
                  style: TextStyle(
                    fontFamily: '.SF Pro Text',
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.41,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                alwaysShowMiddle: false,
                backgroundColor: const Color(0xFFE8E8EA).withOpacity(1.0),
                border: null,
                stretch: false,
                automaticallyImplyLeading: false,
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => widget.tabController.index = 0,
                  child: const Icon(
                    CupertinoIcons.back,
                    color: Color(0xFF30B0C7),
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
                      ClipRRect(
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
                                  CupertinoColors.systemBackground.withOpacity(0.35),
                                  CupertinoColors.secondarySystemBackground.withOpacity(0.35),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.08),
                                width: 0.5,
                              ),
        boxShadow: [
          BoxShadow(
                                  color: CupertinoColors.systemFill.withOpacity(0.04),
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
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            primaryColor.withOpacity(0.2),
                                            primaryColor.withOpacity(0.1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                  children: [
                    Icon(
                                            CupertinoIcons.sparkles,
                                            color: primaryColor,
                      size: 14,
                    ),
                                          const SizedBox(width: 4),
                    Text(
                                            'AI Insight',
                      style: TextStyle(
                                              fontFamily: '.SF Pro Text',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Great progress in memory exercises!',
                                  style: TextStyle(
                                    fontFamily: '.SF Pro Text',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.41,
                                    color: CupertinoColors.label,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your consistent practice is showing results. Focus on pattern recognition exercises to maximize improvement.',
                                  style: TextStyle(
                                    fontFamily: '.SF Pro Text',
                                    fontSize: 15,
                                    letterSpacing: -0.24,
                                    color: CupertinoColors.secondaryLabel.withOpacity(0.9),
                                    height: 1.3,
                                  ),
          ),
        ],
      ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      
                      // Graph Card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            height: 340,
                            padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  CupertinoColors.systemBackground.withOpacity(0.35),
                                  CupertinoColors.systemBackground.withOpacity(0.35),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: CupertinoColors.systemGrey5.withOpacity(0.4),
                                width: 0.5,
                              ),
        boxShadow: [
          BoxShadow(
                                  color: CupertinoColors.black.withOpacity(0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
          ),
        ],
      ),
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
                                          style: const TextStyle(
                                            fontFamily: '.SF Pro Text',
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.35,
                                            color: CupertinoColors.label,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '+15% This Week',
            style: TextStyle(
                                            fontFamily: '.SF Pro Text',
                                            fontSize: 15,
                                            color: primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 1),
                                          child: GestureDetector(
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
                                                        // TODO: Implement PDF export
                                                      },
                                                      child: const Text('Save as PDF'),
                                                    ),
                                                    CupertinoActionSheetAction(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        // TODO: Implement email sharing
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
                                            child: Icon(
                                              CupertinoIcons.square_arrow_up,
                                              color: primaryColor,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: GestureDetector(
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
                                            child: Icon(
                                              CupertinoIcons.settings,
                                              color: primaryColor,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: LineChart(
                                      _createChartData(primaryColor),
                                      duration: const Duration(milliseconds: 500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Stats Grid
                      GridView.count(
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
                            CupertinoIcons.chart_bar_fill,
                            primaryColor,
                          ),
                          _buildStatCard(
                            'Best Score',
                            _currentData.maxValue.toStringAsFixed(0),
                            CupertinoIcons.star_fill,
                            primaryColor,
                          ),
                          _buildStatCard(
                            'Daily Streak',
                            '7 days',
                            CupertinoIcons.flame_fill,
                            primaryColor,
                          ),
                          _buildStatCard(
                            'Exercises',
                            '28',
                            CupertinoIcons.square_stack_3d_up_fill,
                            primaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CupertinoColors.systemBackground.withOpacity(0.35),
                CupertinoColors.systemBackground.withOpacity(0.35),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: CupertinoColors.systemGrey5.withOpacity(0.4),
              width: 0.5,
            ),
              boxShadow: [
                BoxShadow(
                color: CupertinoColors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
                ),
              ],
            ),
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
                const SizedBox(height: 10),
                      Text(
                value,
                        style: const TextStyle(
                  fontFamily: '.SF Pro Text',
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.41,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 2),
                      Text(
                title,
                        style: TextStyle(
                  fontFamily: '.SF Pro Text',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: CupertinoColors.secondaryLabel.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
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