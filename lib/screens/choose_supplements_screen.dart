import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../main.dart';
import 'medical_record_screen.dart';

class Supplement {
  final String name;
  final String styledName;
  final List<String> benefits;
  final Color accentColor;
  bool isSelected;

  Supplement({
    required this.name,
    required this.styledName,
    required this.benefits,
    required this.accentColor,
    this.isSelected = false,
  });
}

class _CustomNavigationBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  const _CustomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(20),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color.fromARGB(255, 0, 118, 169),
                Color.fromARGB(255, 18, 162, 183),
                Color.fromARGB(255, 92, 197, 217),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            border: Border(
              bottom: BorderSide(
                color: AppColors.getPrimaryWithOpacity(0.2),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: CupertinoNavigationBar(
                      backgroundColor: Colors.transparent,
                      border: null,
                      padding: const EdgeInsetsDirectional.only(start: 8),
                      leading: CupertinoNavigationBarBackButton(
                        color: AppColors.surface,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Choose Your Supplements',
                      style: AppTextStyles.withColor(
                        AppTextStyles.heading1,
                        AppColors.surface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'We will track and record your treatments and improve your health condition.',
                      style: AppTextStyles.withColor(
                        AppTextStyles.bodyMedium,
                        AppColors.surface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(160);

  @override
  bool shouldFullyObstruct(BuildContext context) => false;
}

class ChooseSupplementsScreen extends StatefulWidget {
  final String scannedCode;

  const ChooseSupplementsScreen({
    super.key,
    required this.scannedCode,
  });

  @override
  State<ChooseSupplementsScreen> createState() => _ChooseSupplementsScreenState();
}

class _ChooseSupplementsScreenState extends State<ChooseSupplementsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Alignment> _beginAlignment;
  late final Animation<Alignment> _endAlignment;
  final List<Supplement> _supplements = [
    Supplement(
      name: 'REVERSE',
      styledName: 'R · E · V · E · R · S · E',
      benefits: ['Rejuvenate', 'Revitalize', 'Renew'],
      accentColor: const Color(0xFF8A2BE2),
    ),
    Supplement(
      name: 'REVITA',
      styledName: 'R · E · V · I · T · A',
      benefits: ['Energize', 'Revitalize', 'Power'],
      accentColor: const Color(0xFFFF1493),
    ),
    Supplement(
      name: 'RESTORE',
      styledName: 'R · E · S · T · O · R · E',
      benefits: ['Focus', 'Boost', 'Prevent'],
      accentColor: const Color(0xFFFF8C00),
    ),
    Supplement(
      name: 'REGEN',
      styledName: 'R · E · G · E · N',
      benefits: ['Strengthen', 'Protect', 'Defend'],
      accentColor: const Color(0xFF4682B4),
    ),
    Supplement(
      name: 'RESET',
      styledName: 'R · E · S · E · T',
      benefits: ['Relax', 'Restore', 'Sleep'],
      accentColor: const Color(0xFFFFD700),
    ),
    Supplement(
      name: 'RECOVER',
      styledName: 'R · E · C · O · V · E · R',
      benefits: ['Restore', 'Sharpen', 'Prevent'],
      accentColor: const Color(0xFF4169E1),
    ),
    Supplement(
      name: 'RELAX',
      styledName: 'R · E · L · A · X',
      benefits: ['Calm', 'Soothe', 'Unwind'],
      accentColor: const Color(0xFF32CD32),
    ),
  ];
  final ScrollController _scrollController = ScrollController();

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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      navigationBar: _CustomNavigationBar(),
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
                  const SizedBox(height: 20),
                  // Supplements list
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
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
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
                              width: 0.5,
                            ),
                          ),
                          child: CupertinoScrollbar(
                            controller: _scrollController,
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(8),
                              itemCount: _supplements.length,
                              itemBuilder: (context, index) {
                                return _buildSupplementCard(_supplements[index]);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Continue button
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromARGB(255, 0, 118, 169),
                              Color.fromARGB(255, 18, 162, 183),
                              Color.fromARGB(255, 92, 197, 217),
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: _supplements.any((s) => s.isSelected)
                              ? () {
                                  // Navigate to medical record screen
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (context) => const MedicalRecordScreen(),
                                    ),
                                  );
                                }
                              : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continue',
                                style: AppTextStyles.withColor(
                                  AppTextStyles.heading3,
                                  AppColors.surface,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                CupertinoIcons.arrow_right,
                                color: AppColors.surface,
                                size: 20,
                              ),
                            ],
                          ),
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
    );
  }

  Widget _buildSupplementCard(Supplement supplement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            supplement.isSelected = !supplement.isSelected;
          });
        },
        child: Container(
          height: 100,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: supplement.accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            supplement.styledName,
                            style: AppTextStyles.withColor(
                              AppTextStyles.heading3,
                              AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            supplement.benefits.join(' · '),
                            style: AppTextStyles.withColor(
                              AppTextStyles.bodyMedium,
                              AppColors.secondaryLabel.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: supplement.isSelected 
                              ? AppColors.primary 
                              : AppColors.secondaryLabel.withOpacity(0.3),
                          width: 2,
                        ),
                        color: supplement.isSelected
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                      child: supplement.isSelected
                          ? Icon(
                              CupertinoIcons.checkmark,
                              size: 20,
                              color: AppColors.primary,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 