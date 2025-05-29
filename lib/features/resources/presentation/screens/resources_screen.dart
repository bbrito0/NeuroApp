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
import '../../../../app_router.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({
    super.key,
  });

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  late ScrollController _scrollController;

  // Add GlobalKeys for tutorial targets
  final GlobalKey searchKey = GlobalKey();
  final GlobalKey categoriesContainerKey = GlobalKey();
  final GlobalKey articlesContainerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Show tutorial when the screen is first built if enabled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (TutorialService.shouldShowTutorial(TutorialService.RESOURCES_TUTORIAL)) {
        _showTutorial();
        TutorialService.markTutorialAsShown(TutorialService.RESOURCES_TUTORIAL);
      }
    });
  }

  void _showTutorial() {
    TutorialService.createResourcesTutorial(
      context,
      [searchKey, categoriesContainerKey, articlesContainerKey],
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
                  localizations.resources,
                  style: AppTextStyles.withColor(AppTextStyles.heading1, AppColors.textPrimary),
                ),
                middle: Text(
                  localizations.resources,
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                  child: CustomTextField(
                    key: searchKey,
                    hintText: localizations.searchResources,
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        CupertinoIcons.search,
                        size: 16,
                        color: AppColors.secondaryLabel,
                      ),
                    ),
                    borderRadius: 20,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    localizations.categories,
                    style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 110,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                    child: ListView(
                      key: categoriesContainerKey,
                      padding: const EdgeInsets.all(16),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _CategoryCard(
                          title: localizations.memory,
                          icon: SFIcons.sf_brain_head_profile,
                          featureId: FeatureMapping.FEATURE_MEMORY_ARTICLES,
                        ),
                        _CategoryCard(
                          title: localizations.focus,
                          icon: SFIcons.sf_scope,
                          featureId: FeatureMapping.FEATURE_FOCUS_ARTICLES,
                        ),
                        _CategoryCard(
                          title: localizations.speed,
                          icon: SFIcons.sf_gauge_with_needle,
                          featureId: FeatureMapping.FEATURE_SPEED_ARTICLES,
                        ),
                        _CategoryCard(
                          title: localizations.problemSolving,
                          icon: SFIcons.sf_puzzlepiece,
                          featureId: FeatureMapping.FEATURE_PROBLEM_SOLVING_ARTICLES,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizations.featuredArticles,
                        style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Row(
                          children: [
                            Text(
                              localizations.viewAll,
                              style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.primary),
                            ),
                            const SizedBox(width: 4),
                            const SFIcon(
                              SFIcons.sf_chevron_right,
                              fontSize: 14,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Assign different feature IDs to articles based on index
                    String featureId;
                    if (index == 0 || index == 1) {
                      featureId = FeatureMapping.FEATURE_MEMORY_ARTICLES;
                    } else if (index == 2) {
                      featureId = FeatureMapping.FEATURE_FOCUS_ARTICLES;
                    } else if (index == 3) {
                      featureId = FeatureMapping.FEATURE_SPEED_ARTICLES;
                    } else {
                      featureId = FeatureMapping.FEATURE_PROBLEM_SOLVING_ARTICLES;
                    }
                    
                    if (index >= 2) {
                      return _ArticleCard(
                        title: localizations.improveMemoryTitle('${index + 1}'),
                        description: localizations.improveMemoryDescription,
                        readTime: localizations.minRead('${5 + index}'),
                        featureId: featureId,
                      );
                    }
                    
                    return index == 0 ? Container(
                      key: articlesContainerKey,
                      child: _ArticleCard(
                        title: localizations.improveMemoryTitle('${index + 1}'),
                        description: localizations.improveMemoryDescription,
                        readTime: localizations.minRead('${5 + index}'),
                        featureId: featureId,
                      ),
                    ) : _ArticleCard(
                      title: localizations.improveMemoryTitle('${index + 1}'),
                      description: localizations.improveMemoryDescription,
                      readTime: localizations.minRead('${5 + index}'),
                      featureId: featureId,
                    );
                  },
                  childCount: 5,
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String featureId;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.featureId,
  });

  @override
  Widget build(BuildContext context) {
    final featureAccessService = Provider.of<FeatureAccessService>(context);
    final hasAccess = featureAccessService.canAccess(featureId);
    final requiredSupplements = featureAccessService.getRequiredSupplementsForFeature(featureId);
    
    Widget cardContent = FrostedCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(12),
      backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
      border: Border.all(
        color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
        width: 0.5,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SFIcon(
            icon,
            fontSize: 22,
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
    
    if (!hasAccess) {
      cardContent = LockedFeatureOverlay(
        requiredSupplements: requiredSupplements,
        showTooltip: false,
        child: cardContent,
      );
    }
    
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: hasAccess ? () {
          // Handle category tap
        } : null,
        child: cardContent,
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final String title;
  final String description;
  final String readTime;
  final String featureId;

  const _ArticleCard({
    required this.title,
    required this.description,
    required this.readTime,
    required this.featureId,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final featureAccessService = Provider.of<FeatureAccessService>(context);
    final hasAccess = featureAccessService.canAccess(featureId);
    final requiredSupplements = featureAccessService.getRequiredSupplementsForFeature(featureId);
    
    Widget cardContent = FrostedCard(
      borderRadius: 20,
      backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
      border: Border.all(
        color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
        width: 0.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.getPrimaryWithOpacity(AppColors.inactiveOpacity),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    localizations.article,
                    style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.primary),
                  ),
                ),
                const Spacer(),
                Text(
                  readTime,
                  style: AppTextStyles.secondaryText,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppTextStyles.secondaryText,
            ),
          ],
        ),
      ),
    );
    
    if (!hasAccess) {
      cardContent = LockedFeatureOverlay(
        requiredSupplements: requiredSupplements,
        child: cardContent,
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: hasAccess ? () {
          AppNavigation.toArticleDetail(
            context,
            title: title,
            description: description,
            readTime: readTime,
          );
        } : null,
        child: cardContent,
      ),
    );
  }
} 