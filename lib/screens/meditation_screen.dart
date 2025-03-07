import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'meditation_session_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.frostedGlassGradient,
              ),
            ),
          ),
          CupertinoScrollbar(
            thickness: 3.0,
            radius: const Radius.circular(1.5),
            mainAxisMargin: 2.0,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text(
                    'Meditation',
                    style: AppTextStyles.withColor(AppTextStyles.heading1, AppColors.textPrimary),
                  ),
                  middle: Text(
                    'Meditation',
                    style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                  ),
                  alwaysShowMiddle: false,
                  backgroundColor: Colors.transparent,
                  border: null,
                  stretch: false,
                  automaticallyImplyLeading: false,
                  leading: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Icon(
                      CupertinoIcons.back,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Featured Meditations This Week',
                      style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    _MeditationCard(
                      title: 'Mindful Breathing',
                      description: 'A gentle introduction to mindful breathing techniques for relaxation and focus.',
                      duration: '10 min',
                      icon: SFIcons.sf_leaf,
                    ),
                    _MeditationCard(
                      title: 'Body Scan',
                      description: 'Progressive relaxation through a guided body awareness meditation.',
                      duration: '15 min',
                      icon: SFIcons.sf_figure_walk,
                    ),
                    _MeditationCard(
                      title: 'Mental Clarity',
                      description: 'Clear your mind and enhance focus with this guided meditation session.',
                      duration: '12 min',
                      icon: SFIcons.sf_brain_head_profile,
                    ),
                    _MeditationCard(
                      title: 'Stress Relief',
                      description: 'Release tension and find inner peace with calming visualization techniques.',
                      duration: '20 min',
                      icon: SFIcons.sf_heart,
                    ),
                    _MeditationCard(
                      title: 'Deep Focus',
                      description: 'Enhance concentration and mental clarity for improved productivity.',
                      duration: '15 min',
                      icon: SFIcons.sf_scope,
                    ),
                  ]),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MeditationCard extends StatelessWidget {
  final String title;
  final String description;
  final String duration;
  final IconData icon;

  const _MeditationCard({
    required this.title,
    required this.description,
    required this.duration,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                  AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
                width: 0.5,
              ),
            ),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
                    builder: (context) => MeditationSessionScreen(
                      session: MeditationSession(
                        title: title,
                        duration: duration,
                        themeColor: AppColors.primary,
                        icon: icon,
                      ),
                    ),
                    fullscreenDialog: false,
                    maintainState: true,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    SFIcon(
                      icon,
                      fontSize: 22,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                title,
                                style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.getPrimaryWithOpacity(AppColors.inactiveOpacity),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  duration,
                                  style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: AppTextStyles.secondaryText,
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
      ),
    );
  }
} 