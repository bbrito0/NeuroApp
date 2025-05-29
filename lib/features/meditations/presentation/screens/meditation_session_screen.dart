import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import '../../../../config/theme/app_colors.dart';

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
  final double _progress = 0.0;
  
  // UI Constants
  static const double buttonPadding = 8.0;
  static const double contentPadding = 32.0;
  static const double titleSpacing = 16.0;
  static const double playButtonSize = 80.0;
  static const double iconSize = 40.0;
  static const double progressBarHeight = 4.0;
  static const double progressBarRadius = 4.0;
  static const double progressBarSpacing = 8.0;
  static const double timeTextSize = 13.0;
  static const double titleFontSize = 26.0;
  static const double blurAmount = 60.0;
  static const double playButtonShadowBlur = 20.0;
  static const double playButtonShadowOffset = 4.0;
  static const Color uiColor = Color(0xFF8E9EAB);
  static const Duration animationDuration = Duration(milliseconds: 200);

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
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Animated Wave Background with lighter colors
          WaveWidget(
            config: CustomConfig(
              gradients: [
                [
                  AppColors.getColorWithOpacity(const Color(0xFFE0E5EC), 0.4),  // Much lighter grey
                  AppColors.getColorWithOpacity(const Color(0xFFCFD9DF), 0.6),   // Soft grey-blue
                ],
                [
                  AppColors.getColorWithOpacity(const Color(0xFFD3DCE3), 0.3),   // Another light grey
                  AppColors.getColorWithOpacity(const Color(0xFFE5E9F0), 0.5),   // Very light grey-blue
                ],
              ],
              durations: const [19440, 10800],
              heightPercentages: const [0.20, 0.25],
              blur: const MaskFilter.blur(BlurStyle.solid, 10),
              gradientBegin: const Alignment(-1.0, 1.0),
              gradientEnd: const Alignment(1.0, -1.0),
            ),
            waveAmplitude: 0,
            size: const Size(double.infinity, double.infinity),
          ),
          // Frosted Glass Overlay with lighter opacity
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-1.0, 1.0),
                  end: const Alignment(1.0, -1.0),
                  colors: [
                    AppColors.getColorWithOpacity(Colors.white, 0.2),
                    AppColors.getColorWithOpacity(Colors.white, 0.3),
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
                  padding: const EdgeInsets.only(left: buttonPadding, top: buttonPadding),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Icon(
                      CupertinoIcons.back,
                      color: uiColor,
                    ),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.fromLTRB(contentPadding, titleSpacing, contentPadding, 0),
                  child: Center(
                    child: Text(
                      widget.session.title,
                      style: const TextStyle(
                        fontFamily: '.SF Pro Display',
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.36,
                        color: CupertinoColors.label,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Spacer(),
                // Play/Pause Button with updated colors
                Center(
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      width: playButtonSize,
                      height: playButtonSize,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.getColorWithOpacity(uiColor, 0.7),  // Lighter control color
                            AppColors.getColorWithOpacity(const Color(0xFFA1ADC0), 0.7),  // Slightly lighter variant
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.getColorWithOpacity(uiColor, 0.3),
                            blurRadius: playButtonShadowBlur,
                            offset: const Offset(0, playButtonShadowOffset),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: animationDuration,
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
                            ? const SFIcon(
                                SFIcons.sf_pause,
                                key: ValueKey('pause'),
                                fontSize: iconSize,
                                color: Color(0xFF4A5568),  // Darker grey for contrast
                              )
                            : const SFIcon(
                                SFIcons.sf_play,
                                key: ValueKey('play'),
                                fontSize: iconSize,
                                color: Color(0xFF4A5568),  // Darker grey for contrast
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                // Progress Bar with updated colors
                Padding(
                  padding: const EdgeInsets.fromLTRB(contentPadding, 0, contentPadding, 48.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(progressBarRadius),
                        child: SizedBox(
                          height: progressBarHeight,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.getColorWithOpacity(uiColor, 0.2),  // Lighter background
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: _progress,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF4A5568),  // Darker progress color for contrast
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: progressBarSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(Duration(seconds: (_progress * 600).toInt())),
                            style: const TextStyle(
                              fontFamily: '.SF Pro Text',
                              fontSize: timeTextSize,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4A5568),  // Darker text for contrast
                            ),
                          ),
                          Text(
                            widget.session.duration,
                            style: const TextStyle(
                              fontFamily: '.SF Pro Text',
                              fontSize: timeTextSize,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4A5568),  // Darker text for contrast
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