import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'dart:math';

class PatternRecallGame extends StatefulWidget {
  const PatternRecallGame({super.key});

  @override
  State<PatternRecallGame> createState() => _PatternRecallGameState();
}

class _PatternRecallGameState extends State<PatternRecallGame> {
  static const int gridSize = 3;
  List<bool> tileHighlights = List.generate(gridSize * gridSize, (index) => false);
  List<int> sequence = [];
  List<int> userInput = [];
  bool isDisplayingSequence = false;
  int currentLevel = 3;
  int correctStreak = 0;
  int errorCount = 0;
  String statusText = "Start a new game!";
  bool isGameStarted = false;

  void generateSequence() {
    sequence = List.generate(currentLevel, (_) => Random().nextInt(gridSize * gridSize));
  }

  Future<void> playSequence() async {
    setState(() {
      isDisplayingSequence = true;
      statusText = "Watch the pattern!";
    });

    for (int index in sequence) {
      setState(() => tileHighlights[index] = true);
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => tileHighlights[index] = false);
      await Future.delayed(const Duration(milliseconds: 200));
    }

    setState(() {
      isDisplayingSequence = false;
      statusText = "Your turn!";
    });
  }

  void onTileTap(int index) {
    if (isDisplayingSequence || !isGameStarted) return;

    setState(() {
      userInput.add(index);
      if (sequence[userInput.length - 1] != index) {
        _handleIncorrectTap(index);
      } else if (userInput.length == sequence.length) {
        _handleCorrectSequence();
      }
    });
  }

  void _handleIncorrectTap(int index) {
    errorCount++;
    tileHighlights[index] = true;
    statusText = "Wrong pattern! Try again.";

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          tileHighlights[index] = false;
          userInput.clear();
          if (errorCount >= 2) {
            currentLevel = max(1, currentLevel - 1);
            errorCount = 0;
            statusText = "Level decreased. Start new game.";
            isGameStarted = false;
          }
        });
      }
    });
  }

  void _handleCorrectSequence() {
    correctStreak++;
    statusText = "Correct! Well done!";

    if (correctStreak >= 3) {
      currentLevel++;
      correctStreak = 0;
      statusText = "Level up! Start new game.";
      isGameStarted = false;
    } else {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            userInput.clear();
            generateSequence();
            playSequence();
          });
        }
      });
    }
  }

  void startNewGame() {
    setState(() {
      userInput.clear();
      isGameStarted = true;
      generateSequence();
    });
    playSequence();
  }

  Color _getTileColor(int index) {
    if (!tileHighlights[index]) return const Color(0xFFE8E8EA);
    
    if (userInput.isNotEmpty && index == userInput.last) {
      if (sequence[userInput.length - 1] != index) {
        return CupertinoColors.destructiveRed;
      } else {
        return const Color(0xFF50d5e5); // Light blue for correct taps
      }
    }
    return const Color(0xFF30B0C7);
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
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: const Text(
                  'Pattern Recall',
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
                                        statusText,
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
                                        'Level: $currentLevel',
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
                            onPressed: !isDisplayingSequence ? startNewGame : null,
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
                      // Game Grid
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: gridSize,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: gridSize * gridSize,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => onTileTap(index),
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
                                              _getTileColor(index).withOpacity(0.6),
                                              _getTileColor(index).withOpacity(0.4),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: _getTileColor(index).withOpacity(0.1),
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
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
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