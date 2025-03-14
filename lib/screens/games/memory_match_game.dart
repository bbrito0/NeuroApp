import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'dart:math' show pi, sin;

class MemoryMatchGame extends StatefulWidget {
  const MemoryMatchGame({super.key});

  @override
  State<MemoryMatchGame> createState() => _MemoryMatchGameState();
}

class _MemoryMatchGameState extends State<MemoryMatchGame> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<bool> _flippedCards = List.generate(16, (index) => false);
  int _score = 0;
  int _moves = 0;
  final List<int> _matchedPairs = [];
  List<int>? _currentPair;

  final List<IconData> _icons = [
    CupertinoIcons.heart_fill,
    CupertinoIcons.star_fill,
    CupertinoIcons.bell_fill,
    CupertinoIcons.circle_fill,
    CupertinoIcons.square_fill,
    CupertinoIcons.triangle_fill,
    CupertinoIcons.moon_fill,
    CupertinoIcons.sun_max_fill,
  ];

  late List<IconData> _gameIcons;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    // Create pairs of icons
    _gameIcons = [..._icons, ..._icons];
    // Shuffle the icons
    _gameIcons.shuffle();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCardTap(int index) {
    if (_flippedCards[index] || _matchedPairs.contains(index)) return;

    setState(() {
      _flippedCards[index] = true;
      
      if (_currentPair == null) {
        _currentPair = [index];
      } else {
        _moves++;
        if (_gameIcons[_currentPair![0]] == _gameIcons[index]) {
          // Match found
          _matchedPairs.addAll([_currentPair![0], index]);
          _score += 10;
          _currentPair = null;
        } else {
          // No match
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) {
              setState(() {
                _flippedCards[_currentPair![0]] = false;
                _flippedCards[index] = false;
                _currentPair = null;
              });
            }
          });
        }
      }
    });
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
                  'Memory Match',
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
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Icon(
                    CupertinoIcons.back,
                    color: Color(0xFF30B0C7),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Score and Moves Display
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(16),
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
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Score',
                                      style: TextStyle(
                                        fontFamily: '.SF Pro Text',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: CupertinoColors.secondaryLabel,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _score.toString(),
                                      style: TextStyle(
                                        fontFamily: '.SF Pro Text',
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Moves',
                                      style: TextStyle(
                                        fontFamily: '.SF Pro Text',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: CupertinoColors.secondaryLabel,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _moves.toString(),
                                      style: TextStyle(
                                        fontFamily: '.SF Pro Text',
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Game Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: 16,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _onCardTap(index),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        _flippedCards[index] || _matchedPairs.contains(index)
                                            ? primaryColor.withOpacity(0.3)
                                            : CupertinoColors.systemBackground.withOpacity(0.35),
                                        _flippedCards[index] || _matchedPairs.contains(index)
                                            ? primaryColor.withOpacity(0.2)
                                            : CupertinoColors.secondarySystemBackground.withOpacity(0.35),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: primaryColor.withOpacity(0.08),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: _flippedCards[index] || _matchedPairs.contains(index)
                                        ? Icon(
                                            _gameIcons[index],
                                            color: _matchedPairs.contains(index)
                                                ? primaryColor
                                                : primaryColor.withOpacity(0.8),
                                            size: 32,
                                          )
                                        : Icon(
                                            CupertinoIcons.question,
                                            color: primaryColor.withOpacity(0.3),
                                            size: 32,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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