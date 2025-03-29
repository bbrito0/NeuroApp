import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../services/tutorial_service.dart';
import '../widgets/widgets.dart';
import '../widgets/language_selector_button.dart';
import '../screens/onboarding_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.tabController,
  });

  final CupertinoTabController tabController;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ScrollController _scrollController;

  // Single key for the tutorial
  final GlobalKey profileOverviewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Show tutorial when the screen is first built if enabled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (TutorialService.shouldShowTutorial(TutorialService.PROFILE_TUTORIAL)) {
        _showTutorial();
        TutorialService.markTutorialAsShown(TutorialService.PROFILE_TUTORIAL);
      }
    });
  }

  void _showTutorial() {
    TutorialService.createProfileTutorial(
      context,
      [profileOverviewKey],
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
    final localizations = AppLocalizations.of(context)!;
    
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
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                  localizations.profile,
                  style: AppTextStyles.withColor(AppTextStyles.heading1, AppColors.textPrimary),
                ),
                middle: Text(
                  localizations.profile,
                  style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                ),
                alwaysShowMiddle: false,
                backgroundColor: Colors.transparent,
                border: null,
                stretch: false,
                automaticallyImplyLeading: false,
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Icon(
                    CupertinoIcons.back,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildProfileHeader(localizations),
                    const SizedBox(height: 20),
                    _buildStats(localizations),
                    const SizedBox(height: 20),
                    _buildSettings(localizations),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FrostedCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(16),
        backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
        border: Border.all(
          color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
          width: 0.5,
        ),
        child: Column(
          children: [
            SFIcon(
              SFIcons.sf_person_circle,
              fontSize: 48,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              'John Doe',
              style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
            ),
            const SizedBox(height: 2),
            Text(
              localizations.trainingLabel,
              style: AppTextStyles.secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FrostedCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(16),
        backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
        border: Border.all(
          color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
          width: 0.5,
        ),
        child: Row(
          key: profileOverviewKey,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(localizations.daysLabel, '28'),
            _buildStatDivider(),
            _buildStatItem(localizations.challengesLabel, '12'),
            _buildStatDivider(),
            _buildStatItem(localizations.meditationsLabel, '23'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.getPrimaryWithOpacity(0.1),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.withColor(AppTextStyles.heading2, AppColors.primary),
        ),
        Text(
          label,
          style: AppTextStyles.secondaryText,
        ),
      ],
    );
  }

  Widget _buildSettings(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FrostedCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(16),
        backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
        border: Border.all(
          color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
          width: 0.5,
        ),
        child: Column(
          children: [
            _buildSettingItem(
              title: localizations.accountSettings,
              icon: SFIcons.sf_person_fill,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              title: localizations.notifications,
              icon: SFIcons.sf_bell_fill,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              title: localizations.language,
              icon: SFIcons.sf_globe,
              onTap: () {},
              trailing: const LanguageSelectorButton(),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              title: localizations.privacy,
              icon: SFIcons.sf_lock_fill,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              title: localizations.helpSupport,
              icon: SFIcons.sf_questionmark_circle_fill,
              onTap: () {},
            ),
            const SizedBox(height: 24),
            // Sign Out Button
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                // Sign out and navigate to onboarding screen
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  CupertinoPageRoute(
                    builder: (context) => const OnboardingScreen(),
                  ),
                  (route) => false, // Remove all previous routes
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: CupertinoColors.destructiveRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CupertinoColors.destructiveRed.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Sign Out",
                    style: AppTextStyles.withColor(
                      AppTextStyles.withWeight(AppTextStyles.bodyMedium, FontWeight.w600),
                      CupertinoColors.destructiveRed,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool showBorder = true,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: showBorder
              ? Border(
                  bottom: BorderSide(
                    color: AppColors.getPrimaryWithOpacity(0.1),
                    width: 0.5,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            SFIcon(
              icon,
              fontSize: 22,
              color: AppColors.primary,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: AppTextStyles.withColor(AppTextStyles.bodyLarge, AppColors.textPrimary),
            ),
            const Spacer(),
            if (trailing != null)
              trailing
            else
              SFIcon(
                SFIcons.sf_chevron_right,
                fontSize: 16,
                color: AppColors.secondaryLabel,
              ),
          ],
        ),
      ),
    );
  }
} 