import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<ForumTopic> _topics = [
    ForumTopic(
      title: "Memory Techniques Discussion",
      author: "Sarah M.",
      lastActivity: DateTime.now().subtract(const Duration(minutes: 5)),
      replies: 12,
      likes: 45,
      tags: ["Memory", "Tips"],
    ),
    ForumTopic(
      title: "Daily Brain Training Results",
      author: "Michael R.",
      lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
      replies: 8,
      likes: 23,
      tags: ["Progress", "Training"],
    ),
    ForumTopic(
      title: "Cognitive Health Tips",
      author: "Dr. Emily K.",
      lastActivity: DateTime.now().subtract(const Duration(hours: 6)),
      replies: 15,
      likes: 67,
      tags: ["Health", "Expert"],
    ),
  ];

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
              primary: true,
              physics: const BouncingScrollPhysics(),
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text(
                    'Community',
                    style: AppTextStyles.withColor(
                      AppTextStyles.heading1,
                      AppColors.textPrimary,
                    ),
                  ),
                  backgroundColor: AppColors.getSurfaceWithOpacity(0.7),
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.separator.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _showNewTopicSheet(context);
                    },
                    child: SFIcon(
                      SFIcons.sf_square_and_pencil,
                      fontSize: 22,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildSearchBar(),
                        const SizedBox(height: 16),
                        _buildPopularTags(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildTopicCard(_topics[index]),
                    childCount: _topics.length,
                  ),
                ),
                const SliverPadding(
                  padding: EdgeInsets.only(bottom: 100),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.getSurfaceWithOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.separator.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: CupertinoTextField.borderless(
        prefix: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: SFIcon(
            SFIcons.sf_magnifyingglass,
            fontSize: 16,
            color: AppColors.secondaryLabel,
          ),
        ),
        placeholder: 'Search topics',
        placeholderStyle: AppTextStyles.withColor(
          AppTextStyles.bodyMedium,
          AppColors.secondaryLabel,
        ),
        style: AppTextStyles.withColor(
          AppTextStyles.bodyMedium,
          AppColors.textPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Widget _buildPopularTags() {
    final tags = ["Memory", "Training", "Health", "Tips", "Progress"];
    return SizedBox(
      height: 32,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 8,
              right: index == tags.length - 1 ? 0 : 0,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.getPrimaryWithOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.getPrimaryWithOpacity(0.1),
                  width: 0.5,
                ),
              ),
              child: Text(
                tags[index],
                style: AppTextStyles.withColor(
                  AppTextStyles.bodySmall,
                  AppColors.primary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopicCard(ForumTopic topic) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.getSurfaceWithOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.separator.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            // Navigate to topic detail
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: AppColors.primarySurfaceGradient(
                          startOpacity: 0.1,
                          endOpacity: 0.15,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          topic.author.substring(0, 1),
                          style: AppTextStyles.withColor(
                            AppTextStyles.heading3,
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topic.author,
                            style: AppTextStyles.withColor(
                              AppTextStyles.bodyMedium,
                              AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            _formatTimeAgo(topic.lastActivity),
                            style: AppTextStyles.withColor(
                              AppTextStyles.bodySmall,
                              AppColors.secondaryLabel,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  topic.title,
                  style: AppTextStyles.withColor(
                    AppTextStyles.heading3,
                    AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ...topic.tags.map((tag) => Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.getPrimaryWithOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag,
                            style: AppTextStyles.withColor(
                              AppTextStyles.bodySmall,
                              AppColors.primary,
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Row(
                      children: [
                        SFIcon(
                          SFIcons.sf_bubble_right,
                          fontSize: 16,
                          color: AppColors.secondaryLabel,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${topic.replies}',
                          style: AppTextStyles.withColor(
                            AppTextStyles.bodySmall,
                            AppColors.secondaryLabel,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        SFIcon(
                          SFIcons.sf_heart,
                          fontSize: 16,
                          color: AppColors.secondaryLabel,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${topic.likes}',
                          style: AppTextStyles.withColor(
                            AppTextStyles.bodySmall,
                            AppColors.secondaryLabel,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNewTopicSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.separator.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'New Topic',
                style: AppTextStyles.withColor(
                  AppTextStyles.heading2,
                  AppColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CupertinoTextField(
                      placeholder: 'Topic Title',
                      style: AppTextStyles.withColor(
                        AppTextStyles.bodyMedium,
                        AppColors.textPrimary,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.getSurfaceWithOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.separator.withOpacity(0.2),
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                    ),
                    const SizedBox(height: 16),
                    CupertinoTextField(
                      placeholder: 'Write your post...',
                      style: AppTextStyles.withColor(
                        AppTextStyles.bodyMedium,
                        AppColors.textPrimary,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.getSurfaceWithOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.separator.withOpacity(0.2),
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CupertinoButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        padding: EdgeInsets.zero,
                        child: Text(
                          'Post Topic',
                          style: AppTextStyles.withColor(
                            AppTextStyles.heading3,
                            AppColors.surface,
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
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class ForumTopic {
  final String title;
  final String author;
  final DateTime lastActivity;
  final int replies;
  final int likes;
  final List<String> tags;

  ForumTopic({
    required this.title,
    required this.author,
    required this.lastActivity,
    required this.replies,
    required this.likes,
    required this.tags,
  });
} 