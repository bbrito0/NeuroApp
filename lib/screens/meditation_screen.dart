import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'meditation_session_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../services/tutorial_service.dart';
import '../widgets/widgets.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  late ScrollController _scrollController;

  // Single key for the tutorial
  final GlobalKey meditationTitleKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Show tutorial when the screen is first built if enabled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (TutorialService.shouldShowTutorial(TutorialService.MEDITATION_TUTORIAL)) {
        _showTutorial();
        TutorialService.markTutorialAsShown(TutorialService.MEDITATION_TUTORIAL);
      }
    });
  }

  void _showTutorial() {
    TutorialService.createMeditationTutorial(
      context,
      [meditationTitleKey],
      _scrollController,
    ).show(context: context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          GradientBackground(
            customGradient: AppColors.primaryGradient,
            hasSafeArea: false,
            child: Container(),
          ),
          CustomScrollView(
            controller: _scrollController,
            primary: false,
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                  localizations.meditation,
                  style: AppTextStyles.withColor(AppTextStyles.heading1, AppColors.textPrimary),
                ),
                middle: Text(
                  localizations.meditation,
                  style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                ),
                alwaysShowMiddle: false,
                backgroundColor: Colors.transparent,
                border: null,
                stretch: false,
                automaticallyImplyLeading: false,
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                  child: Icon(
                    CupertinoIcons.back,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  key: meditationTitleKey,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        localizations.featuredMeditations,
                        style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
                      ),
                    ),
                    _MeditationCard(
                      title: localizations.mindfulBreathing,
                      description: localizations.mindfulBreathingDesc,
                      duration: '10 min',
                      icon: SFIcons.sf_leaf,
                    ),
                    _MeditationCard(
                      title: localizations.bodyScan,
                      description: localizations.bodyScanDesc,
                      duration: '15 min',
                      icon: SFIcons.sf_figure_walk,
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  _MeditationCard(
                    title: localizations.mentalClarity,
                    description: localizations.mentalClarityDesc,
                    duration: '12 min',
                    icon: SFIcons.sf_brain_head_profile,
                  ),
                  _MeditationCard(
                    title: localizations.stressRelief,
                    description: localizations.stressReliefDesc,
                    duration: '20 min',
                    icon: SFIcons.sf_heart,
                  ),
                  _MeditationCard(
                    title: localizations.deepFocus,
                    description: localizations.deepFocusDesc,
                    duration: '15 min',
                    icon: SFIcons.sf_scope,
                  ),
                ]),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => MeditationSessionScreen(
                session: MeditationSession(
                  title: title,
                  duration: duration,
                  themeColor: AppColors.primary,
                  icon: icon,
                ),
              ),
            ),
          );
        },
        child: FrostedCard(
          borderRadius: 20,
          padding: const EdgeInsets.all(16),
          backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
          border: Border.all(
            color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
            width: 0.5,
          ),
          child: Row(
            children: [
              SFIcon(
                icon,
                fontSize: 28,
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
                            color: AppColors.getPrimaryWithOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 