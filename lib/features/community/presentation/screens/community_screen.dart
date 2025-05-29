import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/widgets/widgets.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  // UI Constants
  static const double standardPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double borderWidth = 0.5;
  static const double searchRadius = 10.0;
  static const double tagRadius = 16.0;
  static const double iconSize = 22.0;
  static const double smallIconSize = 16.0;
  static const double tagHeight = 32.0;
  static const double tagPaddingHorizontal = 12.0;
  static const double tagPaddingVertical = 6.0;
  static const double sectionSpacing = 24.0;
  static const double itemSpacing = 16.0;
  static const double modalBorderRadius = 20.0;
  static const double blurAmount = 8.0;
  static const double modalHeightFactor = 0.75;
  static const double textFieldRadius = 10.0;
  static const double textFieldPadding = 12.0;
  
  late List<ForumTopic> _topics;
  late List<String> _tags;
  
  late ScrollController _scrollController;

  // Add GlobalKeys for tutorial targets
  final GlobalKey searchKey = GlobalKey();
  final GlobalKey tagsKey = GlobalKey();
  final GlobalKey topicKey = GlobalKey();
  final GlobalKey newPostKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Show tutorial when the screen is first built if enabled and not shown before
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (TutorialService.shouldShowTutorial(TutorialService.COMMUNITY_TUTORIAL)) {
        _showTutorial();
        TutorialService.markTutorialAsShown(TutorialService.COMMUNITY_TUTORIAL);
      }
    });
  }

  void _showTutorial() {
    TutorialService.createCommunityTutorial(
      context,
      [searchKey, tagsKey, topicKey, newPostKey],
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
    
    // Initialize tags with localized strings
    _tags = [
      localizations.tagMemory,
      localizations.tagTraining,
      localizations.tagHealth,
      localizations.tagTips,
      localizations.tagProgress
    ];
    
    // Initialize topics with localized strings
    _topics = [
      ForumTopic(
        title: "Memory Techniques Discussion",
        author: "Sarah M.",
        lastActivity: DateTime.now().subtract(const Duration(minutes: 5)),
        replies: 12,
        likes: 45,
        tags: [localizations.tagMemory, localizations.tagTips],
      ),
      ForumTopic(
        title: "Daily Brain Training Results",
        author: "Michael R.",
        lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
        replies: 8,
        likes: 23,
        tags: [localizations.tagProgress, localizations.tagTraining],
      ),
      ForumTopic(
        title: "Cognitive Health Tips",
        author: "Dr. Emily K.",
        lastActivity: DateTime.now().subtract(const Duration(hours: 6)),
        replies: 15,
        likes: 67,
        tags: [localizations.tagHealth, localizations.tagExpert],
      ),
    ];
    
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
                  localizations.community,
                  style: AppTextStyles.withColor(
                    AppTextStyles.heading1,
                    AppColors.textPrimary,
                  ),
                ),
                backgroundColor: AppColors.getSurfaceWithOpacity(0.7),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.getColorWithOpacity(AppColors.separator, 0.2),
                    width: borderWidth,
                  ),
                ),
                trailing: CupertinoButton(
                  key: newPostKey,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _showNewTopicSheet(context);
                  },
                  child: const SFIcon(
                    SFIcons.sf_square_and_pencil,
                    fontSize: iconSize,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(standardPadding),
                  child: Column(
                    children: [
                      CustomTextField(
                        key: searchKey,
                        hintText: localizations.searchTopics,
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: smallPadding),
                          child: SFIcon(
                            SFIcons.sf_magnifyingglass,
                            fontSize: smallIconSize,
                            color: AppColors.secondaryLabel,
                          ),
                        ),
                        borderRadius: searchRadius,
                      ),
                      const SizedBox(height: itemSpacing),
                      SizedBox(
                        key: tagsKey,
                        height: tagHeight,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _tags.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: index == 0 ? 0 : smallPadding,
                                right: index == _tags.length - 1 ? 0 : 0,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: tagPaddingHorizontal, 
                                  vertical: tagPaddingVertical
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.getPrimaryWithOpacity(0.1),
                                  borderRadius: BorderRadius.circular(tagRadius),
                                  border: Border.all(
                                    color: AppColors.getPrimaryWithOpacity(0.1),
                                    width: borderWidth,
                                  ),
                                ),
                                child: Text(
                                  _tags[index],
                                  style: AppTextStyles.withColor(
                                    AppTextStyles.bodySmall,
                                    AppColors.primary,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: sectionSpacing),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(
                    key: index == 0 ? topicKey : null,
                    child: _buildTopicCard(_topics[index]),
                  ),
                  childCount: _topics.length,
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(bottom: 100),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(ForumTopic topic) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: standardPadding, vertical: smallPadding),
      child: FrostedCard(
        borderRadius: tagRadius,
        backgroundColor: AppColors.getSurfaceWithOpacity(0.7),
        border: Border.all(
          color: AppColors.getColorWithOpacity(AppColors.separator, 0.3),
          width: 0.1,
        ),
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            // Navigate to topic detail
          },
          child: Padding(
            padding: const EdgeInsets.all(standardPadding),
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
                    const SizedBox(width: smallPadding + 4),
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
                const SizedBox(height: smallPadding + 4),
                Text(
                  topic.title,
                  style: AppTextStyles.withColor(
                    AppTextStyles.heading3,
                    AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: smallPadding + 4),
                Row(
                  children: [
                    ...topic.tags.map((tag) => Container(
                          margin: const EdgeInsets.only(right: smallPadding),
                          padding: const EdgeInsets.symmetric(
                            horizontal: smallPadding,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.getPrimaryWithOpacity(0.1),
                            borderRadius: BorderRadius.circular(smallPadding),
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
                const SizedBox(height: smallPadding + 4),
                Row(
                  children: [
                    Row(
                      children: [
                        const SFIcon(
                          SFIcons.sf_bubble_right,
                          fontSize: smallIconSize,
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
                    const SizedBox(width: itemSpacing),
                    Row(
                      children: [
                        const SFIcon(
                          SFIcons.sf_heart,
                          fontSize: smallIconSize,
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
    final localizations = AppLocalizations.of(context);
    
    showCupertinoModalPopup(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          height: MediaQuery.of(context).size.height * modalHeightFactor,
          decoration: BoxDecoration(
            color: AppColors.getSurfaceWithOpacity(0.98),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(modalBorderRadius),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(standardPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        localizations.cancelButton,
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodyMedium,
                          AppColors.primary,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      localizations.createTopic,
                      style: AppTextStyles.withColor(
                        AppTextStyles.heading3,
                        AppColors.textPrimary,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        localizations.post,
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodyMedium,
                          AppColors.primary,
                        ),
                      ),
                      onPressed: () {
                        // Post logic
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: borderWidth,
                color: AppColors.getColorWithOpacity(AppColors.separator, 0.2),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(standardPadding),
                  child: Column(
                    children: [
                      CupertinoTextField(
                        placeholder: localizations.topicTitle,
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodyMedium,
                          AppColors.textPrimary,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.getSurfaceWithOpacity(0.5),
                          borderRadius: BorderRadius.circular(textFieldRadius),
                          border: Border.all(
                            color: AppColors.getColorWithOpacity(AppColors.separator, 0.2),
                          ),
                        ),
                        padding: const EdgeInsets.all(textFieldPadding),
                      ),
                      const SizedBox(height: itemSpacing),
                      CupertinoTextField(
                        placeholder: localizations.writeYourPost,
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodyMedium,
                          AppColors.textPrimary,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.getSurfaceWithOpacity(0.5),
                          borderRadius: BorderRadius.circular(textFieldRadius),
                          border: Border.all(
                            color: AppColors.getColorWithOpacity(AppColors.separator, 0.2),
                          ),
                        ),
                        padding: const EdgeInsets.all(textFieldPadding),
                        maxLines: 5,
                      ),
                      const SizedBox(height: sectionSpacing),
                    ],
                  ),
                ),
              ),
            ],
          ),
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