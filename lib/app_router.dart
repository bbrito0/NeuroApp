import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Services
import 'features/auth/data/services/auth_service.dart';

// Screens imports
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/onboarding/presentation/screens/onboarding_features_slideshow.dart';
import 'features/onboarding/presentation/screens/code_scanner_screen.dart';
import 'features/onboarding/presentation/screens/supplement_quiz_screen.dart';
import 'features/onboarding/presentation/screens/seller_page_screen.dart';
import 'features/onboarding/presentation/screens/supplement_details_screen.dart';
import 'features/onboarding/presentation/screens/medical_record_screen.dart';
import 'features/onboarding/presentation/screens/choose_supplements_screen.dart';
import 'features/onboarding/presentation/screens/setup_loading_screen.dart';
import 'features/onboarding/presentation/screens/post_medical_decision_screen.dart';
import 'features/onboarding/presentation/screens/finalize_account_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/activities/presentation/screens/activities_screen.dart';
import 'features/ai_coach/presentation/screens/ai_coach_screen.dart';
import 'features/medical/presentation/screens/medical_screen.dart';
import 'features/my_hub/presentation/screens/my_hub_screen.dart';

// TODO: Remove tabController dependency from these screens:
// import 'features/home/presentation/screens/home_screen.dart';
// import 'features/my_hub/presentation/screens/my_hub_screen.dart';
// import 'features/ai_coach/presentation/screens/ai_coach_screen.dart';
// import 'features/medical/presentation/screens/medical_screen.dart';
// import 'features/activities/presentation/screens/activities_screen.dart';

// Sub-feature screens for nested navigation
import 'features/challenges/presentation/screens/challenges_screen.dart';
import 'features/meditations/presentation/screens/meditation_screen.dart';
import 'features/meditations/presentation/screens/meditation_session_screen.dart';
import 'features/resources/presentation/screens/resources_screen.dart';
import 'features/article_detail/presentation/screens/article_detail_screen.dart';
import 'features/community/presentation/screens/community_screen.dart';
import 'features/user_profile_management/presentation/screens/profile_screen.dart';
import 'features/progress/presentation/screens/progress_screen.dart';
import 'features/auth/presentation/screens/api_test_screen.dart';

// Configuration
import 'config/theme/app_colors.dart';

// SF Icons
import 'package:flutter_sficon/flutter_sficon.dart';

/// Clean, organized GoRouter configuration following best practices
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  /// The single source of truth for navigation
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/onboarding',
    redirect: _handleGlobalRedirects,
    routes: _buildRoutes(),
    errorBuilder: _buildErrorScreen,
  );

  /// Build all application routes
  static List<RouteBase> _buildRoutes() => [
        // 1. ONBOARDING FLOW
        _buildOnboardingRoutes(),
        
        // 2. MAIN APP with STATEFUL SHELL (Tab Navigation)
        _buildMainAppShell(),
        
        // 3. GLOBAL ROUTES (accessible from anywhere)
        GoRoute(
          path: '/article-detail',
          name: AppRoutes.articleDetail,
          builder: (context, state) {
            final title = state.uri.queryParameters['title'] ?? 'Article';
            final description = state.uri.queryParameters['description'] ?? 'Article description';
            final readTime = state.uri.queryParameters['readTime'] ?? '5 min read';
            
            return ArticleDetailScreen(
              title: title,
              description: description,
              readTime: readTime,
            );
          },
        ),
        
        GoRoute(
          path: '/community',
          name: AppRoutes.community,
          builder: (context, state) => const CommunityScreen(),
        ),
        
        GoRoute(
          path: '/profile',
          name: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
        
        GoRoute(
          path: '/progress',
          name: AppRoutes.progress,
          builder: (context, state) => const ProgressScreen(),
        ),
        
        // Debug/Test routes
        GoRoute(
          path: '/api-test',
          name: AppRoutes.apiTest,
          builder: (context, state) => const ApiTestScreen(),
        ),
      ];

  /// Onboarding route tree
  static GoRoute _buildOnboardingRoutes() => GoRoute(
        path: '/onboarding',
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
        routes: [
          // Features slideshow
          GoRoute(
            path: '/features-slideshow',
            name: AppRoutes.featuresSlideshow,
            builder: (context, state) => const OnboardingFeaturesSlideshow(),
          ),
          
          // Code scanner
          GoRoute(
            path: '/code-scanner',
            name: AppRoutes.codeScanner,
            builder: (context, state) => const CodeScannerScreen(),
          ),
          
          // Supplement quiz
          GoRoute(
            path: '/supplement-quiz',
            name: AppRoutes.supplementQuiz,
            builder: (context, state) => const SupplementQuizScreen(),
          ),
          
          // Seller page with recommended supplement parameter
          GoRoute(
            path: '/seller-page/:supplement',
            name: AppRoutes.sellerPage,
            builder: (context, state) {
              final supplement = state.pathParameters['supplement'] ?? 'REVITA';
              return SellerPageScreen(recommendedSupplement: supplement);
            },
          ),
          
          // Supplement details with code parameter
          GoRoute(
            path: '/supplement-details/:code',
            name: AppRoutes.supplementDetails,
            builder: (context, state) {
              final code = state.pathParameters['code'] ?? 'dev-test-code';
              return SupplementDetailsScreen(scannedCode: code);
            },
          ),
          
          // Medical record screen
          GoRoute(
            path: '/medical-record',
            name: AppRoutes.medicalRecord,
            builder: (context, state) => const MedicalRecordScreen(),
          ),
          
          // Choose supplements screen
          GoRoute(
            path: '/choose-supplements',
            name: AppRoutes.chooseSupplements,
            builder: (context, state) => const ChooseSupplementsScreen(
              scannedCode: 'default-code',
            ),
          ),
          
          // Setup loading screen
          GoRoute(
            path: '/setup-loading',
            name: AppRoutes.setupLoading,
            builder: (context, state) => const SetupLoadingScreen(),
          ),
          
          // Post medical decision screen
          GoRoute(
            path: '/post-medical-decision',
            name: AppRoutes.postMedicalDecision,
            builder: (context, state) => const PostMedicalDecisionScreen(),
          ),
          
          // Finalize account screen
          GoRoute(
            path: '/finalize-account',
            name: AppRoutes.finalizeAccount,
            builder: (context, state) => const FinalizeAccountScreen(),
          ),
        ],
      );

  /// Main app shell with proper StatefulShellRoute
  static StatefulShellRoute _buildMainAppShell() => StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainAppScaffold(
          navigationShell: navigationShell,
        ),
        branches: [
          // Home Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          
          // Activities Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/activities',
                name: AppRoutes.activities,
                builder: (context, state) => const ActivitiesScreen(),
                routes: [
                  // Nested challenges route
                  GoRoute(
                    path: '/challenges',
                    name: AppRoutes.challenges,
                    builder: (context, state) => const ChallengesScreen(),
                  ),
                  
                  // Nested meditations route
                  GoRoute(
                    path: '/meditations',
                    name: AppRoutes.meditations,
                    builder: (context, state) => const MeditationScreen(),
                    routes: [
                      // Individual meditation session
                      GoRoute(
                        path: '/session/:sessionId',
                        name: AppRoutes.meditationSession,
                        builder: (context, state) {
                          final sessionId = state.pathParameters['sessionId']!;
                          return MeditationSessionScreen(
                            session: MeditationSession(
                              title: 'Session $sessionId',
                              duration: '10 min',
                              themeColor: AppColors.primary,
                              icon: CupertinoIcons.leaf_arrow_circlepath,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  
                  // Nested resources route
                  GoRoute(
                    path: '/resources',
                    name: AppRoutes.resources,
                    builder: (context, state) => const ResourcesScreen(),
                  ),
                ],
              ),
            ],
          ),
          
          // AI Coach Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/ai-coach',
                name: AppRoutes.aiCoach,
                builder: (context, state) => const AICoachScreen(),
              ),
            ],
          ),
          
          // Medical Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/medical',
                name: AppRoutes.medical,
                builder: (context, state) => const MedicalScreen(),
              ),
            ],
          ),
          
          // My Hub Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/my-hub',
                name: AppRoutes.myHub,
                builder: (context, state) => const MyHubScreen(),
              ),
            ],
          ),
        ],
      );

  /// Global redirect logic - single source of truth for navigation guards
  static String? _handleGlobalRedirects(BuildContext context, GoRouterState state) {
    final currentPath = state.matchedLocation;
    
    // Get auth service (will be null during app initialization)
    final authService = context.read<AuthService?>();
    
    // If auth service is not available yet, allow navigation to proceed
    if (authService == null) {
      if (currentPath == '/') {
        return '/onboarding';
      }
      return null;
    }
    
    final isAuthenticated = authService.isAuthenticated;
    final isOnboardingRoute = currentPath.startsWith('/onboarding');
    
    // Root path handling
    if (currentPath == '/') {
      return isAuthenticated ? '/home' : '/onboarding';
    }
    
    // If user is authenticated but on onboarding screens, redirect to home
    if (isAuthenticated && isOnboardingRoute) {
      return '/home';
    }
    
    // If user is not authenticated and trying to access protected routes, redirect to onboarding
    if (!isAuthenticated && !isOnboardingRoute) {
      return '/onboarding';
    }
    
    // Allow navigation to proceed
    return null;
  }

  /// Error screen builder
  static Widget _buildErrorScreen(BuildContext context, GoRouterState state) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_triangle,
              size: 64,
              color: CupertinoColors.destructiveRed,
            ),
            const SizedBox(height: 24),
            Text(
              'Page Not Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Route: ${state.matchedLocation}',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.secondaryLabel,
              ),
            ),
            const SizedBox(height: 32),
            CupertinoButton.filled(
              child: const Text('Go Home'),
              onPressed: () => context.go('/home'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Main app scaffold using StatefulNavigationShell (recommended approach)
class MainAppScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainAppScaffold({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          // Main content area - this displays the current branch
          Expanded(
            child: navigationShell,
          ),
          // Custom tab bar
          Container(
            height: 50 + MediaQuery.of(context).padding.bottom,
            decoration: BoxDecoration(
              color: AppColors.getSurfaceWithOpacity(0.8),
              border: Border(
                top: BorderSide(
                  color: AppColors.getPrimaryWithOpacity(0.1),
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: _TabConfig.items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = navigationShell.currentIndex == index;
                  
                  return Expanded(
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _onTabTapped(index),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconTheme(
                            data: IconThemeData(
                              color: isSelected 
                                  ? AppColors.primary 
                                  : AppColors.getColorWithOpacity(
                                      AppColors.inactive,
                                      AppColors.inactiveOpacity,
                                    ),
                              size: 20,
                            ),
                            child: item.icon,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.label!,
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected 
                                  ? AppColors.primary 
                                  : AppColors.getColorWithOpacity(
                                      AppColors.inactive,
                                      AppColors.inactiveOpacity,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle tab taps using GoRouter's built-in branch switching
  void _onTabTapped(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

/// Tab configuration - clean, organized, single source of truth
class _TabConfig {
  static const List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(right: 7.0),
        child: Icon(SFIcons.sf_house_fill),
      ),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(right: 4.0),
        child: Icon(SFIcons.sf_square_stack_3d_up_fill),
      ),
      label: 'Activities',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(right: 5.0),
        child: Icon(SFIcons.sf_brain_head_profile),
      ),
      label: 'AI Coach',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(right: 5.0),
        child: Icon(SFIcons.sf_cross_case),
      ),
      label: 'Medical',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(right: 2.0),
        child: Icon(SFIcons.sf_square_grid_2x2_fill),
      ),
      label: 'My Hub',
    ),
  ];
}

/// Route names - type-safe navigation constants
class AppRoutes {
  // Onboarding
  static const String onboarding = 'onboarding';
  static const String featuresSlideshow = 'features-slideshow';
  
  // Main app tabs
  static const String home = 'home';
  static const String activities = 'activities';
  static const String aiCoach = 'ai-coach';
  static const String medical = 'medical';
  static const String myHub = 'my-hub';
  
  // Sub-routes
  static const String challenges = 'challenges';
  static const String meditations = 'meditations';
  static const String meditationSession = 'meditation-session';
  static const String resources = 'resources';
  static const String articleDetail = 'article-detail';
  static const String community = 'community';
  static const String profile = 'profile';
  static const String progress = 'progress';
  
  // New routes
  static const String codeScanner = 'code-scanner';
  static const String supplementQuiz = 'supplement-quiz';
  static const String sellerPage = 'seller-page';
  static const String supplementDetails = 'supplement-details';
  static const String medicalRecord = 'medical-record';
  static const String chooseSupplements = 'choose-supplements';
  static const String setupLoading = 'setup-loading';
  static const String postMedicalDecision = 'post-medical-decision';
  static const String finalizeAccount = 'finalize-account';
  
  // Debug/Test routes
  static const String apiTest = 'api-test';
}

/// Clean navigation helper - single way to navigate programmatically
class AppNavigation {
  // Main tabs
  static void toHome(BuildContext context) => context.goNamed(AppRoutes.home);
  static void toActivities(BuildContext context) => context.goNamed(AppRoutes.activities);
  static void toAICoach(BuildContext context) => context.goNamed(AppRoutes.aiCoach);
  static void toMedical(BuildContext context) => context.goNamed(AppRoutes.medical);
  static void toMyHub(BuildContext context) => context.goNamed(AppRoutes.myHub);
  
  // Sub-routes
  static void toChallenges(BuildContext context) => context.goNamed(AppRoutes.challenges);
  static void toMeditations(BuildContext context) => context.goNamed(AppRoutes.meditations);
  static void toResources(BuildContext context) => context.goNamed(AppRoutes.resources);
  
  // Onboarding
  static void toOnboarding(BuildContext context) => context.goNamed(AppRoutes.onboarding);
  static void toFeaturesSlideshow(BuildContext context) => context.goNamed(AppRoutes.featuresSlideshow);
  static void toCodeScanner(BuildContext context) => context.goNamed(AppRoutes.codeScanner);
  static void toSupplementQuiz(BuildContext context) => context.goNamed(AppRoutes.supplementQuiz);
  static void toMedicalRecord(BuildContext context) => context.goNamed(AppRoutes.medicalRecord);
  static void toChooseSupplements(BuildContext context) => context.goNamed(AppRoutes.chooseSupplements);
  static void toSetupLoading(BuildContext context) => context.goNamed(AppRoutes.setupLoading);
  static void toPostMedicalDecision(BuildContext context) => context.goNamed(AppRoutes.postMedicalDecision);
  static void toFinalizeAccount(BuildContext context) => context.goNamed(AppRoutes.finalizeAccount);
  
  // Onboarding with parameters
  static void toSellerPage(BuildContext context, String supplement) {
    context.goNamed(
      AppRoutes.sellerPage,
      pathParameters: {'supplement': supplement},
    );
  }
  
  static void toSupplementDetails(BuildContext context, String code) {
    context.goNamed(
      AppRoutes.supplementDetails,
      pathParameters: {'code': code},
    );
  }
  
  // Global routes
  static void toArticleDetail(BuildContext context, {
    required String title,
    required String description,
    required String readTime,
  }) {
    context.pushNamed(
      AppRoutes.articleDetail,
      queryParameters: {
        'title': title,
        'description': description,
        'readTime': readTime,
      },
    );
  }
  
  static void toCommunity(BuildContext context) => context.pushNamed(AppRoutes.community);
  static void toProfile(BuildContext context) => context.pushNamed(AppRoutes.profile);
  static void toProgress(BuildContext context) => context.pushNamed(AppRoutes.progress);
  
  // Login completion
  static void onLoginComplete(BuildContext context) => context.goNamed(AppRoutes.home);
  
  // Debug/Test routes
  static void toApiTest(BuildContext context) => context.pushNamed(AppRoutes.apiTest);
} 