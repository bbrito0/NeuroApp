import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/widgets/widgets.dart';

// GoRouter imports
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // UI Constants
  static const double cardPadding = 16.0;
  static const double cardBorderRadius = 20.0;
  static const double cardMarginHorizontal = 16.0;
  static const double sectionSpacing = 20.0;
  static const double largeSpacing = 32.0;
  static const double itemSpacing = 16.0;
  static const double smallSpacing = 8.0;
  static const double tinySpacing = 2.0;
  static const double borderWidth = 0.5;
  static const double largeIconSize = 48.0;
  static const double mediumIconSize = 22.0;
  static const double smallIconSize = 16.0;
  static const double dividerHeight = 40.0;
  static const double signOutVerticalPadding = 14.0;
  static const double signOutBorderRadius = 12.0;
  static const double signOutBorderWidth = 1.0;
  static const double settingItemVerticalPadding = 12.0;
  
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
    final localizations = AppLocalizations.of(context);
    
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
                  onPressed: () => context.pop(),
                  child: const Icon(
                    CupertinoIcons.back,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildProfileHeader(localizations),
                    const SizedBox(height: sectionSpacing),
                    _buildStats(localizations),
                    const SizedBox(height: sectionSpacing),
                    _buildSettings(localizations),
                    const SizedBox(height: largeSpacing),
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
      padding: const EdgeInsets.symmetric(horizontal: cardMarginHorizontal),
      child: FrostedCard(
        borderRadius: cardBorderRadius,
        padding: const EdgeInsets.all(cardPadding),
        backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
        border: Border.all(
          color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
          width: borderWidth,
        ),
        child: Column(
          children: [
            const SFIcon(
              SFIcons.sf_person_circle,
              fontSize: largeIconSize,
              color: AppColors.primary,
            ),
            const SizedBox(height: smallSpacing),
            Text(
              'John Doe',
              style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
            ),
            const SizedBox(height: tinySpacing),
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
      padding: const EdgeInsets.symmetric(horizontal: cardMarginHorizontal),
      child: FrostedCard(
        borderRadius: cardBorderRadius,
        padding: const EdgeInsets.all(cardPadding),
        backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
        border: Border.all(
          color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
          width: borderWidth,
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
      height: dividerHeight,
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
      padding: const EdgeInsets.symmetric(horizontal: cardMarginHorizontal),
      child: FrostedCard(
        borderRadius: cardBorderRadius,
        padding: const EdgeInsets.all(cardPadding),
        backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
        border: Border.all(
          color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
          width: borderWidth,
        ),
        child: Column(
          children: [
            _buildSettingItem(
              title: localizations.accountSettings,
              icon: SFIcons.sf_person_fill,
              onTap: () {},
            ),
            const SizedBox(height: itemSpacing),
            _buildSettingItem(
              title: localizations.notifications,
              icon: SFIcons.sf_bell_fill,
              onTap: () {},
            ),
            const SizedBox(height: itemSpacing),
            _buildSettingItem(
              title: localizations.language,
              icon: SFIcons.sf_globe,
              onTap: () {},
              trailing: const LanguageSelectorButton(),
            ),
            const SizedBox(height: itemSpacing),
            _buildSettingItem(
              title: localizations.privacy,
              icon: SFIcons.sf_lock_fill,
              onTap: () {},
            ),
            const SizedBox(height: itemSpacing),
            _buildSettingItem(
              title: localizations.helpSupport,
              icon: SFIcons.sf_questionmark_circle_fill,
              onTap: () {},
            ),
            const SizedBox(height: itemSpacing + smallSpacing),
            // Sign Out Button
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                // Sign out and navigate to onboarding screen
                context.go('/onboarding');
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: signOutVerticalPadding),
                decoration: BoxDecoration(
                  color: AppColors.getColorWithOpacity(CupertinoColors.destructiveRed, 0.1),
                  borderRadius: BorderRadius.circular(signOutBorderRadius),
                  border: Border.all(
                    color: AppColors.getColorWithOpacity(CupertinoColors.destructiveRed, 0.3),
                    width: signOutBorderWidth,
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
        padding: const EdgeInsets.symmetric(vertical: settingItemVerticalPadding),
        decoration: BoxDecoration(
          border: showBorder
              ? Border(
                  bottom: BorderSide(
                    color: AppColors.getPrimaryWithOpacity(0.1),
                    width: borderWidth,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            SFIcon(
              icon,
              fontSize: mediumIconSize,
              color: AppColors.primary,
            ),
            const SizedBox(width: itemSpacing),
            Text(
              title,
              style: AppTextStyles.withColor(AppTextStyles.bodyLarge, AppColors.textPrimary),
            ),
            const Spacer(),
            if (trailing != null)
              trailing
            else
              const SFIcon(
                SFIcons.sf_chevron_right,
                fontSize: smallIconSize,
                color: AppColors.secondaryLabel,
              ),
          ],
        ),
      ),
    );
  }
} 