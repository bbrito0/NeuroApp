import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'dart:math' show pi, sin;

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> with SingleTickerProviderStateMixin {
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
      backgroundColor: const Color(0xFFE8E8EA),
      child: Stack(
        children: [
          // Animated Wave Background
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
                  'Train Your Brain',
                  style: TextStyle(
                    fontFamily: '.SF Pro Text',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.41,
                  ),
                ),
                backgroundColor: const Color(0xFFE8E8EA).withOpacity(0.8),
                border: null,
                stretch: true,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Featured Games',
                        style: TextStyle(
                          fontFamily: '.SF Pro Text',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.41,
                          color: CupertinoColors.label,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final game = games[index];
                      return GestureDetector(
                        onTap: () {
                          // TODO: Navigate to game
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
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
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: game.color.withOpacity(0.08),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          game.color.withOpacity(0.2),
                                          game.color.withOpacity(0.1),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      game.icon,
                                      size: 32,
                                      color: game.color,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    game.name,
                                    style: const TextStyle(
                                      fontFamily: '.SF Pro Text',
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.41,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      game.description,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: '.SF Pro Text',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.24,
                                        color: CupertinoColors.secondaryLabel.withOpacity(0.9),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Play',
                                        style: TextStyle(
                                          fontFamily: '.SF Pro Text',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.24,
                                          color: game.color,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        CupertinoIcons.chevron_right,
                                        size: 12,
                                        color: game.color,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: games.length,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Game {
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const Game({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

final List<Game> games = [
  Game(
    name: 'Memory Match',
    description: 'Enhance your memory capacity',
    icon: CupertinoIcons.square_grid_2x2,
    color: const Color(0xFF30B0C7),
  ),
  Game(
    name: 'Quick Math',
    description: 'Boost calculation speed',
    icon: CupertinoIcons.number,
    color: const Color(0xFF30B0C7),
  ),
  Game(
    name: 'Pattern Quest',
    description: 'Train pattern recognition',
    icon: CupertinoIcons.rectangle_grid_3x2,
    color: const Color(0xFF30B0C7),
  ),
  Game(
    name: 'Word Recall',
    description: 'Improve verbal memory',
    icon: CupertinoIcons.text_quote,
    color: const Color(0xFF30B0C7),
  ),
  Game(
    name: 'Focus Timer',
    description: 'Build concentration',
    icon: CupertinoIcons.timer,
    color: const Color(0xFF30B0C7),
  ),
  Game(
    name: 'Visual Puzzle',
    description: 'Train spatial thinking',
    icon: CupertinoIcons.square_grid_2x2,
    color: const Color(0xFF30B0C7),
  ),
];

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