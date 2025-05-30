import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../features/auth/data/services/auth_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _showLoginForm = false; // State to control login form visibility
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context, AuthService authService) async {
    final email = _usernameController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      // Show error for empty fields - we'll need to handle this differently
      print('DEBUG: Empty email or password');
      return;
    }

    print('DEBUG: Attempting login with email: $email');
    
    // Store the router before async operation
    final router = GoRouter.of(context);
    
    final user = await authService.signIn(email, password);

    print('DEBUG: Login result - User: ${user?.email ?? 'null'}');
    print('DEBUG: Auth service error: ${authService.errorMessage}');
    print('DEBUG: Is authenticated: ${authService.isAuthenticated}');

    if (user != null && mounted) {
      print('DEBUG: Login successful, user authenticated');
      // Login successful, the router will handle navigation automatically
      // due to our authentication guards
      router.go('/home');
    } else {
      print('DEBUG: Login failed - no user returned');
      // Error should already be set by AuthService
    }
  }

  void _handleForgotPassword(BuildContext context, AuthService authService) async {
    final email = _usernameController.text.trim();
    
    if (email.isEmpty) {
      // Could show a dialog asking for email
      return;
    }

    // Show a dialog to inform the user that this feature is not yet implemented
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text('Not Implemented'),
        content: const Text('Password reset functionality is not yet implemented.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, AppLocalizations localizations) {
    final authService = Provider.of<AuthService>(context);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Show error message if any
        if (authService.errorMessage != null)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CupertinoColors.destructiveRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: CupertinoColors.destructiveRed.withOpacity(0.3),
              ),
            ),
            child: Text(
              authService.errorMessage!,
              style: TextStyle(
                color: CupertinoColors.destructiveRed,
                fontSize: 14,
              ),
            ),
          ),
        
        // Username field
        CupertinoTextField(
          controller: _usernameController,
          placeholder: localizations.username,
          keyboardType: TextInputType.emailAddress,
          enabled: !authService.isLoading,
          style: AppTextStyles.withColor(AppTextStyles.bodyLarge, AppColors.surface),
          placeholderStyle: AppTextStyles.withColor(
            AppTextStyles.bodyLarge,
            AppColors.getColorWithOpacity(AppColors.surface, 0.6),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.getColorWithOpacity(Colors.white, 0.2),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        const SizedBox(height: 16),
        // Password field
        CupertinoTextField(
          controller: _passwordController,
          placeholder: localizations.password,
          obscureText: true,
          enabled: !authService.isLoading,
          style: AppTextStyles.withColor(AppTextStyles.bodyLarge, AppColors.surface),
          placeholderStyle: AppTextStyles.withColor(
            AppTextStyles.bodyLarge,
            AppColors.getColorWithOpacity(AppColors.surface, 0.6),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.getColorWithOpacity(Colors.white, 0.2),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        const SizedBox(height: 24),
        // Login and Cancel Buttons - Side by Side
        Row(
          children: [
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.getColorWithOpacity(Colors.white, 0.2),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: authService.isLoading ? null : () {
                    setState(() {
                      _showLoginForm = false;
                      _usernameController.clear();
                      _passwordController.clear();
                    });
                    authService.clearError();
                  },
                  child: Text(
                    localizations.cancel,
                    style: AppTextStyles.withColor(
                      AppTextStyles.bodyLarge,
                      AppColors.surface,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.getPrimaryWithOpacity(0.3), // Same style as register button
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: authService.isLoading ? null : () {
                    _handleLogin(context, authService);
                  },
                  child: authService.isLoading
                      ? const CupertinoActivityIndicator(color: Colors.white)
                      : Text(
                          localizations.loginAction, // Using new key
                          style: AppTextStyles.withColor(
                            AppTextStyles.bodyLarge,
                            AppColors.surface,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOriginalButtons(BuildContext context, AppLocalizations localizations) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Login Button
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.getColorWithOpacity(Colors.white, 0.2),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              setState(() {
                _showLoginForm = true; // Show the login form
              });
            },
            child: Text(
              localizations.login, // Original "Login" text
              style: AppTextStyles.withColor(
                AppTextStyles.bodyLarge,
                AppColors.surface,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // New User Button
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.getPrimaryWithOpacity(0.3),
            border: Border.all(
              color: AppColors.primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              context.goNamed('features-slideshow');
            },
            child: Text(
              localizations.newUser,
              style: AppTextStyles.withColor(
                AppTextStyles.bodyLarge,
                AppColors.surface,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Forgot Password Link
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            final authService = Provider.of<AuthService>(context, listen: false);
            _handleForgotPassword(context, authService);
          },
          child: Text(
            localizations.forgotPassword,
            style: AppTextStyles.withColor(
              AppTextStyles.bodyMedium,
              AppColors.getColorWithOpacity(AppColors.surface, 0.8),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/AI Health Assistant LOGIN SCREEN.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Fixed top spacing to keep logo in same position
                  const SizedBox(height: 120),
                  // Logo - Fixed position
                  Image.asset(
                    'assets/images/LogoWhite.png',
                    height: 120,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations.aiHealthAssistant,
                    style: AppTextStyles.withColor(
                      AppTextStyles.bodyMedium,
                      AppColors.getColorWithOpacity(AppColors.surface, 0.8),
                    ),
                  ),
                  // Fixed spacing before content
                  const SizedBox(height: 80),
                  
                  // Content area with smooth transitions
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              )),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: _showLoginForm
                              ? _buildLoginForm(context, localizations)
                              : _buildOriginalButtons(context, localizations),
                        ),
                      ],
                    ),
                  ),
                  
                  // Animated bottom spacing
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    height: _showLoginForm ? 140 : 60, // Always have some bottom spacing
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