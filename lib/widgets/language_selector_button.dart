import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/language_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class LanguageSelectorButton extends StatelessWidget {
  const LanguageSelectorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final currentLang = languageService.locale.languageCode;
    
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.getSurfaceWithOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.getPrimaryWithOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SFIcon(
              SFIcons.sf_globe,
              fontSize: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
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
    final localizations = AppLocalizations.of(context)!;
    
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