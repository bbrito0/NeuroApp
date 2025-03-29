import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/widgets.dart';
import 'code_scanner_screen.dart';
import '../main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostMedicalDecisionScreen extends StatefulWidget {
  const PostMedicalDecisionScreen({super.key});

  @override
  State<PostMedicalDecisionScreen> createState() => _PostMedicalDecisionScreenState();
}

class _PostMedicalDecisionScreenState extends State<PostMedicalDecisionScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Alignment> _beginAlignment;
  late final Animation<Alignment> _endAlignment;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
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
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const CodeScannerScreen(),
      ),
    );
  }

  void _navigateToLimitedFeatures() {
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => MainScreen(key: UniqueKey(), isLimitedMode: true),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      navigationBar: CustomNavigationBar(
        title: 'Complete Setup',
        subtitle: 'Choose how you want to proceed with ChronoWell',
        onBackPressed: () => Navigator.of(context).pop(),
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  // Decision Cards
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Scan Product Code Option
                        _buildOptionCard(
                          title: 'Scan Product Code',
                          description: 'Unlock all premium features by scanning your supplement code',
                          icon: SFIcons.sf_qrcode,
                          color: AppColors.primary,
                          onTap: _navigateToCodeScanner,
                        ),
                        const SizedBox(height: 24),
                        // Limited Features Option
                        _buildOptionCard(
                          title: 'Continue with Limited Features',
                          description: 'Access basic features without a product code',
                          icon: SFIcons.sf_star,
                          color: const Color(0xFF8A2BE2),
                          isOutlined: true,
                          onTap: _navigateToLimitedFeatures,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Note about features
                  FrostedCard(
                    borderRadius: 16,
                    backgroundColor: AppColors.getSurfaceWithOpacity(0.2),
                    padding: const EdgeInsets.all(16),
                    border: Border.all(
                      color: AppColors.getPrimaryWithOpacity(0.2),
                      width: 0.5,
                    ),
                    child: Row(
                      children: [
                        SFIcon(
                          SFIcons.sf_info_circle_fill,
                          color: AppColors.primary,
                          fontSize: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            localizations.premiumFeaturesDescription,
                            style: AppTextStyles.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    bool isOutlined = false,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: FrostedCard(
        borderRadius: 20,
        backgroundColor: isOutlined 
            ? Colors.transparent 
            : color.withOpacity(0.1),
        padding: const EdgeInsets.all(24),
        border: Border.all(
          color: isOutlined 
              ? color.withOpacity(0.5) 
              : color,
          width: isOutlined ? 1 : 2,
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
              ),
              child: Center(
                child: SFIcon(
                  icon,
                  fontSize: 40,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.withColor(
                AppTextStyles.heading2,
                color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: AppTextStyles.secondaryText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 