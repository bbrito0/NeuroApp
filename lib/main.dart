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
import 'package:flutter/material.dart' show Colors;
import 'theme/app_colors.dart';

void main() {
  // Force portrait orientation
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFF7F6F9), // Light background
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
      title: 'NeuroApp',
      theme: const CupertinoThemeData(
        primaryColor: AppColors.primary,
        brightness: Brightness.light,
        scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
        barBackgroundColor: CupertinoColors.systemBackground,
        textTheme: CupertinoTextThemeData(
          // Primary text style (body)
          textStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 17,
            letterSpacing: -0.41,
            color: AppColors.textPrimary,
            height: 1.294,
          ),
          // Navigation bar title
          navTitleTextStyle: TextStyle(
            fontFamily: '.SF Pro Display',
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.41,
            color: AppColors.textPrimary,
          ),
          // Large navigation bar title
          navLargeTitleTextStyle: TextStyle(
            fontFamily: '.SF Pro Display',
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.41,
            color: AppColors.textPrimary,
          ),
          // Tab bar items
          tabLabelTextStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 11,
            letterSpacing: -0.24,
            color: AppColors.textPrimary,
          ),
          actionTextStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 17,
            letterSpacing: -0.41,
            color: AppColors.primary,
          ),
          pickerTextStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 21,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.31,
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late final CupertinoTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = CupertinoTabController(initialIndex: 0);
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
        backgroundColor: AppColors.getSurfaceWithOpacity(0.5),
        activeColor: AppColors.primary,
        inactiveColor: AppColors.inactive.withOpacity(AppColors.inactiveOpacity),
        border: null,
        items: [
          _buildTabItem(SFIcons.sf_house_fill, 'Home'),
          _buildTabItem(SFIcons.sf_square_grid_2x2_fill, 'My Hub'),
          _buildTabItem(SFIcons.sf_brain_head_profile, 'AI Coach'),
          _buildTabItem(SFIcons.sf_square_stack_3d_up_fill, 'Activities'),
          _buildTabItem(SFIcons.sf_cross_case, 'Medical'),
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

  BottomNavigationBarItem _buildTabItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        size: 20,
      ),
      label: label,
    );
  }
} 