import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/language_service.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';

class LanguageSelectorButton extends StatelessWidget {
  // UI Constants
  static const double horizontalPadding = 10.0;
  static const double verticalPadding = 6.0;
  static const double borderRadius = 12.0;
  static const double borderWidth = 0.5;
  static const double iconSize = 16.0;
  static const double iconSpacing = 8.0;
  static const double surfaceOpacity = 0.1;
  static const double borderOpacity = 0.2;
  
  const LanguageSelectorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final currentLang = languageService.locale.languageCode;
    
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        decoration: BoxDecoration(
          color: AppColors.getSurfaceWithOpacity(surfaceOpacity),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: AppColors.getPrimaryWithOpacity(borderOpacity),
            width: borderWidth,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SFIcon(
              SFIcons.sf_globe,
              fontSize: iconSize,
              color: AppColors.primary,
            ),
            const SizedBox(width: iconSpacing),
            Text(
              languageService.getDisplayLanguage(currentLang),
              style: AppTextStyles.withColor(
                AppTextStyles.bodySmall,
                AppColors.primary,
              ),
            ),
          ],
        ),
      ),
      onPressed: () => _showLanguageOptions(context, languageService),
    );
  }

  void _showLanguageOptions(BuildContext context, LanguageService languageService) {
    final localizations = AppLocalizations.of(context);
    
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(localizations.language),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              languageService.setLanguage('en');
              Navigator.pop(context);
            },
            child: Text(localizations.english),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              languageService.setLanguage('pt');
              Navigator.pop(context);
            },
            child: Text(localizations.portuguese),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: Text(localizations.cancel),
        ),
      ),
    );
  }
} 