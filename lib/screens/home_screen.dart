import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'dart:math' show pi, sin, pow, Random;
import 'package:neural_app/screens/resources_screen.dart';
import 'package:neural_app/screens/challenges_screen.dart';
import 'package:neural_app/screens/progress_screen.dart';
import 'package:fl_chart/fl_chart.dart';

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
  late AnimationController _controller;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8), // Slow animation cycle
      vsync: this,
    )..repeat();
    
    _pageController = PageController(
      viewportFraction: 1.0,
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF30B0C7);
    
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFE8E8EA),
      child: Stack(
        children: [
          // Animated Wave Background with reduced amplitude
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(
                  animation: _controller,
                  color: const Color(0xFFE5E5E7),
                ),
                child: Container(),
              );
            },
          ),
          // Main Content
          CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: const Text(
                  'NeuroApp',
                  style: TextStyle(
                    fontFamily: '.SF Pro Text',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.41,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                middle: const Text(
                  'NeuroApp',
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
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor.withOpacity(0.2),
                        primaryColor.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.bell_fill,
                    color: primaryColor,
                    size: 18,
                  ),
                ),
              ),
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 2));
                },
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    // Welcome Message with Enhanced Glass Effect
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                  CupertinoColors.systemBackground.withOpacity(0.5),
                                  CupertinoColors.secondarySystemBackground.withOpacity(0.5),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.1),
                                width: 0.5,
                              ),
                      boxShadow: [
                        BoxShadow(
                                  color: CupertinoColors.systemFill.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                                            'Welcome back,',
                          style: TextStyle(
                                              fontFamily: '.SF Pro Text',
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: -0.41,
                                              height: 1.2,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                        Text(
                                            'John',
                          style: TextStyle(
                                              fontFamily: '.SF Pro Text',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.36,
                                              height: 1.1,
                                              color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                Container(
                                      padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            primaryColor.withOpacity(0.15),
                                            primaryColor.withOpacity(0.05),
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        CupertinoIcons.person_circle_fill,
                                        color: primaryColor,
                                        size: 24,
                                      ),
                      ),
                    ],
                  ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        primaryColor.withOpacity(0.12),
                                        primaryColor.withOpacity(0.04),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.chart_bar_fill,
                                        color: primaryColor,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                                            const Text(
                                              '15% Improvement',
                          style: TextStyle(
                                                fontFamily: '.SF Pro Text',
                                                fontSize: 15,
                            fontWeight: FontWeight.w500,
                                                letterSpacing: -0.24,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'in memory skills this week',
                                              style: TextStyle(
                                                fontFamily: '.SF Pro Text',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: -0.08,
                                                color: CupertinoColors.secondaryLabel,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Progress Section with refined layout
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Progress Overview',
                                style: TextStyle(
                                  fontFamily: '.SF Pro Text',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.35,
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Row(
                                  children: [
                                    Text(
                                      'See Details',
                                      style: TextStyle(
                                        fontFamily: '.SF Pro Text',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.24,
                                        color: primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      CupertinoIcons.chevron_right,
                                      size: 14,
                                      color: primaryColor,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  widget.tabController.index = 1;
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
                                                  CupertinoColors.systemBackground.withOpacity(0.5),
                                                  CupertinoColors.secondarySystemBackground.withOpacity(0.4),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                color: primaryColor.withOpacity(0.1),
                                                width: 0.5,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: CupertinoColors.systemFill.withOpacity(0.04),
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
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            index == 0 ? 'Memory' : index == 1 ? 'Focus' : 'Problem Solving',
                                                            style: const TextStyle(
                                                              fontFamily: '.SF Pro Text',
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: -0.24,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 4),
                                                          Text(
                                                            index == 0 ? '+15%' : index == 1 ? '+8%' : '+12%',
                                                            style: TextStyle(
                                                              fontFamily: '.SF Pro Text',
                                                              fontSize: 24,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.36,
                                                              color: primaryColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            begin: Alignment.topLeft,
                                                            end: Alignment.bottomRight,
                                                            colors: [
                                                              primaryColor.withOpacity(0.15),
                                                              primaryColor.withOpacity(0.05),
                                                            ],
                                                          ),
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          index == 0 ? CupertinoIcons.memories : 
                                                          index == 1 ? CupertinoIcons.timer : CupertinoIcons.square_grid_2x2,
                                                          color: primaryColor,
                                                          size: 20,
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
                                                              final progress = index == 0 ? 0.15 : index == 1 ? 0.08 : 0.12;
                                                              final baseValue = progress * 100;
                                                              final wave = sin(i * 0.5) * 12;
                                                              final variance = Random().nextDouble() * 8 - 4;
                                                              return FlSpot(
                                                                i.toDouble(),
                                                                (baseValue + wave + variance).clamp(0, 100),
                                                              );
                                                            }),
                                                            isCurved: true,
                                                            curveSmoothness: 0.35,
                                                            color: primaryColor,
                                                            barWidth: 2.5,
                                                            isStrokeCapRound: true,
                                                            dotData: FlDotData(show: false),
                                                            belowBarData: BarAreaData(
                                                              show: true,
                                                              gradient: LinearGradient(
                                                                begin: Alignment.topCenter,
                                                                end: Alignment.bottomCenter,
                                                                colors: [
                                                                  primaryColor.withOpacity(0.15),
                                                                  primaryColor.withOpacity(0.02),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                        lineTouchData: LineTouchData(enabled: false),
                                                        maxY: 100,
                                                        minY: 0,
                                                        baselineY: 0,
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
                                          color: primaryColor.withOpacity(index == _currentPage ? 0.9 : 0.2),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
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
                    children: [
                      Expanded(
                        child: _buildQuickAccessCard(
                                      context,
                                      'Daily\nChallenges',
                                      CupertinoIcons.gamecontroller_fill,
                                      const Color(0xFF30B0C7),
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
                                      'Learning\nResources',
                                      CupertinoIcons.book_fill,
                                      const Color(0xFF30B0C7),
                                      () {
                                        // Switch to resources tab
                                        widget.tabController.index = 3; // Resources is the 4th tab (index 3)
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                                'Latest Updates',
                                style: TextStyle(
                                  fontFamily: '.SF Pro Text',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.35,
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Row(
                                  children: [
                                    Text(
                                      'View All',
                          style: TextStyle(
                                        fontFamily: '.SF Pro Text',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.24,
                                        color: primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      CupertinoIcons.chevron_right,
                                      size: 14,
                                      color: primaryColor,
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
                            primaryColor,
                        ),
                          const SizedBox(height: 12),
                        _buildNewsItem(
                            context,
                            'Weekly Report Ready',
                            'Performance Insights',
                            'Your personalized cognitive performance report for this week is now available.',
                          '1d ago',
                            primaryColor,
                        ),
                      ],
                    ),
                  ),
                    const SizedBox(height: 32),
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
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.25),
              color.withOpacity(0.1),
            ],
            stops: const [0.0, 1.0],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: color.withOpacity(0.15),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemFill.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.2),
                    color.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontFamily: '.SF Pro Text',
                fontSize: 17,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.41,
                height: 1.3,
                color: CupertinoColors.label,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Explore',
                  style: TextStyle(
                    fontFamily: '.SF Pro Text',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.08,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  CupertinoIcons.chevron_right,
                  size: 12,
                  color: CupertinoColors.secondaryLabel,
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
                CupertinoColors.systemBackground.withOpacity(0.30),
                CupertinoColors.secondarySystemBackground.withOpacity(0.30),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: accentColor.withOpacity(0.1),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.systemFill.withOpacity(0.05),
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
                          accentColor.withOpacity(0.2),
                          accentColor.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontFamily: '.SF Pro Text',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: accentColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    time,
                    style: const TextStyle(
                      fontFamily: '.SF Pro Text',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: '.SF Pro Text',
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.41,
                  color: CupertinoColors.label,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontFamily: '.SF Pro Text',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.24,
                  color: CupertinoColors.secondaryLabel,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
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