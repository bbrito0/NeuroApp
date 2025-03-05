import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'dart:math' show pi, sin;
import 'article_detail_screen.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({
    super.key,
    required this.tabController,
  });

  final CupertinoTabController tabController;

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                animation: _controller,
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
                  'Resources',
                  style: TextStyle(
                    fontFamily: '.SF Pro Text',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.41,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                middle: const Text(
                  'Resources',
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
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                  child: CupertinoSearchTextField(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontFamily: '.SF Pro Text',
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.41,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 130,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: const [
                      _CategoryCard(
                        title: 'Memory',
                        icon: CupertinoIcons.memories,
                        color: Color(0xFF30B0C7),
                      ),
                      _CategoryCard(
                        title: 'Focus',
                        icon: CupertinoIcons.eye,
                        color: Color(0xFF30B0C7),
                      ),
                      _CategoryCard(
                        title: 'Speed',
                        icon: CupertinoIcons.timer,
                        color: Color(0xFF30B0C7),
                      ),
                      _CategoryCard(
                        title: 'Problem Solving',
                        icon: CupertinoIcons.square_grid_2x2,
                        color: Color(0xFF30B0C7),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Featured Articles',
                        style: TextStyle(
                          fontFamily: '.SF Pro Text',
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.41,
                          color: Color(0xFF1A1A1A),
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
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _ArticleCard(
                      title: 'How to Improve Memory - Part ${index + 1}',
                      description: 'Learn effective techniques to enhance your memory capacity and retention.',
                      readTime: '${5 + index} min read',
                      color: const Color(0xFF30B0C7),
                    );
                  },
                  childCount: 5,
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.25),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
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
        mainAxisAlignment: MainAxisAlignment.center,
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
            child: Icon(
              icon,
              size: 24,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontFamily: '.SF Pro Display',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.41,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final String title;
  final String description;
  final String readTime;
  final Color color;

  const _ArticleCard({
    required this.title,
    required this.description,
    required this.readTime,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
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
                color: color.withOpacity(0.08),
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
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
                    builder: (context) => ArticleDetailScreen(
                      title: title,
                      description: description,
                      readTime: readTime,
                    ),
                    fullscreenDialog: false,
                    maintainState: true,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
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
                                color.withOpacity(0.2),
                                color.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Article',
                            style: TextStyle(
                              fontFamily: '.SF Pro Text',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: color,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          readTime,
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
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
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
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFFE8E8EA),
        const Color(0xFFE2E2E4),
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

    for (var i = 0; i < size.width; i++) {
      final x = i.toDouble();
      final dx = (x / size.width);
      final sin1 = sin((dx * 2 * pi) + (animation.value * 2 * pi));
      final y = sin1 * 25 + size.height * 0.5;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    wavePaint.color = const Color(0xFFD0D0D2).withOpacity(0.35);
    for (var i = 0; i < size.width; i++) {
      final x = i.toDouble();
      final dx = (x / size.width);
      final sin2 = sin((dx * 2 * pi) + (animation.value * 2 * pi) + pi / 4);
      final y = sin2 * 20 + size.height * 0.6;
      if (i == 0) {
        path2.moveTo(x, y);
      } else {
        path2.lineTo(x, y);
      }
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    wavePaint.color = const Color(0xFFC8C8CA).withOpacity(0.25);
    for (var i = 0; i < size.width; i++) {
      final x = i.toDouble();
      final dx = (x / size.width);
      final sin3 = sin((dx * 2 * pi) + (animation.value * 2 * pi) - pi / 4);
      final y = sin3 * 8 + size.height * 0.8;
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