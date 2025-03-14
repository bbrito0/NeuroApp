import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'screens/home_screen.dart';
import 'screens/my_hub_screen.dart';
import 'screens/ai_coach_screen.dart';
import 'screens/medical_screen.dart';
import 'screens/activities_screen.dart';
import 'screens/onboarding_screen.dart';
import 'theme/app_colors.dart';
import 'utils/logging.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initLogging();  // Initialize logging
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: CupertinoColors.systemBackground,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize WebView Platform
  if (!kIsWeb) {  // Only check platform if not running on web
    if (Platform.isAndroid) {
      AndroidWebViewController.enableDebugging(true);
    }
  }

  runApp(const NeuralApp());
}

class NeuralApp extends StatelessWidget {
  const NeuralApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Neural',
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        primaryColor: AppColors.primary,
        brightness: Brightness.light,
        scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
        barBackgroundColor: CupertinoColors.systemBackground,
      ),
      home: const OnboardingScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

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
