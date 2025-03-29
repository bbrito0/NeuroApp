import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../main.dart';
import 'medical_record_screen.dart';
import 'supplement_quiz_screen.dart';
import '../widgets/widgets.dart';
import 'package:flutter_sficon/flutter_sficon.dart';

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
      navigationBar: CustomNavigationBar(
        title: 'Choose Your Supplements',
        subtitle: 'We will track and record your treatments and improve your health condition.\n',
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
                  const SizedBox(height: 0),
                  // Supplements list
                  Expanded(
                    child: FrostedCard(
                      borderRadius: 16,
                      backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                      border: Border.all(
                        color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
                        width: 0.5,
                      ),
                      padding: EdgeInsets.zero,
                      child: CupertinoScrollbar(
                        controller: _scrollController,
                        child: ListView.builder(
                          controller: _scrollController,
                          clipBehavior: Clip.none,
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
                          itemCount: _supplements.length,
                          itemBuilder: (context, index) {
                            return _buildSupplementCard(_supplements[index]);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Continue button
                  Column(
                    children: [
                      ActionButton(
                        text: 'Continue',
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
                        style: ActionButtonStyle.filled,
                        backgroundColor: const Color.fromARGB(255, 18, 162, 183),
                        textColor: AppColors.surface,
                        isFullWidth: true,
                        height: 56,
                        icon: Icon(
                          CupertinoIcons.arrow_right,
                          color: AppColors.surface,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // No supplement yet button
                      ActionButton(
                        text: "I don't have a supplement yet",
                        onPressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const SupplementQuizScreen(),
                            ),
                          );
                        },
                        style: ActionButtonStyle.outlined,
                        backgroundColor: Colors.transparent,
                        textColor: AppColors.surface,
                        isFullWidth: true,
                        height: 56,
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

  Widget _buildSupplementCard(Supplement supplement) {
    final isSelected = supplement.isSelected;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            supplement.isSelected = !supplement.isSelected;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.getSurfaceWithOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.getPrimaryWithOpacity(0.2),
              width: isSelected ? 2 : 0.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 24,
                          width: 4,
                          decoration: BoxDecoration(
                            color: supplement.accentColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          supplement.styledName,
                          style: AppTextStyles.withColor(
                            AppTextStyles.heading3,
                            isSelected ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Text(
                        supplement.benefits.join(' · '),
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodyMedium,
                          AppColors.secondaryLabel.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              SFIcon(
                SFIcons.sf_circle_circle_fill,
                fontSize: 20,
                color: isSelected 
                    ? AppColors.primary 
                    : AppColors.secondaryLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 