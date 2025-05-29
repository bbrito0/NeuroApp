import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'dart:math' show pi, sin;
import 'package:flutter/material.dart' show Colors;
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';

// GoRouter imports
import 'package:go_router/go_router.dart';

class ArticleDetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final String readTime;

  const ArticleDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.readTime,
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  // UI Constants
  static const double standardPadding = 24.0;
  static const double mediumSpacing = 16.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Premium Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.appBackgroundGradient,
            ),
          ),
          // Frosted Glass Overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.frostedGlassGradient,
              ),
            ),
          ),
          // Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                  'Article',
                  style: AppTextStyles.adaptive(AppTextStyles.heading1),
                ),
                middle: Text(
                  'Article',
                  style: AppTextStyles.adaptive(AppTextStyles.heading2),
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
                  padding: const EdgeInsets.all(standardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Article Header
                      _buildArticleHeader(context),
                      const SizedBox(height: mediumSpacing),
                      // Article Content
                      _buildArticleSection(
                        context,
                        'Introduction',
                        'Memory is a fundamental aspect of cognitive function that plays a crucial role in our daily lives. Whether you\'re studying for an exam, learning a new skill, or simply trying to remember where you left your keys, having a strong memory can make a significant difference.',
                      ),
                      _buildArticleSection(
                        context,
                        'Key Techniques',
                        '1. Active Recall: Test yourself regularly instead of passively reviewing information.\n\n'
                        '2. Spaced Repetition: Review information at increasing intervals.\n\n'
                        '3. Mind Mapping: Create visual representations of information.\n\n'
                        '4. The Memory Palace: Associate information with familiar locations.',
                      ),
                      _buildArticleSection(
                        context,
                        'Practice Tips',
                        '• Start with small chunks of information\n'
                        '• Use multiple senses when learning\n'
                        '• Create meaningful associations\n'
                        '• Get adequate sleep and exercise\n'
                        '• Stay mentally active with puzzles and games',
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArticleHeader(BuildContext context) {
    return FrostedCard(
      hierarchy: CardHierarchy.primary,
      borderRadius: 20.0,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.getPrimaryWithOpacity(0.2),
                      AppColors.getPrimaryWithOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Featured',
                  style: AppTextStyles.withColor(
                    AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                widget.readTime,
                style: AppTextStyles.adaptive(
                  AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  isPrimary: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.title,
            style: AppTextStyles.adaptive(AppTextStyles.heading1),
          ),
          const SizedBox(height: 8),
          Text(
            widget.description,
            style: AppTextStyles.adaptive(
              AppTextStyles.bodyMedium.copyWith(height: 1.3),
              isPrimary: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: mediumSpacing),
      child: FrostedCard(
        hierarchy: CardHierarchy.secondary,
        borderRadius: 20.0, 
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.adaptive(AppTextStyles.heading2),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: AppTextStyles.adaptive(
                AppTextStyles.bodyMedium.copyWith(height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  WavePainter({
    required this.animation,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFE8E8EA),
        Color(0xFFE2E2E4),
      ],
    );
    
    final backgroundPaint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, backgroundPaint);

    final wavePaint = Paint()
      ..color = AppColors.getColorWithOpacity(const Color(0xFFD8D8DA), 0.45)
      ..style = PaintingStyle.fill;

    final path = Path();
    final path2 = Path();
    final path3 = Path();

    for (var i = 0; i < size.width; i++) {
      final x = i.toDouble();
      final dx = (x / size.width);
      final sin1 = sin((dx * 2 * pi) + (animation.value * 2 * pi));
      final y = sin1 * 25 + size.height * 0.5;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    wavePaint.color = AppColors.getColorWithOpacity(const Color(0xFFD0D0D2), 0.35);
    for (var i = 0; i < size.width; i++) {
      final x = i.toDouble();
      final dx = (x / size.width);
      final sin2 = sin((dx * 2 * pi) + (animation.value * 2 * pi) + pi / 4);
      final y = sin2 * 20 + size.height * 0.6;
      if (i == 0) {
        path2.moveTo(x, y);
      } else {
        path2.lineTo(x, y);
      }
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    wavePaint.color = AppColors.getColorWithOpacity(const Color(0xFFC8C8CA), 0.25);
    for (var i = 0; i < size.width; i++) {
      final x = i.toDouble();
      final dx = (x / size.width);
      final sin3 = sin((dx * 2 * pi) + (animation.value * 2 * pi) - pi / 4);
      final y = sin3 * 8 + size.height * 0.8;
      if (i == 0) {
        path3.moveTo(x, y);
      } else {
        path3.lineTo(x, y);
      }
    }
    path3.lineTo(size.width, size.height);
    path3.lineTo(0, size.height);
    path3.close();

    canvas.drawPath(path, wavePaint);
    canvas.drawPath(path2, wavePaint);
    canvas.drawPath(path3, wavePaint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
} 