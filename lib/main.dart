import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:flutter/material.dart' as material show ThemeMode;
import 'screens/home_screen.dart';
import 'screens/my_hub_screen.dart';
import 'screens/ai_coach_screen.dart';
import 'screens/medical_screen.dart';
import 'screens/activities_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/onboarding_features_slideshow.dart';
import 'theme/app_colors.dart';
import 'utils/logging.dart';
import 'services/theme_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:flutter/material.dart' show Colors, MaterialLocalizations;
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'services/language_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initLogging();  // Initialize logging
  
  // Initialize services
  final themeService = ThemeService();
  await themeService.initialize();
  
  // Initialize language service
  final languageService = LanguageService();
  await languageService.initialize();
  
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
      ],
      child: const NeuralApp(),
    ),
  );
}

class NeuralApp extends StatefulWidget {
  const NeuralApp({super.key});

  @override
  State<NeuralApp> createState() => _NeuralAppState();
}

class _NeuralAppState extends State<NeuralApp> {
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
    final brightness = AppColors.currentTheme == material.ThemeMode.dark 
        ? Brightness.dark 
        : Brightness.light;
    
    // Get the language service
    final languageService = Provider.of<LanguageService>(context);
    
    return CupertinoApp(
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
      home: const OnboardingScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  final bool isLimitedMode;
  
  const MainScreen({super.key, this.isLimitedMode = false});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final CupertinoTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = CupertinoTabController(initialIndex: 0);
    // Ensure HomeScreen is built after the MainScreen is fully initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  
  Widget build(BuildContext context) {
  return CupertinoTabScaffold(
    controller: _tabController,
    tabBar: CupertinoTabBar(
      height: 50,
      iconSize: 20,
      backgroundColor: AppColors.getSurfaceWithOpacity(0.8),
      activeColor: AppColors.primary,
      inactiveColor: AppColors.inactive.withOpacity(AppColors.inactiveOpacity),
      border: null,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Center(
            child: Padding(
              padding: EdgeInsets.only(right: 7.0),
              child: Icon(SFIcons.sf_house_fill),
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Center(
            child: Padding(
              padding: EdgeInsets.only(right: 2.0),
              child: Icon(SFIcons.sf_square_grid_2x2_fill),
            ),
          ),
          label: 'My Hub',
        ),
        BottomNavigationBarItem(
          icon: Center(
            child: Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: Icon(SFIcons.sf_brain_head_profile),
            ),
          ),
          label: 'AI Coach',
        ),
        BottomNavigationBarItem(
          icon: Center(
            child: Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: Icon(SFIcons.sf_square_stack_3d_up_fill),
            ),
          ),
          label: 'Activities',
        ),
        BottomNavigationBarItem(
          icon: Center(
            child: Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: Icon(SFIcons.sf_cross_case),
            ),
          ),
          label: 'Medical',
        ),
      ],
    ),
    tabBuilder: (context, index) {
      return CupertinoTabView(
        builder: (context) {
          switch (index) {
            case 0:
              return HomeScreen(tabController: _tabController);
            case 1:
              return MyHubScreen(tabController: _tabController);
            case 2:
              return AICoachScreen(tabController: _tabController);
            case 3:
              return ActivitiesScreen(tabController: _tabController);
            case 4:
              return MedicalScreen(tabController: _tabController);
            default:
              return HomeScreen(tabController: _tabController);
          }
        },
      );
    },
  );
  }
}
