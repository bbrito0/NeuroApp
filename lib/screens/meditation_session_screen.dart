import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class MeditationSession {
  final String title;
  final String duration;
  final Color themeColor;
  final IconData icon;

  const MeditationSession({
    required this.title,
    required this.duration,
    required this.themeColor,
    required this.icon,
  });
}

class MeditationSessionScreen extends StatefulWidget {
  final MeditationSession session;

  const MeditationSessionScreen({
    super.key,
    required this.session,
  });

  @override
  State<MeditationSessionScreen> createState() => _MeditationSessionScreenState();
}

class _MeditationSessionScreenState extends State<MeditationSessionScreen> {
  bool _isPlaying = false;
  double _progress = 0.0;

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final uiColor = const Color(0xFFADB5BD); // Lighter grey tone
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Animated Wave Background
          WaveWidget(
            config: CustomConfig(
              gradients: [
                [
                  const Color(0xFF33576e).withOpacity(0.3),
                  const Color(0xFF5085a7 ).withOpacity(0.7),
                ],
                [
                  const Color(0xFF33576e).withOpacity(0.25),
                  const Color(0xFF33576e).withOpacity(0.65),
                ],
              ],
              durations: [19440, 10800],
              heightPercentages: [0.20, 0.25],
              blur: const MaskFilter.blur(BlurStyle.solid, 10),
              gradientBegin: const Alignment(-1.0, 1.0),
              gradientEnd: const Alignment(1.0, -1.0),
            ),
            waveAmplitude: 0,
            size: const Size(double.infinity, double.infinity),
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
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.25),
                  ],
                ),
              ),
            ),
          ),
          // Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Icon(
                      CupertinoIcons.back,
                      color: uiColor,
                    ),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 0),
                  child: Center(
                    child: Text(
                      widget.session.title,
                      style: const TextStyle(
                        fontFamily: '.SF Pro Display',
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.36,
                        color: CupertinoColors.label,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Spacer(),
                // Play/Pause Button
                Center(
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            uiColor.withOpacity(0.5),
                            uiColor.withOpacity(0.5),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: uiColor.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: _isPlaying
                            ? SFIcon(
                                SFIcons.sf_pause,
                                key: const ValueKey('pause'),
                                fontSize: 40,
                                color: const Color(0xFF2C3E50).withOpacity(0.6),
                              )
                            : SFIcon(
                                SFIcons.sf_play,
                                key: const ValueKey('play'),
                                fontSize: 40,
                                color: const Color(0xFF2C3E50).withOpacity(0.6),
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                // Progress Bar and Time Labels
                Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 48.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          height: 4,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: uiColor.withOpacity(0.3),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: _progress,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2C3E50),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(Duration(seconds: (_progress * 600).toInt())),
                            style: const TextStyle(
                              fontFamily: '.SF Pro Text',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          Text(
                            widget.session.duration,
                            style: const TextStyle(
                              fontFamily: '.SF Pro Text',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 