import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../models/supplement.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../datasources/static/wellness_scoring.dart';
import '../services/user_profile_service.dart';
import '../services/wellness_score_service.dart';
import 'cards/frosted_card.dart';

enum ScoreWidgetSize {
  small,  // For Home screen
  large,  // For MyHub screen
}

class SupplementInfluencedScoreWidget extends StatefulWidget {
  final ScoreWidgetSize size;
  final UserProfileService userProfileService;
  final WellnessScoreService wellnessScoreService;
  final bool showCategoryBreakdown;
  final bool showSupplementInfluence;
  
  const SupplementInfluencedScoreWidget({
    super.key,
    required this.userProfileService,
    required this.wellnessScoreService,
    this.size = ScoreWidgetSize.large,
    this.showCategoryBreakdown = true,
    this.showSupplementInfluence = true,
  });

  @override
  State<SupplementInfluencedScoreWidget> createState() => _SupplementInfluencedScoreWidgetState();
}

class _SupplementInfluencedScoreWidgetState extends State<SupplementInfluencedScoreWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scoreAnimation;
  int _score = 0;
  Map<String, int> _categoryScores = {};
  Map<String, int> _categoryWeights = {};
  Map<String, double> _supplementInfluence = {};
  bool _isInitialized = false;

  // Category color mapping - REVAMPED PALETTE
  final Map<String, Color> _categoryColors = {
    WellnessScoring.CATEGORY_CELLULAR_HEALTH: const Color(0xFF00A9B5), // Vibrant Teal
    WellnessScoring.CATEGORY_SLEEP: const Color.fromARGB(255, 85, 159, 216),           // Rich Indigo
    WellnessScoring.CATEGORY_STRESS: const Color(0xFFFF5D8F),          // Bright Magenta/Pink
    WellnessScoring.CATEGORY_COGNITIVE: const Color(0xFFFF9A5B),       // Warm Coral
    WellnessScoring.CATEGORY_ENERGY: const Color(0xFFFFD700),          // Keep vibrant Yellow (it works well)
    WellnessScoring.CATEGORY_IMMUNE: const Color(0xFF00D5A3),          // Lively Mint Green
  };

  // Category icon mapping
  final Map<String, IconData> _categoryIcons = {
    WellnessScoring.CATEGORY_CELLULAR_HEALTH: SFIcons.sf_heart,
    WellnessScoring.CATEGORY_SLEEP: SFIcons.sf_moon_fill,
    WellnessScoring.CATEGORY_STRESS: SFIcons.sf_waveform_path,
    WellnessScoring.CATEGORY_COGNITIVE: SFIcons.sf_brain,
    WellnessScoring.CATEGORY_ENERGY: SFIcons.sf_bolt,
    WellnessScoring.CATEGORY_IMMUNE: SFIcons.sf_shield,
  };

  @override
  void initState() {
    super.initState();
    
    // Create animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Initialize with current scores
    _updateScoreData();
    
    // Listen to user profile changes
    widget.userProfileService.addListener(_handleUserProfileChanged);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    widget.userProfileService.removeListener(_handleUserProfileChanged);
    super.dispose();
  }
  
  void _handleUserProfileChanged() {
    setState(() {
      _isInitialized = false;
    });
    _updateScoreData();
  }
  
  void _updateScoreData() {
    final oldScore = _score;
    
    // Calculate new scores
    final newScore = widget.wellnessScoreService.calculateOverallScore();
    final newCategoryScores = widget.wellnessScoreService.calculateAllCategoryScores();
    final newSupplementInfluence = widget.wellnessScoreService.getSupplementInfluence();
    
    // Get category weights from user's supplements
    final supplements = widget.userProfileService.getOwnedSupplements();
    final Map<String, int> newCategoryWeights = _calculateCombinedWeights(supplements);
    
    // Set up animation from old to new score
    _scoreAnimation = Tween<double>(
      begin: oldScore.toDouble(),
      end: newScore.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    
    // Update state with new data
    setState(() {
      _score = newScore;
      _categoryScores = newCategoryScores;
      _categoryWeights = newCategoryWeights;
      _supplementInfluence = newSupplementInfluence;
      _isInitialized = true;
    });
    
    // Run the animation
    _controller.forward(from: 0.0);
  }
  
  Map<String, int> _getEqualWeights() {
    final categories = WellnessScoring.getAllCategories();
    final equalWeight = 100 ~/ categories.length;
    
    final Map<String, int> weights = {};
    for (final category in categories) {
      weights[category] = equalWeight;
    }
    
    return weights;
  }

  Map<String, int> _calculateCombinedWeights(List<Supplement> supplements) {
    // Initialize all categories to 0
    final Map<String, int> combined = {};
    for (final category in WellnessScoring.getAllCategories()) {
      combined[category] = 0;
    }
    
    // If no supplements, return equal weights
    if (supplements.isEmpty) {
      return _getEqualWeights();
    }
    
    // Sum up weights from all supplements
    for (final supplement in supplements) {
      final profile = WellnessScoring.getWeightProfile(supplement.code);
      
      profile.forEach((category, weight) {
        combined[category] = (combined[category] ?? 0) + weight;
      });
    }
    
    // Normalize to ensure weights sum to 100
    int totalWeight = combined.values.fold(0, (a, b) => a + b);
    
    // Avoid division by zero
    if (totalWeight == 0) {
      return _getEqualWeights();
    } else {
      // Scale weights to maintain proportions but sum to 100
      combined.forEach((category, weight) {
        combined[category] = ((weight / totalWeight) * 100).round();
      });
    }
    
    return combined;
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = widget.size == ScoreWidgetSize.small;
    final double widgetSize = isSmall ? 80 : 260; // Compact size for small
    final double centerCircleSize = isSmall ? 45 : 150;
    final double scoreFontSize = isSmall ? 22 : 42;
    
    // Conditionally wrap with FrostedCard only for large size
    Widget scoreWidgetContent = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final displayScore = _isInitialized ? _scoreAnimation.value.round() : 0;
        
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: widgetSize,
              width: widgetSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Segmented ring
                  CustomPaint(
                    size: Size(widgetSize, widgetSize),
                    painter: ScoreRingPainter(
                      categoryWeights: _categoryWeights,
                      categoryColors: _categoryColors,
                      animationValue: _controller.value,
                      score: _score,
                      size: widget.size,
                    ),
                  ),
                  
                  // Center circle with score
                  Container(
                    width: centerCircleSize,
                    height: centerCircleSize,
                    decoration: BoxDecoration(
                      // Glossy/Metallic Gradient
                      gradient: RadialGradient(
                        center: const Alignment(0.0, -0.5), // Shift center up for top highlight
                        radius: 1.2, // Extend gradient slightly
                        colors: [
                          Colors.white.withValues(alpha: 0.9), // Bright center
                          const Color(0xFFF0F4F8),      // Light grey base
                          const Color(0xFFE3E8EE),      // Slightly darker edge
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        // Subtle border for definition
                        color: Colors.white.withValues(alpha: 0.7),
                        width: 0.75,
                      ),
                      boxShadow: [
                        BoxShadow(
                          // Softer, more realistic shadow
                          color: Colors.black.withValues(alpha: 0.15), // Less intense black
                          blurRadius: 25, // Larger blur for softness
                          spreadRadius: 0,  // No spread
                          offset: const Offset(0, 8), // Slightly more offset
                        ),
                         BoxShadow(
                          // Inner subtle glow/shadow (optional, adds depth)
                          color: AppColors.primary.withValues(alpha: 0.05), // Use primary color subtly
                          blurRadius: 10,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$displayScore',
                          style: TextStyle(
                            color: const Color(0xFF0F3449), // Darker, richer color
                            fontSize: scoreFontSize,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (!isSmall) ...[
                          const SizedBox(height: 4),
                          const Text(
                            'Overall Wellness Score',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF546E7A),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Only show these sections in large widget
            if (!isSmall && widget.showCategoryBreakdown) ...[
              const SizedBox(height: 24),
              _buildCategoryScoreList(context),
            ],
            
            if (!isSmall && widget.showSupplementInfluence && _supplementInfluence.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSupplementInfluence(context),
            ],
          ],
        );
      },
    );

    if (isSmall) {
      return scoreWidgetContent; // Return direct content for small size
    } else {
      // Wrap with FrostedCard for large size
      return Transform.translate(
        offset: const Offset(0, -2),
        child: FrostedCard(
          borderRadius: 20,
          backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.primaryCardOpacity),
          padding: const EdgeInsets.all(16), // Fixed padding for large
          border: Border.all(
            color: AppColors.getPrimaryWithOpacity(0.15),
            width: 0.5,
          ),
          shadows: AppColors.cardShadow,
          child: scoreWidgetContent,
        ),
      );
    }
  }
  
  Widget _buildCategoryScoreList(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: _categoryScores.entries.map((entry) {
        final category = entry.key;
        final score = entry.value;
        final color = _categoryColors[category] ?? AppColors.primary;
        final icon = _categoryIcons[category] ?? SFIcons.sf_circle;
        
        // Simplify category name
        final displayName = category == WellnessScoring.CATEGORY_CELLULAR_HEALTH
            ? 'Cellular'
            : category;
        
        return SizedBox(
          width: 85, // Maintain width
          child: Container( // Use Container for solid color and explicit decoration
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8), // Reduced vertical padding
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SFIcon(
                  icon,
                  fontSize: 18, // Back to original size
                  color: AppColors.surface, // Contrast color (white)
                ),
                const SizedBox(height: 4), // Reduced spacing
                Text(
                  score.toString(),
                  style: TextStyle(
                    color: AppColors.surface, // Contrast color
                    fontSize: 18, // Back to original size
                    fontWeight: FontWeight.w600, 
                  ),
                ),
                const SizedBox(height: 2), // Reduced spacing
                Text(
                  displayName,
                  style: TextStyle(
                    color: AppColors.surface.withValues(alpha: 0.8), // Lighter contrast color
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildSupplementInfluence(BuildContext context) {
    final supplements = widget.userProfileService.getOwnedSupplements();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Active Supplements",
          style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.secondaryLabel),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: supplements.map((supplement) {
            // Calculate percentage of influence
            final influence = _supplementInfluence[supplement.code] ?? 0;
            final percentage = (influence * 100).round();
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Tooltip(
                message: "${supplement.name}: $percentage%",
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: supplement.accentColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: supplement.accentColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      supplement.name.substring(0, 1),
                      style: TextStyle(
                        color: supplement.accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Custom painter for the segmented score ring
class ScoreRingPainter extends CustomPainter {
  final Map<String, int> categoryWeights;
  final Map<String, Color> categoryColors;
  final double animationValue;
  final int score;
  final double gapAngle; // Gap between inner segments
  final ScoreWidgetSize size; // Add size parameter

  ScoreRingPainter({
    required this.categoryWeights,
    required this.categoryColors,
    required this.animationValue,
    this.score = 0,
    this.gapAngle = 0.05, // Default gap angle (radians), adjust as needed
    required this.size,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final isSmall = this.size == ScoreWidgetSize.small;

    // Adjusted Radii and Thickness for compactness
    final double outerRingThickness;
    final double outerRingRadius;
    final double radius; // Base radius for large segments
    final double innerRadius; // Inner radius for large segments

    if (isSmall) {
      outerRingThickness = 4.5;
      // Calculate based on the actual center circle size (45) and desired gap (e.g., 2.0)
      const double centerCircleDiameter = 45.0;
      const double desiredGap = 2.0;
      outerRingRadius = (centerCircleDiameter / 2.0) + desiredGap + (outerRingThickness / 2.0);
      // These aren't used for painting in small, but need values
      radius = 0; 
      innerRadius = 0;
    } else {
      outerRingThickness = 8.0;
      const double outerRingOffset = 12;
      const double radiusFactor = 0.42;
      const double innerRadiusFactor = 0.70;
      radius = size.width * radiusFactor; 
      innerRadius = radius * innerRadiusFactor; 
      outerRingRadius = radius + outerRingOffset;
    }
    
    // Overall score for outer ring animation
    final totalScore = score.clamp(0, 100).toDouble(); 
    
    // Use all defined categories for consistent 6 segments
    final allCategories = WellnessScoring.getAllCategories(); 
    final numSegments = allCategories.length;
    if (numSegments == 0) return; // Prevent division by zero

    double currentAngle = -pi / 2; // Start from the top
    
    // Calculate fixed angle per segment
    final anglePerSegment = (2 * pi) / numSegments;

    // Draw segments with gaps
    if (this.size == ScoreWidgetSize.large) {
      for (final category in allCategories) {
        // Calculate sweep angle for this segment, apply animation and gap
        // Ensure gap scales with animation to appear correctly
        final animatedSegmentAngle = anglePerSegment * animationValue;
        final animatedGap = gapAngle * animationValue;
        final sweepAngle = animatedSegmentAngle - animatedGap;

        if (sweepAngle > 0) { // Only draw if segment has size
          final categoryColor = categoryColors[category] ?? Colors.grey;
          final paint = Paint()
            ..shader = RadialGradient( // More pronounced gradient
              colors: [
                _lighten(categoryColor, 0.2), // Lighter center
                categoryColor.withValues(alpha: 0.9), // Slightly darker edge
              ],
              stops: const [0.2, 1.0], // Adjust stops for more pronounced center
              center: Alignment.center,
            ).createShader(Rect.fromCircle(center: center, radius: radius))
            ..style = PaintingStyle.fill;
          
          // Define the path for the segment arc
          final path = Path()
            ..moveTo(center.dx + innerRadius * cos(currentAngle), center.dy + innerRadius * sin(currentAngle))
            ..arcTo(
              Rect.fromCircle(center: center, radius: radius),
              currentAngle,
              sweepAngle,
              false,
            )
            // Line back to inner radius end point
            ..lineTo(center.dx + innerRadius * cos(currentAngle + sweepAngle), center.dy + innerRadius * sin(currentAngle + sweepAngle))
            // Arc back along inner radius
            ..arcTo(
                Rect.fromCircle(center: center, radius: innerRadius),
                currentAngle + sweepAngle,
                -sweepAngle, // Draw inner arc backwards
                false,
            )
            ..close(); // Close the path for the segment shape

          canvas.drawPath(path, paint);
        }
        
        // Move start angle for the next segment, using the *full* animated segment angle (including gap part)
        currentAngle += animatedSegmentAngle; 
      }
      
      // --- Draw Borders (Inner/Outer of Segments) --- - Only for large display with segments
      final innerCirclePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      canvas.drawCircle(center, innerRadius, innerCirclePaint);
      
      final outerCirclePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      canvas.drawCircle(center, radius, outerCirclePaint);
    }
    
    // --- Re-add Outer Progress Ring --- 
    final progressAngle = 2 * pi * (totalScore / 100) * animationValue; // Apply animation to outer ring too
    
    // Base background for the outer ring 
    final backgroundPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = outerRingThickness // Use dynamic thickness
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRingRadius),
      -pi / 2,
      2 * pi, // Full circle
      false,
      backgroundPaint,
    );

    // Create a gradient that only spans the progress arc
    if (progressAngle > 1e-9) { 
      final gradientPaint = Paint()
        ..shader = SweepGradient(
          center: Alignment.center,
          startAngle: -pi / 2,
          endAngle: -pi / 2 + progressAngle,
          colors: [
            // Smoother gradient
            AppColors.primary.withValues(alpha: 0.7), // Start slightly transparent
            AppColors.primary,                  // End solid
          ],
          stops: const [0.0, 1.0], // Gradient stops
        ).createShader(Rect.fromCircle(center: center, radius: outerRingRadius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = outerRingThickness // Use dynamic thickness
        ..strokeCap = StrokeCap.round;
      
      // Draw the progress arc with gradient
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRingRadius),
        -pi/2, // Start from the top
        progressAngle,
        false,
        gradientPaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(ScoreRingPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.categoryWeights != categoryWeights;
  }
}



// Top-level helper to lighten a color
Color _lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
} 