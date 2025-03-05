import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'dart:math' show pi, sin;

class ArticleDetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final String readTime;

  const ArticleDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.readTime,
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final primaryColor = const Color(0xFF30B0C7);

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
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFE8E8EA),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xFFE8E8EA).withOpacity(0.8),
        border: null,
        middle: const Text(
          'Article',
          style: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 17,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.41,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
      child: Stack(
        children: [
          // Wave Background
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
          // Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Article Header
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
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
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
                                    child: Text(
                                      'Featured',
                                      style: TextStyle(
                                        fontFamily: '.SF Pro Text',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    widget.readTime,
                                    style: const TextStyle(
                                      fontFamily: '.SF Pro Text',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: CupertinoColors.secondaryLabel,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  fontFamily: '.SF Pro Text',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.41,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.description,
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
                    // Article Content
                    _buildArticleSection(
                      'Introduction',
                      'Memory is a fundamental aspect of cognitive function that plays a crucial role in our daily lives. Whether you\'re studying for an exam, learning a new skill, or simply trying to remember where you left your keys, having a strong memory can make a significant difference.',
                    ),
                    _buildArticleSection(
                      'Key Techniques',
                      '1. Active Recall: Test yourself regularly instead of passively reviewing information.\n\n'
                      '2. Spaced Repetition: Review information at increasing intervals.\n\n'
                      '3. Mind Mapping: Create visual representations of information.\n\n'
                      '4. The Memory Palace: Associate information with familiar locations.',
                    ),
                    _buildArticleSection(
                      'Practice Tips',
                      '• Start with small chunks of information\n'
                      '• Use multiple senses when learning\n'
                      '• Create meaningful associations\n'
                      '• Get adequate sleep and exercise\n'
                      '• Stay mentally active with puzzles and games',
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: ClipRRect(
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
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: '.SF Pro Text',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.41,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  content,
                  style: TextStyle(
                    fontFamily: '.SF Pro Text',
                    fontSize: 15,
                    letterSpacing: -0.24,
                    color: CupertinoColors.label.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
              ],
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