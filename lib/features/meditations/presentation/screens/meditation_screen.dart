import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/services/feature_access_service.dart';
import '../../../../core/datasources/static/feature_mapping.dart';
import '../../../../core/widgets/widgets.dart';

// GoRouter imports
import 'package:go_router/go_router.dart';

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
    final localizations = AppLocalizations.of(context);
    
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
                  onPressed: () => context.pop(),
                  child: const Icon(
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
                      padding: const EdgeInsets.all(_MeditationCard.cardPadding),
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
                      featureId: FeatureMapping.FEATURE_MINDFUL_BREATHING,
                    ),
                    _MeditationCard(
                      title: localizations.bodyScan,
                      description: localizations.bodyScanDesc,
                      duration: '15 min',
                      icon: SFIcons.sf_figure_walk,
                      featureId: FeatureMapping.FEATURE_BODY_SCAN,
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
                    featureId: FeatureMapping.FEATURE_MENTAL_CLARITY,
                  ),
                  _MeditationCard(
                    title: localizations.stressRelief,
                    description: localizations.stressReliefDesc,
                    duration: '20 min',
                    icon: SFIcons.sf_heart,
                    featureId: FeatureMapping.FEATURE_STRESS_RELIEF,
                  ),
                  _MeditationCard(
                    title: localizations.deepFocus,
                    description: localizations.deepFocusDesc,
                    duration: '15 min',
                    icon: SFIcons.sf_scope,
                    featureId: FeatureMapping.FEATURE_DEEP_FOCUS,
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
  // UI Constants
  static const double cardPadding = 16.0;
  static const double cardMarginVertical = 8.0;
  static const double cardBorderRadius = 20.0;
  static const double borderWidth = 0.5;
  static const double contentSpacing = 16.0;
  static const double smallSpacing = 4.0;
  static const double durationPaddingHorizontal = 8.0;
  static const double durationPaddingVertical = 4.0;
  static const double durationBorderRadius = 12.0;
  static const double iconSize = 28.0;
  
  final String title;
  final String description;
  final String duration;
  final IconData icon;
  final String featureId;

  const _MeditationCard({
    required this.title,
    required this.description,
    required this.duration,
    required this.icon,
    required this.featureId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final featureAccessService = Provider.of<FeatureAccessService>(context);
    final hasAccess = featureAccessService.canAccess(featureId);
    final requiredSupplements = featureAccessService.getRequiredSupplementsForFeature(featureId);
    
    Widget cardContent = FrostedCard(
      borderRadius: cardBorderRadius,
      padding: const EdgeInsets.all(cardPadding),
      backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
      border: Border.all(
        color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
        width: borderWidth,
      ),
      child: Row(
        children: [
          SFIcon(
            icon,
            fontSize: iconSize,
            color: AppColors.primary,
          ),
          const SizedBox(width: contentSpacing),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: durationPaddingHorizontal, 
                        vertical: durationPaddingVertical
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.getPrimaryWithOpacity(0.1),
                        borderRadius: BorderRadius.circular(durationBorderRadius),
                      ),
                      child: Text(
                        duration,
                        style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: smallSpacing),
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
    );
    
    if (!hasAccess) {
      cardContent = LockedFeatureOverlay(
        requiredSupplements: requiredSupplements,
        child: cardContent,
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: cardPadding, vertical: cardMarginVertical),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: hasAccess ? () {
          context.push('/activities/meditations/session/${title.toLowerCase().replaceAll(' ', '-')}');
        } : null,
        child: cardContent,
      ),
    );
  }
} 