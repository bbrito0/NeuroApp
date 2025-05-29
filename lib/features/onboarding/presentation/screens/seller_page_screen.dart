import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';

class SellerPageScreen extends StatefulWidget {
  final String recommendedSupplement;
  
  const SellerPageScreen({
    super.key,
    this.recommendedSupplement = 'REVITA',
  });

  @override
  State<SellerPageScreen> createState() => _SellerPageScreenState();
}

class _SellerPageScreenState extends State<SellerPageScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Alignment> _beginAlignment;
  late final Animation<Alignment> _endAlignment;
  
  // UI Constants
  static const double circleSize = 120.0;
  static const double standardPadding = 24.0;
  static const double cardBorderRadius = 16.0;
  static const double cardPadding = 20.0;
  static const double borderWidth = 0.5;
  static const double iconSize = 16.0;
  static const double smallIconSize = 8.0;
  static const double standardSpacing = 24.0;
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const Duration animationDuration = Duration(seconds: 20);
  
  final Map<String, Map<String, dynamic>> _supplements = {
    'REVITA': {
      'name': 'REVITA',
      'styledName': 'R · E · V · I · T · A',
      'description': 'Premium cognitive enhancement supplement designed to boost mental clarity, focus, and memory.',
      'benefits': [
        'Enhanced mental focus and clarity',
        'Improved memory retention',
        'Reduced mental fatigue',
        'Balanced mood and stress response',
        'Supports overall brain health'
      ],
      'ingredients': [
        'Bacopa Monnieri',
        'Lion\'s Mane Mushroom',
        'Alpha-GPC',
        'Phosphatidylserine',
        'Vitamin B Complex'
      ],
      'price': '\$59.99',
      'rating': 4.8,
      'reviews': 127,
      'bgColor': const Color(0xFFFF1493),
    },
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: animationDuration,
      vsync: this,
    )..repeat();

    _beginAlignment = AlignmentTween(
      begin: const Alignment(-1.0, -1.0),
      end: const Alignment(1.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _endAlignment = AlignmentTween(
      begin: const Alignment(0.0, 0.0),
      end: const Alignment(2.0, 2.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToCodeScanner() {
    context.goNamed('code-scanner');
  }

  void _navigateToLimitedFeatures() {
    // Navigate to home with limited mode - this would be handled by the app state
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final supplement = _supplements[widget.recommendedSupplement]!;
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      navigationBar: CustomNavigationBar(
        title: 'Recommended for You',
        subtitle: 'Based on your quiz responses',
        onBackPressed: () => context.pop(),
      ),
      child: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: _beginAlignment.value,
                    end: _endAlignment.value,
                    colors: AppColors.primaryGradient.colors,
                    tileMode: TileMode.mirror,
                  ),
                ),
              );
            },
          ),
          // Frosted glass effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.frostedGlassGradient,
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(standardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product header
                          Center(
                            child: Container(
                              width: circleSize,
                              height: circleSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.getColorWithOpacity(supplement['bgColor'], 0.7),
                                    AppColors.getColorWithOpacity(supplement['bgColor'], 0.3),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  supplement['name'].toString().substring(0, 1),
                                  style: AppTextStyles.withColor(
                                    const TextStyle(
                                      fontSize: 72,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: mediumSpacing),
                          Center(
                            child: Text(
                              supplement['styledName'],
                              style: AppTextStyles.withColor(
                                AppTextStyles.heading1,
                                AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  supplement['rating'].toString(),
                                  style: AppTextStyles.withColor(
                                    AppTextStyles.bodyMedium,
                                    AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: smallSpacing / 2),
                                const SFIcon(
                                  SFIcons.sf_star_fill,
                                  color: Color(0xFFFFD700),
                                  fontSize: 16,
                                ),
                                const SizedBox(width: smallSpacing / 2),
                                Text(
                                  '(${supplement['reviews']} reviews)',
                                  style: AppTextStyles.secondaryText,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Product description
                          FrostedCard(
                            borderRadius: cardBorderRadius,
                            backgroundColor: AppColors.getSurfaceWithOpacity(0.2),
                            padding: const EdgeInsets.all(cardPadding),
                            border: Border.all(
                              color: AppColors.getPrimaryWithOpacity(0.2),
                              width: borderWidth,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description',
                                  style: AppTextStyles.withColor(
                                    AppTextStyles.heading3,
                                    AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  supplement['description'],
                                  style: AppTextStyles.bodyMedium,
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Key Benefits',
                                  style: AppTextStyles.withColor(
                                    AppTextStyles.heading3,
                                    AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...List.generate(
                                  (supplement['benefits'] as List).length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(bottom: smallSpacing),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SFIcon(
                                          SFIcons.sf_checkmark_circle_fill,
                                          color: supplement['bgColor'],
                                          fontSize: iconSize,
                                        ),
                                        const SizedBox(width: smallSpacing),
                                        Expanded(
                                          child: Text(
                                            supplement['benefits'][index],
                                            style: AppTextStyles.bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: standardSpacing),
                                Text(
                                  'Key Ingredients',
                                  style: AppTextStyles.withColor(
                                    AppTextStyles.heading3,
                                    AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...List.generate(
                                  (supplement['ingredients'] as List).length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(bottom: smallSpacing),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SFIcon(
                                          SFIcons.sf_circle_fill,
                                          color: supplement['bgColor'],
                                          fontSize: smallIconSize,
                                        ),
                                        const SizedBox(width: smallSpacing),
                                        Expanded(
                                          child: Text(
                                            supplement['ingredients'][index],
                                            style: AppTextStyles.bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: standardSpacing),
                          
                          // Price card
                          FrostedCard(
                            borderRadius: cardBorderRadius,
                            backgroundColor: AppColors.getSurfaceWithOpacity(0.2),
                            padding: const EdgeInsets.all(cardPadding),
                            border: Border.all(
                              color: AppColors.getPrimaryWithOpacity(0.2),
                              width: borderWidth,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Price:',
                                  style: AppTextStyles.bodyMedium,
                                ),
                                Text(
                                  supplement['price'],
                                  style: AppTextStyles.withColor(
                                    AppTextStyles.heading2,
                                    supplement['bgColor'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: standardSpacing),
                  
                  // Action buttons
                  Column(
                    children: [
                      ActionButton(
                        text: 'Purchase Product',
                        onPressed: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: const Text('External Store'),
                              content: const Text(
                                'This will take you to an external store to complete your purchase.',
                              ),
                              actions: [
                                CupertinoDialogAction(
                                  child: const Text('Cancel'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  child: const Text('Continue'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // Show a success dialog with option to scan code
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (context) => CupertinoAlertDialog(
                                        title: const Text('Thank You!'),
                                        content: const Text(
                                          'Your order has been placed. Once you receive your product, scan the code to unlock all features.',
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: const Text('Continue with Limited Features'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _navigateToLimitedFeatures();
                                            },
                                          ),
                                          CupertinoDialogAction(
                                            isDefaultAction: true,
                                            child: const Text('Scan Product Code'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _navigateToCodeScanner();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        style: ActionButtonStyle.filled,
                        backgroundColor: supplement['bgColor'],
                        textColor: AppColors.surface,
                        isFullWidth: true,
                      ),
                      const SizedBox(height: smallSpacing + 4),
                      ActionButton(
                        text: 'Continue with Limited Features',
                        onPressed: _navigateToLimitedFeatures,
                        style: ActionButtonStyle.outlined,
                        backgroundColor: Colors.transparent,
                        textColor: AppColors.surface,
                        isFullWidth: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 