import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../services/user_profile_service.dart';
import '../../services/wellness_score_service.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../supplement_influenced_score_widget.dart' as score;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScoreCard extends StatelessWidget {
  final VoidCallback onProfileTap;

  const ProfileScoreCard({
    super.key,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.getSurfaceWithOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.getPrimaryWithOpacity(0.15),
            width: 0.5,
          ),
        ),
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Profile picture
            GestureDetector(
              onTap: onProfileTap,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.getPrimaryWithOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Consumer<UserProfileService>(
                    builder: (context, userProfileService, _) {
                      final user = userProfileService.currentUser;
                      final firstLetter = user.name.isNotEmpty ? user.name[0] : "U";
                      
                      return Text(
                        firstLetter,
                        style: AppTextStyles.withColor(
                          AppTextStyles.heading2,
                          AppColors.primary,
                        ),
                      );
                    }
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // User info
            Expanded(
              child: Consumer<UserProfileService>(
                builder: (context, userProfileService, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userProfileService.currentUser.name,
                        style: AppTextStyles.withColor(
                          AppTextStyles.heading3,
                          AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.capsule,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${userProfileService.ownedSupplements.length} ${localizations.activeSupplements}",
                            style: AppTextStyles.secondaryText,
                          ),
                        ],
                      ),
                    ],
                  );
                }
              ),
            ),
            // Score
            Consumer<UserProfileService>(
              builder: (context, userProfileService, _) {
                return Consumer<WellnessScoreService>(
                  builder: (context, wellnessScoreService, _) {
                    return SizedBox(
                      width: 70,
                      height: 50,
                      child: score.SupplementInfluencedScoreWidget(
                        size: score.ScoreWidgetSize.small,
                        userProfileService: userProfileService,
                        wellnessScoreService: wellnessScoreService,
                        showCategoryBreakdown: false,
                        showSupplementInfluence: false,
                      ),
                    );
                  }
                );
              }
            ),
          ],
        ),
      ),
    );
  }
} 