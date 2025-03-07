import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'dart:ui';
import 'screens/home_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/resources_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/challenges_screen.dart';
import 'screens/meditation_screen.dart';
import 'screens/my_hub_screen.dart';
import 'screens/ai_coach_screen.dart';
import 'screens/medical_screen.dart';
import 'screens/activities_screen.dart';
import 'screens/onboarding_screen.dart';
import 'package:flutter/material.dart' show Colors;
import 'theme/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: CupertinoColors.systemBackground,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(SFIcons.sf_house_fill),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(SFIcons.sf_square_grid_2x2_fill),
            label: 'My Hub'
          ),
          BottomNavigationBarItem(
            icon: Icon(SFIcons.sf_brain_head_profile),
            label: 'AI Coach'
          ),
          BottomNavigationBarItem(
            icon: Icon(SFIcons.sf_square_stack_3d_up_fill),
            label: 'Activities'
          ),
          BottomNavigationBarItem(
            icon: Icon(SFIcons.sf_cross_case),
            label: 'Medical'
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