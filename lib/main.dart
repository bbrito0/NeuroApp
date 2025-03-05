import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'screens/home_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/resources_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/challenges_screen.dart';

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
        primaryColor: Color(0xFFA7D8D7),
        brightness: Brightness.light,
        scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
        barBackgroundColor: CupertinoColors.systemBackground,
        textTheme: CupertinoTextThemeData(
          // Primary text style (body)
          textStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 17,
            letterSpacing: -0.41,
            color: CupertinoColors.label,
            height: 1.294,
          ),
          // Navigation bar title
          navTitleTextStyle: TextStyle(
            fontFamily: '.SF Pro Display',
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.41,
            color: CupertinoColors.label,
          ),
          // Large navigation bar title
          navLargeTitleTextStyle: TextStyle(
            fontFamily: '.SF Pro Display',
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.41,
            color: CupertinoColors.label,
          ),
          // Tab bar items
          tabLabelTextStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 11,
            letterSpacing: -0.24,
            color: CupertinoColors.label,
          ),
          actionTextStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 17,
            letterSpacing: -0.41,
            color: Color(0xFF007AFF),
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
    final primaryColor = const Color(0xFF30B0C7);
    
    return Stack(
      children: [
        CupertinoTabScaffold(
          controller: _tabController,
          tabBar: CupertinoTabBar(
            height: 65,
            backgroundColor: CupertinoColors.systemBackground.withOpacity(0.7),
            activeColor: primaryColor,
            inactiveColor: CupertinoColors.systemGrey.withOpacity(0.8),
            border: const Border(
              top: BorderSide(
                color: Color(0xFF30B0C7),
                width: 0.5,
                style: BorderStyle.solid,
              ),
            ),
            items: [
              _buildTabItem(CupertinoIcons.house_fill, 'Home'),
              _buildTabItem(CupertinoIcons.graph_circle_fill, 'Progress'),
              const BottomNavigationBarItem(icon: Icon(null), label: ''),
              _buildTabItem(CupertinoIcons.book_fill, 'Resources'),
              _buildTabItem(CupertinoIcons.person_fill, 'Profile'),
            ],
          ),
          tabBuilder: (context, index) {
            // Adjust index to account for the center button
            final adjustedIndex = index > 2 ? index - 1 : index;
            return CupertinoTabView(
              builder: (context) {
                switch (adjustedIndex) {
                  case 0:
                    return HomeScreen(tabController: _tabController);
                  case 1:
                    return ProgressScreen(tabController: _tabController);
                  case 2:
                    return ResourcesScreen(tabController: _tabController);
                  case 3:
                    return ProfileScreen(tabController: _tabController);
                  default:
                    return HomeScreen(tabController: _tabController);
                }
              },
            );
          },
        ),
        // Centered brain logo with glass effect
        Positioned(
          bottom: 4,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                  builder: (context) => const ChallengesScreen(),
                  title: 'Challenges',
                  fullscreenDialog: true,
                  maintainState: true,
                  allowSnapshotting: true,
                ),
              );
            },
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primaryColor.withOpacity(0.9),
                          primaryColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      CupertinoIcons.lightbulb_fill,
                      color: CupertinoColors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildTabItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Icon(icon),
      ),
      label: label,
    );
  }
} 