import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'theme/app_colors.dart';
import 'theme/app_text_styles.dart';
import 'screens/home_screen.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'main.dart';
import 'widgets/widgets.dart';

class FinalizeAccountScreen extends StatefulWidget {
  const FinalizeAccountScreen({super.key});

  @override
  State<FinalizeAccountScreen> createState() => _FinalizeAccountScreenState();
}

class _FinalizeAccountScreenState extends State<FinalizeAccountScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Alignment> _beginAlignment;
  late final Animation<Alignment> _endAlignment;

  int _currentStep = 1;
  final int _totalSteps = 2;

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
      });
    } else {
      _showSuccessDialog();
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _showSuccessDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          'Account Created',
          style: AppTextStyles.bodyLarge,
        ),
        content: Text(
          'Your account has been created successfully!',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              'Continue',
              style: AppTextStyles.bodyMedium,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (context) => const MainScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String placeholder,
    required TextEditingController controller,
    bool isPassword = false,
    String? prefixText,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.getPrimaryWithOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.getPrimaryWithOpacity(0.2),
              width: 0.5,
            ),
          ),
          child: CupertinoTextField(
            controller: controller,
            placeholder: placeholder,
            prefix: prefixText != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      prefixText,
                      style: AppTextStyles.bodyMedium,
                    ),
                  )
                : null,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            style: AppTextStyles.bodyMedium,
            placeholderStyle: AppTextStyles.secondaryText,
            obscureText: isPassword && !_showPassword,
            suffix: isPassword
                ? CupertinoButton(
                    padding: const EdgeInsets.only(right: 16),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    child: Icon(
                      _showPassword
                          ? CupertinoIcons.eye_slash_fill
                          : CupertinoIcons.eye_fill,
                      color: AppColors.secondaryLabel,
                      size: 20,
                    ),
                  )
                : null,
            decoration: null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      navigationBar: CustomNavigationBar(
        currentStep: _currentStep,
        totalSteps: _totalSteps,
        title: 'Create Account',
        subtitle: 'Complete your profile to get started with personalized health recommendations.',
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      child: Stack(
        children: [
          // Animated background with frosted glass effect
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
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.frostedGlassGradient,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Expanded(
                    child: FrostedCard(
                      borderRadius: 16,
                      padding: const EdgeInsets.all(24),
                      backgroundColor: Colors.white.withOpacity(0.8),
                      border: Border.all(
                        color: AppColors.getPrimaryWithOpacity(0.2),
                        width: 0.5,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: AppColors.primarySurfaceGradient(startOpacity: 0.2, endOpacity: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SFIcon(
                                    _currentStep == 1 ? SFIcons.sf_person_fill : SFIcons.sf_lock_fill,
                                    fontSize: 12,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Step ${_currentStep} of $_totalSteps',
                                    style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            if (_currentStep == 1) ...[
                              Text(
                                'Personal Information',
                                style: AppTextStyles.heading2,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Please enter your name and email address',
                                style: AppTextStyles.secondaryText,
                              ),
                              const SizedBox(height: 24),
                              _buildTextField(
                                placeholder: 'Full Name',
                                controller: _nameController,
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                placeholder: 'Email',
                                controller: _emailController,
                              ),
                            ] else ...[
                              Text(
                                'Set Password',
                                style: AppTextStyles.heading2,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Create a secure password for your account',
                                style: AppTextStyles.secondaryText,
                              ),
                              const SizedBox(height: 24),
                              _buildTextField(
                                placeholder: 'Password',
                                controller: _passwordController,
                                isPassword: true,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      if (_currentStep > 1)
                        Expanded(
                          child: ActionButton(
                            text: 'Back',
                            onPressed: _previousStep,
                            style: ActionButtonStyle.filled,
                            backgroundColor: Colors.white.withOpacity(0.7),
                            textColor: AppColors.primary,
                            isFullWidth: true,
                            height: 56,
                            borderRadius: 16,
                          ),
                        ),
                      if (_currentStep > 1)
                        const SizedBox(width: 16),
                      Expanded(
                        child: ActionButton(
                          text: _currentStep == _totalSteps ? 'Create Account' : 'Next',
                          onPressed: () {
                            if (_currentStep == 1 && (_nameController.text.isEmpty || _emailController.text.isEmpty)) {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  title: Text(
                                    'Incomplete Information',
                                    style: AppTextStyles.bodyLarge,
                                  ),
                                  content: Text(
                                    'Please fill in all fields to continue.',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text(
                                        'OK',
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }
                            if (_currentStep == 2 && _passwordController.text.isEmpty) {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  title: Text(
                                    'Password Required',
                                    style: AppTextStyles.bodyLarge,
                                  ),
                                  content: Text(
                                    'Please enter a password to continue.',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text(
                                        'OK',
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }
                            if (_currentStep == _totalSteps) {
                              Navigator.of(context).pushAndRemoveUntil(
                                CupertinoPageRoute(
                                  builder: (context) => const MainScreen(),
                                ),
                                (route) => false,
                              );
                            } else {
                              _nextStep();
                            }
                          },
                          style: ActionButtonStyle.filled,
                          backgroundColor: AppColors.primary,
                          textColor: AppColors.surface,
                          isFullWidth: true,
                          height: 56,
                          borderRadius: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 