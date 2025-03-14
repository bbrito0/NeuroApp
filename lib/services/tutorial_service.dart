import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class TutorialService {
  // Global tutorial mode
  static bool _tutorialsEnabled = false;
  
  // Track which tutorials have been shown
  static final Map<String, bool> _shownTutorials = {};
  
  // Tutorial screen identifiers
  static const String COMMUNITY_TUTORIAL = "community";
  static const String PROFILE_TUTORIAL = "profile";
  static const String MEDITATION_TUTORIAL = "meditation";
  static const String RESOURCES_TUTORIAL = "resources";
  static const String PROGRESS_TUTORIAL = "progress";
  static const String COGNITIVE_TUTORIAL = "cognitive";
  static const String HOME_TUTORIAL = "home";
  static const String MEDICAL_TUTORIAL = "medical";
  static const String AI_COACH_TUTORIAL = "ai_coach";
  static const String MY_HUB_TUTORIAL = "my_hub";

  // Enable tutorials
  static void enableTutorials() {
    _tutorialsEnabled = true;
  }

  // Disable tutorials
  static void disableTutorials() {
    _tutorialsEnabled = false;
  }

  // Check if a specific tutorial should be shown
  static bool shouldShowTutorial(String tutorialId) {
    return _tutorialsEnabled;  // Only check if tutorials are enabled
  }

  // Mark a tutorial as shown
  static void markTutorialAsShown(String tutorialId) {
    _shownTutorials[tutorialId] = true;
  }

  // Reset all tutorials (will show them again when enabled)
  static void resetTutorials() {
    _shownTutorials.clear();
  }

  // Get current tutorial mode state
  static bool areTutorialsEnabled() {
    return _tutorialsEnabled;
  }

  static Widget buildTutorialContent(
    String title,
    String description,
    TutorialCoachMarkController controller, {
    bool isLastStep = false,
    VoidCallback? onNext,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.withColor(
              AppTextStyles.heading2,
              CupertinoColors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: AppTextStyles.withColor(
              AppTextStyles.bodyMedium,
              CupertinoColors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primarySurfaceGradient(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              onPressed: isLastStep ? () => controller.skip() : onNext,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLastStep ? "Finish" : "Next",
                    style: AppTextStyles.withColor(
                      AppTextStyles.bodyMedium,
                      CupertinoColors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isLastStep ? CupertinoIcons.check_mark : CupertinoIcons.arrow_right,
                    color: CupertinoColors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static TutorialCoachMark createMyHubTutorial(BuildContext context, List<GlobalKey> keys, ScrollController scrollController) {
    void scrollToTarget(GlobalKey key) {
      final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      
      // Calculate screen height
      final screenHeight = MediaQuery.of(context).size.height;
      // Calculate the target's height
      final targetHeight = renderBox.size.height;
      
      // Adjust scroll position based on the target
      double offset;
      if (key == keys[1]) { // Progress section
        // Position the progress chart much lower to show the full tutorial
        offset = position.dy - (screenHeight * 0.45); // Reduced from 0.3 to show more of the chart
      } else if (key == keys[2]) { // Goals section
        // Move the goals table higher up
        offset = position.dy - (screenHeight * 0.3); // Increased from 0.4 to move table higher
      } else if (key == keys[3]) { // Community & Profile section
        // Ensure the cards are visible in the viewport
        offset = position.dy + (screenHeight * 0.1);
      } else {
        // Default offset for other sections
        offset = position.dy - 100;
      }

      scrollController.animateTo(
        offset.clamp(0, scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    List<TargetFocus> targets = [
      TargetFocus(
        identify: "overallScoreKey",
        keyTarget: keys[0],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return buildTutorialContent(
                "Overall Cognitive Score",
                "This is your cognitive wellness score, combining Memory, Focus, and Problem-Solving abilities.",
                controller,
                onNext: () {
                  scrollToTarget(keys[1]);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    controller.next();
                  });
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "progressKey",
        keyTarget: keys[1],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return buildTutorialContent(
                "Progress Overview",
                "Swipe through these charts to see your progress in Memory, Focus, and Problem-Solving. Each chart shows your improvement over time.",
                controller,
                onNext: () {
                  scrollToTarget(keys[2]);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    controller.next();
                  });
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "goalsKey",
        keyTarget: keys[2],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: 40, // Move content 20 pixels up
            ),
            builder: (context, controller) {
              return buildTutorialContent(
                "Your Goals",
                "Here are your current goals and progress for each cognitive area. Tap 'Edit Goals' above to set new targets or update existing ones.",
                controller,
                onNext: () {
                  scrollToTarget(keys[3]);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    controller.next();
                  });
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "communityKey",
        keyTarget: keys[3],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return buildTutorialContent(
                "Community & Profile",
                "Connect with others and manage your profile settings. Join discussions, share experiences, and customize your preferences.",
                controller,
                isLastStep: true,
              );
            },
          ),
        ],
      ),
    ];

    return TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      paddingFocus: 10,
      opacityShadow: 0.8,
      hideSkip: false,
      alignSkip: Alignment.topRight,
      textSkip: "Skip Tutorial",
      textStyleSkip: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      pulseEnable: false,
      onClickOverlay: (target) {
        // Prevent tutorial from advancing when clicking overlay
      },
    );
  }

  static TutorialCoachMark createAICoachTutorial(BuildContext context, List<GlobalKey> keys, ScrollController scrollController) {
    List<TargetFocus> targets = [
      TargetFocus(
        identify: "chatInputKey",
        keyTarget: keys[1],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return buildTutorialContent(
                "Chat with Your AI Coach",
                "Type your messages here to chat with your AI Coach. Get personalized guidance, support, and answers to your questions about cognitive wellness.",
                controller,
                onNext: () {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    controller.next();
                  });
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "videoChatKey",
        keyTarget: keys[0],
        shape: ShapeLightFocus.Circle,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return buildTutorialContent(
                "Video Call",
                "Start a face-to-face video call with your AI Coach for a more personal and interactive experience.",
                controller,
                isLastStep: true,
              );
            },
          ),
        ],
      ),
    ];

    return TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      paddingFocus: 10,
      opacityShadow: 0.8,
      hideSkip: false,
      alignSkip: Alignment.topLeft,
      textSkip: "Skip Tutorial",
      textStyleSkip: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      pulseEnable: false,
      onClickOverlay: (target) {
        // Prevent tutorial from advancing when clicking overlay
      },
    );
  }

  static TutorialCoachMark createHomeScreenTutorial(BuildContext context, List<GlobalKey> keys, ScrollController scrollController) {
    void scrollToTarget(GlobalKey key) {
      final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;
      
      // Calculate desired position to show the target in the viewport
      double targetPosition = screenHeight * 0.15; // Default position
      
      if (key == keys[0]) { // Welcome Card
        targetPosition = screenHeight * 0.35; // Center the target with the white box
      } else if (key == keys[1]) { // Daily Challenges
        targetPosition = screenHeight * 0.4;
      } else if (key == keys[2]) { // Quick Actions
        targetPosition = screenHeight * 0.3;
      } else if (key == keys[3]) { // Latest Updates
        targetPosition = screenHeight * 0.01 - 150; // Move news list much higher up
      }

      // Calculate the offset needed to position the target
      double offset = position.dy - targetPosition;
      
      // Ensure offset is within bounds
      offset = offset.clamp(0.0, scrollController.position.maxScrollExtent);

      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    List<TargetFocus> targets = [
      TargetFocus(
        identify: "welcomeCardKey",
        keyTarget: keys[0],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        alignSkip: Alignment.topRight,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              bottom: 60, // Increase bottom padding to center the content
            ),
            builder: (context, controller) {
              return buildTutorialContent(
                "Welcome to ChronoWell",
                "Check your daily progress and start your cognitive wellness journey with a personalized AI Coach check-in.",
                controller,
                onNext: () {
                  scrollToTarget(keys[1]);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    controller.next();
                  });
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "dailyChallengesKey",
        keyTarget: keys[1],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: 40, // Move content 20 pixels up
            ),
            builder: (context, controller) {
              return buildTutorialContent(
                "Daily Challenges",
                "Complete these personalized challenges to improve your Memory, Focus, and Problem-Solving abilities. Swipe to see all challenges.",
                controller,
                onNext: () {
                  scrollToTarget(keys[2]);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    controller.next();
                  });
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "quickActionsKey",
        keyTarget: keys[2],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return buildTutorialContent(
                "Quick Access",
                "Take a cognitive assessment or explore learning resources to enhance your cognitive wellness journey.",
                controller,
                onNext: () {
                  scrollToTarget(keys[3]);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    controller.next();
                  });
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "latestUpdatesKey",
        keyTarget: keys[3],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: 40, // Move content 20 pixels up
            ),
            builder: (context, controller) {
              return buildTutorialContent(
                "Latest Updates",
                "Stay informed about new challenges, achievements, and personalized insights about your cognitive wellness journey.",
                controller,
                isLastStep: true,
              );
            },
          ),
        ],
      ),
    ];

    return TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      paddingFocus: 10,
      opacityShadow: 0.8,
      hideSkip: false,
      alignSkip: Alignment.topRight,
      textSkip: "Skip Tutorial",
      textStyleSkip: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      pulseEnable: false,
      onClickOverlay: (target) {
        // Prevent tutorial from advancing when clicking overlay
      },
    );
  }

  static TutorialCoachMark createMedicalScreenTutorial(BuildContext context, List<GlobalKey> keys, ScrollController scrollController) {
    void scrollToTarget(GlobalKey key) {
      final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;
      final targetHeight = renderBox.size.height;
      
      // Initialize offset with a default value
      double offset = position.dy - (screenHeight * 0.3); // Default position
      
      if (key == keys[0]) { // Medical Reports
        offset = position.dy - (screenHeight * 0.2); // Show near the top
      } else if (key == keys[1]) { // Caregiver Portal
        offset = position.dy - (screenHeight * 0.6); // Show in upper third
      } else if (key == keys[2]) { // Upcoming Meetings
        offset = position.dy - (screenHeight * 0.3); // Show in middle
      } else if (key == keys[3]) { // Medical History
        offset = position.dy - (screenHeight * 0.2); // Show lower to include full form
      }
      
      // Ensure offset is within bounds
      offset = offset.clamp(0.0, scrollController.position.maxScrollExtent);
      
      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    List<TargetFocus> targets = [
      TargetFocus(
        identify: "medicalReportsKey",
        keyTarget: keys[0],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return buildTutorialContent(
                "Medical Reports",
                "Access and review your latest medical reports. Keep track of your cognitive health assessments and professional evaluations.",
                controller,
                onNext: () {
                  scrollToTarget(keys[1]);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    controller.next();
                  });
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "caregiverPortalKey",
        keyTarget: keys[1],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return buildTutorialContent(
                "Caregiver Portal",
                "Connect with healthcare professionals specializing in cognitive wellness. Schedule consultations and get expert guidance.",
                controller,
                onNext: () {
                  scrollToTarget(keys[2]);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    controller.next();
                  });
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "upcomingMeetingsKey",
        keyTarget: keys[2],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return buildTutorialContent(
                "Upcoming Meetings",
                "View and manage your scheduled appointments. Join virtual consultations with your healthcare providers.",
                controller,
                onNext: () {
                  scrollToTarget(keys[3]);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    controller.next();
                  });
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "medicalHistoryKey",
        keyTarget: keys[3],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return buildTutorialContent(
                "Medical History",
                "Maintain your family medical history and personal health records. Keep your information up to date for better care.",
                controller,
                isLastStep: true,
              );
            },
          ),
        ],
      ),
    ];

    return TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      paddingFocus: 10,
      opacityShadow: 0.8,
      hideSkip: false,
      alignSkip: Alignment.topRight,
      textSkip: "Skip Tutorial",
      textStyleSkip: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      pulseEnable: false,
      onClickOverlay: (target) {
        // Prevent tutorial from advancing when clicking overlay
      },
    );
  }

  static TutorialCoachMark createProgressTutorial(BuildContext context, List<GlobalKey> keys, ScrollController scrollController) {
    void scrollToTarget(GlobalKey key) {
      final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;
      
      double targetPosition;
      if (key == keys[0]) { // AI Insight
        targetPosition = screenHeight * 0.2; // Show near the top
      } else if (key == keys[1]) { // Progress Chart
        targetPosition = screenHeight * 0.15; // Reduced from 0.3 to 0.15 to show more of the chart
      } else if (key == keys[2]) { // Stats Grid
        targetPosition = screenHeight * 0.2; // Show near the top for better visibility
      } else {
        targetPosition = screenHeight * 0.3; // Default position
      }

      double offset = position.dy - targetPosition;
      offset = offset.clamp(0.0, scrollController.position.maxScrollExtent);

      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    List<TargetFocus> targets = [
      TargetFocus(
        identify: "aiInsightKey",
        targetPosition: TargetPosition(
          const Size(360, 140),  // Width and height of highlight window
          Offset(16, MediaQuery.of(context).padding.top + 100),  // Position from top-left of screen
        ),
        shape: ShapeLightFocus.RRect,
        radius: 20,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return buildTutorialContent(
                "AI-Powered Insights",
                "Get personalized recommendations and analysis of your cognitive progress. Our AI coach helps you understand your strengths and areas for improvement.",
                controller,
                onNext: () {
                  scrollToTarget(keys[1]);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    controller.next();
                  });
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "progressChartKey",
        keyTarget: keys[1],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 60,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              bottom: -15,
            ),
            builder: (context, controller) {
              return buildTutorialContent(
                "Progress Chart",
                "Track your cognitive performance over time. Switch between different time ranges and cognitive areas using the filters above.",
                controller,
                onNext: () {
                  scrollToTarget(keys[2]);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    controller.next();
                  });
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "statsGridKey",
        keyTarget: keys[2],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return buildTutorialContent(
                "Performance Stats",
                "View your key performance metrics, including current score, best score, daily streak, and completed exercises.",
                controller,
                isLastStep: true,
              );
            },
          ),
        ],
      ),
    ];

    return TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      paddingFocus: 10,
      opacityShadow: 0.8,
      hideSkip: false,
      alignSkip: Alignment.topRight,
      textSkip: "Skip Tutorial",
      textStyleSkip: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      pulseEnable: false,
      onClickOverlay: (target) {
        // Prevent tutorial from advancing when clicking overlay
      },
    );
  }

  static TutorialCoachMark createChallengesTutorial(BuildContext context, List<GlobalKey> keys, ScrollController scrollController) {
    List<TargetFocus> targets = [
      TargetFocus(
        identify: "challengesOverviewKey",
        targetPosition: TargetPosition(
          const Size(360, 260),  // Width and height of highlight window
          Offset(16, MediaQuery.of(context).padding.top + 100),  // Position from top-left of screen
        ),
        shape: ShapeLightFocus.RRect,
        radius: 20,
        enableTargetTab: false,
        paddingFocus: 20,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              bottom: 20,
            ),
            builder: (context, controller) {
              return buildTutorialContent(
                "Cognitive Challenges",
                "Explore our collection of brain training exercises designed to enhance your memory, reaction time, and pattern recognition skills.",
                controller,
                isLastStep: true,
              );
            },
          ),
        ],
      ),
    ];

    return TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      paddingFocus: 10,
      opacityShadow: 0.8,
      hideSkip: false,
      alignSkip: Alignment.topRight,
      textSkip: "Skip Tutorial",
      textStyleSkip: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      pulseEnable: false,
      onClickOverlay: (target) {
        // Prevent tutorial from advancing when clicking overlay
      },
    );
  }

  static TutorialCoachMark createMeditationTutorial(BuildContext context, List<GlobalKey> keys, ScrollController scrollController) {
    void scrollToTarget(GlobalKey key) {
      final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;
      
      double offset = position.dy - (screenHeight * 0.2);
      offset = offset.clamp(0.0, scrollController.position.maxScrollExtent);

      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    List<TargetFocus> targets = [
      TargetFocus(
        identify: "meditationOverviewKey",
        targetPosition: TargetPosition(
          const Size(360, 240),  // Width and height of highlight window
          Offset(16, MediaQuery.of(context).padding.top + 115),  // Using same positioning as progress tutorial
        ),
        shape: ShapeLightFocus.RRect,
        radius: 20,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return buildTutorialContent(
                "Guided Meditations",
                "Explore our curated selection of meditation sessions designed to enhance your cognitive wellness and mental clarity.",
                controller,
                isLastStep: true,
              );
            },
          ),
        ],
      ),
    ];

    return TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      paddingFocus: 10,
      opacityShadow: 0.8,
      hideSkip: false,
      alignSkip: Alignment.topRight,
      textSkip: "Skip Tutorial",
      textStyleSkip: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      pulseEnable: false,
      onClickOverlay: (target) {
        // Prevent tutorial from advancing when clicking overlay
      },
    );
  }

  static TutorialCoachMark createResourcesTutorial(BuildContext context, List<GlobalKey> keys, ScrollController scrollController) {
    void scrollToTarget(GlobalKey key) {
      final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;
      
      double targetPosition = screenHeight * 0.3;
      double offset = position.dy - targetPosition;
      offset = offset.clamp(0.0, scrollController.position.maxScrollExtent);
      
      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    List<TargetFocus> targets = [
      TargetFocus(
        identify: "searchKey",
        targetPosition: TargetPosition(
          const Size(360, 40),  // Width and height of highlight window for search bar
          Offset(12, MediaQuery.of(context).padding.top + 100),  // Position from top-left of screen
        ),
        shape: ShapeLightFocus.RRect,
        radius: 20,
        enableTargetTab: false,
        paddingFocus: 20,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              bottom: 20,
            ),
            builder: (context, controller) {
              return buildTutorialContent(
                "Search Resources",
                "Quickly find articles, guides, and resources by searching keywords or topics.",
                controller,
                onNext: () {
                  scrollToTarget(keys[1]);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    controller.next();
                  });
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "categoriesKey",
        keyTarget: keys[1],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return buildTutorialContent(
                "Resource Categories",
                "Browse resources by category to find content specific to your cognitive wellness goals.",
                controller,
                onNext: () {
                  scrollToTarget(keys[2]);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    controller.next();
                  });
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "articlesKey",
        keyTarget: keys[2],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return buildTutorialContent(
                "Featured Articles",
                "Stay updated with our latest and most relevant articles on cognitive wellness.",
                controller,
                isLastStep: true,
              );
            },
          ),
        ],
      ),
    ];

    return TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      paddingFocus: 10,
      opacityShadow: 0.8,
      hideSkip: false,
      alignSkip: Alignment.topRight,
      textSkip: "Skip Tutorial",
      textStyleSkip: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      pulseEnable: false,
      onClickOverlay: (target) {
        // Prevent tutorial from advancing when clicking overlay
      },
    );
  }

  static TutorialCoachMark createCommunityTutorial(
    BuildContext context,
    List<GlobalKey> keys,
    ScrollController scrollController,
  ) {
    void scrollToTarget(GlobalKey key) {
      final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;
      double targetPosition = screenHeight * 0.3;
      
      double offset = position.dy - targetPosition;
      offset = offset.clamp(0.0, scrollController.position.maxScrollExtent);
      
      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    List<TargetFocus> targets = [
      TargetFocus(
        identify: "searchKey",
        keyTarget: keys[0],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 20,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              bottom: 20,
            ),
            builder: (context, controller) {
              return buildTutorialContent(
                "Search Community",
                "Find topics, discussions, and connect with others in our community.",
                controller,
                onNext: () {
                  scrollToTarget(keys[1]);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    controller.next();
                  });
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "tagsKey",
        keyTarget: keys[1],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return buildTutorialContent(
                "Popular Tags",
                "Browse topics by category to find discussions that interest you.",
                controller,
                onNext: () {
                  scrollToTarget(keys[2]);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    controller.next();
                  });
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "topicsKey",
        keyTarget: keys[2],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return buildTutorialContent(
                "Community Topics",
                "Engage with the community through discussions, share experiences, and learn from others.",
                controller,
                onNext: () {
                  scrollToTarget(keys[3]);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    controller.next();
                  });
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "createPostKey",
        keyTarget: keys[3],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return buildTutorialContent(
                "Create Post",
                "Share your thoughts, ask questions, or start a discussion with the community.",
                controller,
                isLastStep: true,
              );
            },
          ),
        ],
      ),
    ];

    return TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      paddingFocus: 10,
      opacityShadow: 0.8,
      hideSkip: false,
      alignSkip: Alignment.topLeft,
      textSkip: "Skip Tutorial",
      textStyleSkip: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      pulseEnable: false,
      onClickOverlay: (target) {
        // Prevent tutorial from advancing when clicking overlay
      },
    );
  }

  static TutorialCoachMark createProfileTutorial(BuildContext context, List<GlobalKey> keys, ScrollController scrollController) {
    void scrollToTarget(GlobalKey key) {
      final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;
      
      double targetPosition = screenHeight * 0.2;
      double offset = position.dy - targetPosition;
      offset = offset.clamp(0.0, scrollController.position.maxScrollExtent);

      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    List<TargetFocus> targets = [
      TargetFocus(
        identify: "profileSettingsKey",
        keyTarget: keys[0],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        enableTargetTab: false,
        paddingFocus: 20,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: 20,
            ),
            builder: (context, controller) {
              return buildTutorialContent(
                "Settings & Preferences",
                "Customize your app experience, manage notifications, privacy settings, and get help when needed.",
                controller,
                isLastStep: true,
              );
            },
          ),
        ],
      ),
    ];

    return TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      paddingFocus: 10,
      opacityShadow: 0.8,
      hideSkip: false,
      alignSkip: Alignment.topRight,
      textSkip: "Skip Tutorial",
      textStyleSkip: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      pulseEnable: false,
      onClickOverlay: (target) {
        // Prevent tutorial from advancing when clicking overlay
      },
    );
  }

  // Similar methods for other screens...
} 