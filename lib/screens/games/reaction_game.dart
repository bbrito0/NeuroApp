import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'package:flutter_sficon/flutter_sficon.dart';

class ReactionGame extends StatefulWidget {
  const ReactionGame({super.key});

  @override
  State<ReactionGame> createState() => _ReactionGameState();
}

class _ReactionGameState extends State<ReactionGame> {
  List<Map<String, dynamic>> activeShapes = [];
  String currentTarget = "red";
  int score = 0;
  int combo = 0;
  double spawnInterval = 2000;
  Timer? spawnTimer;
  bool isGameStarted = false;

  final List<String> colors = ["red", "blue", "green", "yellow"];
  final List<String> shapes = ["circle", "square", "triangle"];

  @override
  void dispose() {
    spawnTimer?.cancel();
    super.dispose();
  }

  void startGame() {
    setState(() {
      score = 0;
      combo = 0;
      activeShapes.clear();
      isGameStarted = true;
      currentTarget = colors[Random().nextInt(colors.length)];
    });

    spawnTimer?.cancel();
    spawnTimer = Timer.periodic(Duration(milliseconds: spawnInterval.toInt()), (_) {
      _addNewShape();
    });
  }

  void _addNewShape() {
    if (activeShapes.length >= 10) return; // Limit max shapes

    setState(() {
      final shape = {
        "id": DateTime.now().microsecondsSinceEpoch,
        "color": colors[Random().nextInt(colors.length)],
        "shape": shapes[Random().nextInt(shapes.length)],
        "left": Random().nextDouble() * (MediaQuery.of(context).size.width - 80),
        "top": Random().nextDouble() * (MediaQuery.of(context).size.height * 0.5),
      };
      
      activeShapes.add(shape);
      _scheduleShapeRemoval(shape);
    });
  }

  void _scheduleShapeRemoval(Map<String, dynamic> shape) {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && activeShapes.contains(shape)) {
        setState(() {
          activeShapes.remove(shape);
          combo = 0;
        });
      }
    });
  }

  void onShapeTap(Map<String, dynamic> shape) {
    bool isCorrect = false;
    
    if (currentTarget == shape["color"]) {
      isCorrect = true;
      score += 10 * (combo ~/ 5 + 1);
      combo++;
    } else {
      combo = 0;
    }

    setState(() {
      activeShapes.remove(shape);
      if (combo % 10 == 0 && combo > 0) {
        currentTarget = colors[Random().nextInt(colors.length)];
      }
    });

    if (score % 100 == 0 && score > 0) {
      spawnInterval = max(500, spawnInterval - 100);
      spawnTimer?.cancel();
      startGame();
    }
  }

  Color _getColor(String colorName) {
    switch (colorName) {
      case "red":
        return const Color(0xFFFF3B30);
      case "blue":
        return const Color(0xFF007AFF);
      case "green":
        return const Color(0xFF34C759);
      case "yellow":
        return const Color(0xFFFFCC00);
      default:
        return const Color(0xFF007AFF);
    }
  }

  Widget _buildShape(Map<String, dynamic> shape) {
    final color = _getColor(shape["color"]);
    
    switch (shape["shape"]) {
      case "circle":
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.9),
                color.withOpacity(0.7),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        );
      case "square":
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.9),
                color.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        );
      case "triangle":
        return SizedBox(
          width: 60,
          height: 60,
          child: CustomPaint(
            painter: TrianglePainter(color: color),
          ),
        );
      default:
        return const SizedBox();
    }
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
              gradient: LinearGradient(
                begin: const Alignment(-1.0, 1.0),
                end: const Alignment(1.0, -1.0),
                colors: [
                  const Color(0xFF3c5e68).withOpacity(0.9),
                  const Color(0xFFADC3C8).withOpacity(0.9),
                  const Color(0xFFE8F5F8).withOpacity(0.9),
                ],
                stops: const [0.15, 0.6, 1.0],
              ),
            ),
          ),
          // Frosted Glass Overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-1.0, 1.0),
                  end: const Alignment(1.0, -1.0),
                  colors: [
                    CupertinoColors.white.withOpacity(0.1),
                    CupertinoColors.white.withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ),
          // Main Content
          CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: const Text(
                  'Quick Reaction',
                  style: TextStyle(
                    fontFamily: '.SF Pro Text',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.41,
                    color: CupertinoColors.label,
                  ),
                ),
                backgroundColor: Colors.transparent,
                border: null,
                stretch: false,
                automaticallyImplyLeading: false,
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
                      // Status Display and Start Button Row
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
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
                                      color: const Color(0xFF30B0C7).withOpacity(0.08),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        isGameStarted ? "TAP ${currentTarget.toUpperCase()}" : "Start the game!",
                                        style: const TextStyle(
                                          fontFamily: '.SF Pro Text',
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.41,
                                          color: CupertinoColors.label,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Score: $score | Combo: x${(combo ~/ 5 + 1)}',
                                        style: TextStyle(
                                          fontFamily: '.SF Pro Text',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.24,
                                          color: CupertinoColors.secondaryLabel.withOpacity(0.9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            color: const Color(0xFF50d5e5),
                            onPressed: startGame,
                            child: Text(
                              isGameStarted ? 'Restart' : 'Start',
                              style: const TextStyle(
                                fontFamily: '.SF Pro Text',
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.41,
                                color: Color(0xFF0D5A71),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Game Area
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Stack(
                          children: [
                            // Game shapes
                            ...activeShapes.map((shape) => AnimatedPositioned(
                              duration: const Duration(milliseconds: 200),
                              left: shape["left"],
                              top: shape["top"],
                              child: GestureDetector(
                                onTap: () => onShapeTap(shape),
                                child: AnimatedOpacity(
                                  opacity: 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: _buildShape(shape),
                                ),
                              ),
                            )).toList(),
                          ],
                        ),
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

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withOpacity(0.9),
          color.withOpacity(0.7),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawShadow(path, color, 4, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => color != oldDelegate.color;
} 