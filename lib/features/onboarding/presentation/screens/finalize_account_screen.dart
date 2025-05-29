import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Custom navigation bar for the finalize account screen with step indicators.
/// 
/// Shows progress through the account creation process and provides
/// consistent navigation UI across the finalization flow.
class _CustomNavigationBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  // Constants
  static const double _borderRadius = 20.0;
  static const double _blurSigma = 8.0;
  static const double _borderWidth = 0.5;
  static const double _navBarBottomPadding = 12.0;
  static const double _topPadding = 8.0;
  static const double _smallSpacing = 4.0;
  static const double _mediumSpacing = 8.0;
  static const double _horizontalPadding = 16.0;
  static const double _indicatorWidth = 24.0;
  static const double _indicatorHeight = 4.0;
  static const double _indicatorMargin = 2.0;
  static const double _indicatorRadius = 2.0;
  
  final int currentStep;
  final int totalSteps;

  const _CustomNavigationBar({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(_borderRadius),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
        child: Container(
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
            border: Border(
              bottom: BorderSide(
                color: AppColors.getPrimaryWithOpacity(0.2),
                width: _borderWidth,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: _navBarBottomPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: _topPadding),
                    child: CupertinoNavigationBar(
                      backgroundColor: Colors.transparent,
                      border: null,
                      padding: const EdgeInsetsDirectional.only(start: _mediumSpacing),
                      leading: CupertinoNavigationBarBackButton(
                        color: AppColors.surface,
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ),
                  const SizedBox(height: _smallSpacing),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
                    child: Text(
                      AppLocalizations.of(context).createAccount,
                      style: AppTextStyles.withColor(
                        AppTextStyles.heading1,
                        AppColors.surface,
                      ),
                    ),
                  ),
                  const SizedBox(height: _mediumSpacing),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
                    child: Text(
                      AppLocalizations.of(context).completeProfile,
                      style: AppTextStyles.withColor(
                        AppTextStyles.bodyMedium,
                        AppColors.surface,
                      ),
                    ),
                  ),
                  const SizedBox(height: _mediumSpacing),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        totalSteps,
                        (index) => Container(
                          width: _indicatorWidth,
                          height: _indicatorHeight,
                          margin: const EdgeInsets.symmetric(horizontal: _indicatorMargin),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(_indicatorRadius),
                            color: index + 1 == currentStep
                                ? AppColors.surface
                                : AppColors.getColorWithOpacity(AppColors.surface, 0.3),
                          ),
                        ),
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

class FinalizeAccountScreen extends StatefulWidget {
  const FinalizeAccountScreen({super.key});

  @override
  State<FinalizeAccountScreen> createState() => _FinalizeAccountScreenState();
}

class _FinalizeAccountScreenState extends State<FinalizeAccountScreen>
    with SingleTickerProviderStateMixin {
  // Constants
  static const double _standardPadding = 24.0;
  static const double _mediumPadding = 16.0;
  static const double _smallPadding = 12.0;
  static const double _largeSpacing = 24.0;
  static const double _mediumSpacing = 16.0;
  static const double _smallSpacing = 8.0;
  static const double _borderRadius = 16.0;
  static const double _smallBorderRadius = 12.0;
  static const double _chipBorderRadius = 8.0;
  static const double _borderWidth = 0.5;
  static const double _blurSigma = 8.0;
  static const double _largeBlurSigma = 60.0;
  static const double _buttonHeight = 56.0;
  static const double _iconSize = 20.0;
  static const double _smallIconSize = 12.0;
  static const Duration _animationDuration = Duration(seconds: 20);
  
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
      duration: _animationDuration,
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
    final localizations = AppLocalizations.of(context);
    
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          localizations.accountCreated,
          style: AppTextStyles.bodyLarge,
        ),
        content: Text(
          localizations.accountCreatedSuccessfully,
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              localizations.continueText,
              style: AppTextStyles.bodyMedium,
            ),
            onPressed: () {
              context.pop(); // Close dialog
              // Navigate to home screen to complete onboarding
              context.go('/home');
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
      borderRadius: BorderRadius.circular(_smallBorderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.getPrimaryWithOpacity(0.3),
            borderRadius: BorderRadius.circular(_smallBorderRadius),
            border: Border.all(
              color: AppColors.getPrimaryWithOpacity(0.2),
              width: _borderWidth,
            ),
          ),
          child: CupertinoTextField(
            controller: controller,
            placeholder: placeholder,
            prefix: prefixText != null
                ? Padding(
                    padding: const EdgeInsets.only(left: _mediumPadding),
                    child: Text(
                      prefixText,
                      style: AppTextStyles.bodyMedium,
                    ),
                  )
                : null,
            padding: const EdgeInsets.symmetric(horizontal: _mediumPadding, vertical: _smallPadding),
            style: AppTextStyles.bodyMedium,
            placeholderStyle: AppTextStyles.secondaryText,
            obscureText: isPassword && !_showPassword,
            suffix: isPassword
                ? CupertinoButton(
                    padding: const EdgeInsets.only(right: _mediumPadding),
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
                      size: _iconSize,
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
    final localizations = AppLocalizations.of(context);
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      navigationBar: _CustomNavigationBar(
        currentStep: _currentStep,
        totalSteps: _totalSteps,
      ),
      child: Stack(
        children: [
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
            filter: ImageFilter.blur(sigmaX: _largeBlurSigma, sigmaY: _largeBlurSigma),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.frostedGlassGradient,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: _standardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: _largeSpacing),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_borderRadius),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
                        child: Container(
                          padding: const EdgeInsets.all(_standardPadding),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.getColorWithOpacity(Colors.white, 0.8),
                                AppColors.getColorWithOpacity(Colors.white, 0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(_borderRadius),
                            border: Border.all(
                              color: AppColors.getPrimaryWithOpacity(0.2),
                              width: _borderWidth,
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: _smallPadding, vertical: 6),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primarySurfaceGradient(startOpacity: 0.2, endOpacity: 0.2),
                                    borderRadius: BorderRadius.circular(_chipBorderRadius),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SFIcon(
                                        _currentStep == 1 ? SFIcons.sf_person_fill : SFIcons.sf_lock_fill,
                                        fontSize: _smallIconSize,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        localizations.stepCount(_currentStep.toString(), _totalSteps.toString()),
                                        style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.primary),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: _largeSpacing),
                                if (_currentStep == 1) ...[
                                  Text(
                                    localizations.personalInformation,
                                    style: AppTextStyles.heading2,
                                  ),
                                  const SizedBox(height: _smallSpacing),
                                  Text(
                                    localizations.enterNameEmail,
                                    style: AppTextStyles.secondaryText,
                                  ),
                                  const SizedBox(height: _largeSpacing),
                                  _buildTextField(
                                    placeholder: localizations.fullName,
                                    controller: _nameController,
                                  ),
                                  const SizedBox(height: _mediumSpacing),
                                  _buildTextField(
                                    placeholder: localizations.email,
                                    controller: _emailController,
                                  ),
                                ] else ...[
                                  Text(
                                    localizations.setPassword,
                                    style: AppTextStyles.heading2,
                                  ),
                                  const SizedBox(height: _smallSpacing),
                                  Text(
                                    localizations.createPassword,
                                    style: AppTextStyles.secondaryText,
                                  ),
                                  const SizedBox(height: _largeSpacing),
                                  _buildTextField(
                                    placeholder: localizations.password,
                                    controller: _passwordController,
                                    isPassword: true,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: _largeSpacing),
                  Row(
                    children: [
                      if (_currentStep > 1)
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(_borderRadius),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
                              child: Container(
                                height: _buttonHeight,
                                decoration: BoxDecoration(
                                  color: AppColors.getColorWithOpacity(Colors.white, 0.7),
                                  borderRadius: BorderRadius.circular(_borderRadius),
                                  border: Border.all(
                                    color: AppColors.getColorWithOpacity(Colors.white, 0.2),
                                    width: _borderWidth,
                                  ),
                                ),
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: _previousStep,
                                  child: Text(
                                    localizations.back,
                                    style: AppTextStyles.withColor(
                                      AppTextStyles.heading3,
                                      AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (_currentStep > 1)
                        const SizedBox(width: _mediumSpacing),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(_borderRadius),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
                            child: Container(
                              height: _buttonHeight,
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
                                borderRadius: BorderRadius.circular(_borderRadius),
                                border: Border.all(
                                  color: AppColors.getColorWithOpacity(Colors.white, 0.2),
                                  width: _borderWidth,
                                ),
                              ),
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  if (_currentStep == 1 && (_nameController.text.isEmpty || _emailController.text.isEmpty)) {
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (context) => CupertinoAlertDialog(
                                        title: Text(
                                          localizations.incompleteInformation,
                                          style: AppTextStyles.bodyLarge,
                                        ),
                                        content: Text(
                                          localizations.fillAllFields,
                                          style: AppTextStyles.bodyMedium,
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: Text(
                                              localizations.ok,
                                              style: AppTextStyles.bodyMedium,
                                            ),
                                            onPressed: () => context.pop(),
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
                                          localizations.incompleteInformation,
                                          style: AppTextStyles.bodyLarge,
                                        ),
                                        content: Text(
                                          localizations.fillAllFields,
                                          style: AppTextStyles.bodyMedium,
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: Text(
                                              localizations.ok,
                                              style: AppTextStyles.bodyMedium,
                                            ),
                                            onPressed: () => context.pop(),
                                          ),
                                        ],
                                      ),
                                    );
                                    return;
                                  }
                                  if (_currentStep == _totalSteps) {
                                    // Complete account creation and navigate to home
                                    context.go('/home');
                                  } else {
                                    _nextStep();
                                  }
                                },
                                child: Text(
                                  _currentStep == _totalSteps ? localizations.createAccount : localizations.next,
                                  style: AppTextStyles.withColor(
                                    AppTextStyles.heading3,
                                    AppColors.surface,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: _mediumSpacing),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 