import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../services/tutorial_service.dart';

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
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.frostedGlassGradient,
              ),
            ),
          ),
          CupertinoScrollbar(
            thickness: 3.0,
            radius: const Radius.circular(1.5),
            mainAxisMargin: 2.0,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text(
                    'Profile',
                    style: AppTextStyles.withColor(AppTextStyles.heading1, AppColors.textPrimary),
                  ),
                  middle: Text(
                    'Profile',
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
                      _buildProfileHeader(),
                      const SizedBox(height: 20),
                      _buildStats(),
                      const SizedBox(height: 20),
                      _buildSettings(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                  AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
                width: 0.5,
              ),
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
                  'Training since Jan 2024',
                  style: AppTextStyles.secondaryText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                  AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistics',
                  style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem('Total Games', '156'),
                    const SizedBox(width: 8),
                    _buildStatItem('Best Score', '98'),
                    const SizedBox(width: 8),
                    _buildStatItem('Streak', '7 days'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.getPrimaryWithOpacity(AppColors.inactiveOpacity),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.primary),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.secondaryText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettings() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                  AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
                width: 0.5,
              ),
            ),
            child: Column(
              key: profileOverviewKey,
              children: [
                _buildSettingItem(
                  'Notifications',
                  SFIcons.sf_bell,
                  onTap: () {},
                ),
                _buildSettingItem(
                  'Dark Mode',
                  SFIcons.sf_moon,
                  onTap: () {},
                ),
                _buildSettingItem(
                  'Language',
                  SFIcons.sf_globe,
                  onTap: () {},
                ),
                _buildSettingItem(
                  'Privacy',
                  SFIcons.sf_lock,
                  onTap: () {},
                ),
                _buildSettingItem(
                  'Help & Support',
                  SFIcons.sf_questionmark_circle,
                  onTap: () {},
                  showBorder: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    IconData icon, {
    required VoidCallback onTap,
    bool showBorder = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: showBorder
              ? Border(
                  bottom: BorderSide(
                    color: AppColors.separator,
                    width: 0.5,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            SFIcon(
              icon,
              fontSize: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.textPrimary),
            ),
            const Spacer(),
            SFIcon(
              SFIcons.sf_chevron_right,
              fontSize: 12,
              color: AppColors.getPrimaryWithOpacity(AppColors.inactiveOpacity),
            ),
          ],
        ),
      ),
    );
  }
} 