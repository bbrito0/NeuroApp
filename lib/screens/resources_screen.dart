import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'article_detail_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

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
                    'Resources',
                    style: AppTextStyles.withColor(AppTextStyles.heading1, AppColors.textPrimary),
                  ),
                  middle: Text(
                    'Resources',
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
                          child: const CupertinoSearchTextField(
                            style: TextStyle(
                              fontFamily: '.SF Pro Text',
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.41,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Categories',
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
                        padding: const EdgeInsets.all(16),
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _CategoryCard(
                            title: 'Memory',
                            icon: SFIcons.sf_brain_head_profile,
                          ),
                          _CategoryCard(
                            title: 'Focus',
                            icon: SFIcons.sf_scope,
                          ),
                          _CategoryCard(
                            title: 'Speed',
                            icon: SFIcons.sf_gauge_with_needle,
                          ),
                          _CategoryCard(
                            title: 'Problem Solving',
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
                          'Featured Articles',
                          style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.textPrimary),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Row(
                            children: [
                              Text(
                                'View All',
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
                      return _ArticleCard(
                        title: 'How to Improve Memory - Part ${index + 1}',
                        description: 'Learn effective techniques to enhance your memory capacity and retention.',
                        readTime: '${5 + index} min read',
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
                            'Article',
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
        ),
      ),
    );
  }
} 