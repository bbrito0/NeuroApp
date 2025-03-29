import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'article_detail_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../services/tutorial_service.dart';
import '../widgets/widgets.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({
    super.key,
    required this.tabController,
  });

  final CupertinoTabController tabController;

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
                  onPressed: () => Navigator.of(context).pop(),
                  child: Icon(
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
                    prefix: Padding(
                      padding: const EdgeInsets.only(left: 8),
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
                        ),
                        _CategoryCard(
                          title: localizations.focus,
                          icon: SFIcons.sf_scope,
                        ),
                        _CategoryCard(
                          title: localizations.speed,
                          icon: SFIcons.sf_gauge_with_needle,
                        ),
                        _CategoryCard(
                          title: localizations.problemSolving,
                          icon: SFIcons.sf_puzzlepiece,
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
                            SFIcon(
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
                    if (index >= 2) {
                      return _ArticleCard(
                        title: localizations.improveMemoryTitle('${index + 1}'),
                        description: localizations.improveMemoryDescription,
                        readTime: localizations.minRead('${5 + index}'),
                      );
                    }
                    
                    return index == 0 ? Container(
                      key: articlesContainerKey,
                      child: _ArticleCard(
                        title: localizations.improveMemoryTitle('${index + 1}'),
                        description: localizations.improveMemoryDescription,
                        readTime: localizations.minRead('${5 + index}'),
                      ),
                    ) : _ArticleCard(
                      title: localizations.improveMemoryTitle('${index + 1}'),
                      description: localizations.improveMemoryDescription,
                      readTime: localizations.minRead('${5 + index}'),
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

  const _CategoryCard({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: FrostedCard(
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
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final String title;
  final String description;
  final String readTime;

  const _ArticleCard({
    required this.title,
    required this.description,
    required this.readTime,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: FrostedCard(
        borderRadius: 20,
        backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
        border: Border.all(
          color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
          width: 0.5,
        ),
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(
                builder: (context) => ArticleDetailScreen(
                  title: title,
                  description: description,
                  readTime: readTime,
                ),
                fullscreenDialog: false,
                maintainState: true,
              ),
            );
          },
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
        ),
      ),
    );
  }
} 