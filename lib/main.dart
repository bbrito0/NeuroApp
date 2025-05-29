import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

import 'config/theme/app_colors.dart';
import 'core/utils/logging.dart';
import 'core/services/theme_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'core/services/language_service.dart';
// Import our new services
import 'core/services/user_profile_service.dart';
import 'core/services/feature_access_service.dart';
import 'core/services/wellness_score_service.dart';
// Import our clean app router
import 'app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initLogging();  // Initialize logging
  
  // Initialize services
  final themeService = ThemeService();
  await themeService.initialize();
  
  // Initialize language service
  final languageService = LanguageService();
  await languageService.initialize();
  
  // Initialize user profile service
  final userProfileService = UserProfileService();
  
  // Update system UI based on theme
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.surface,
      statusBarBrightness: themeService.statusBarBrightness,
      statusBarIconBrightness: themeService.statusBarIconBrightness,
    ),
  );

  // Initialize WebView Platform
  if (!kIsWeb) {  // Only check platform if not running on web
    if (Platform.isAndroid) {
      AndroidWebViewController.enableDebugging(true);
    }
  }

  // Update system UI based on theme
  if (Platform.isIOS) {
    try {
      final controller = WebViewController();
      await controller.clearCache();
      await controller.clearLocalStorage();
    } catch (e) {
      // Handle error or ignore
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeService),
        ChangeNotifierProvider.value(value: languageService),
        // Add our new services
        ChangeNotifierProvider.value(value: userProfileService),
        ProxyProvider<UserProfileService, FeatureAccessService>(
          update: (_, userService, __) => FeatureAccessService(userService),
        ),
        ProxyProvider<UserProfileService, WellnessScoreService>(
          update: (_, userService, __) => WellnessScoreService(userService),
        ),
      ],
      child: const ChronoWellApp(),
    ),
  );
}

class ChronoWellApp extends StatefulWidget {
  const ChronoWellApp({super.key});

  @override
  State<ChronoWellApp> createState() => _ChronoWellAppState();
}

class _ChronoWellAppState extends State<ChronoWellApp> {
  final ThemeService _themeService = ThemeService();
  
  @override
  void initState() {
    super.initState();
    // Listen for theme changes
    _themeService.addListener(_onThemeChanged);
  }
  
  @override
  void dispose() {
    _themeService.removeListener(_onThemeChanged);
    super.dispose();
  }
  
  void _onThemeChanged() {
    // Update system UI based on theme changes
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.surface,
        statusBarBrightness: _themeService.statusBarBrightness,
        statusBarIconBrightness: _themeService.statusBarIconBrightness,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Determine brightness based on theme
    final brightness = AppColors.currentTheme == ThemeMode.dark 
        ? Brightness.dark 
        : Brightness.light;
    
    // Get the language service
    final languageService = Provider.of<LanguageService>(context);
    
    return CupertinoApp.router(
      title: 'ChronoWell',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.surface,
        barBackgroundColor: AppColors.surface,
        textTheme: CupertinoTextThemeData(
          primaryColor: AppColors.textPrimary,
          textStyle: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      // Add localization settings
      locale: languageService.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: languageService.supportedLocales,
      // Use our clean GoRouter configuration
      routerConfig: AppRouter.router,
    );
  }
}
