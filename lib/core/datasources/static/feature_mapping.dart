/// Defines the mapping between features and supplements that unlock them
class FeatureMapping {
  // Constants for feature IDs - Challenges
  static const String FEATURE_MEMORY_MATCH = 'feature_memory_match';
  static const String FEATURE_QUICK_REACTION = 'feature_quick_reaction';
  static const String FEATURE_PATTERN_QUEST = 'feature_pattern_quest';
  static const String FEATURE_WORD_RECALL = 'feature_word_recall';
  static const String FEATURE_FOCUS_TIMER = 'feature_focus_timer';
  static const String FEATURE_VISUAL_PUZZLE = 'feature_visual_puzzle';

  // Constants for feature IDs - Meditations
  static const String FEATURE_MINDFUL_BREATHING = 'feature_mindful_breathing';
  static const String FEATURE_BODY_SCAN = 'feature_body_scan';
  static const String FEATURE_MENTAL_CLARITY = 'feature_mental_clarity';
  static const String FEATURE_STRESS_RELIEF = 'feature_stress_relief';
  static const String FEATURE_DEEP_FOCUS = 'feature_deep_focus';

  // Constants for feature IDs - Resources
  static const String FEATURE_MEMORY_ARTICLES = 'feature_memory_articles';
  static const String FEATURE_FOCUS_ARTICLES = 'feature_focus_articles';
  static const String FEATURE_SPEED_ARTICLES = 'feature_speed_articles';
  static const String FEATURE_PROBLEM_SOLVING_ARTICLES = 'feature_problem_solving_articles';

  // Main mapping between features and their required supplements
  static const Map<String, List<String>> FEATURE_SUPPLEMENT_MAP = {
    // Challenges
    FEATURE_MEMORY_MATCH: ['REVERSE', 'RESTORE'],
    FEATURE_QUICK_REACTION: ['REVITA', 'RESTORE'],
    FEATURE_PATTERN_QUEST: ['RECOVER', 'RESTORE'],
    FEATURE_WORD_RECALL: ['REVERSE', 'RECOVER'],
    FEATURE_FOCUS_TIMER: ['RELAX', 'RESTORE'],
    FEATURE_VISUAL_PUZZLE: ['RECOVER', 'RESTORE'],

    // Meditations
    FEATURE_MINDFUL_BREATHING: ['RELAX', 'RESET'],
    FEATURE_BODY_SCAN: ['RELAX', 'RESET'],
    FEATURE_MENTAL_CLARITY: ['RESTORE', 'RECOVER'],
    FEATURE_STRESS_RELIEF: ['RELAX', 'REGEN'],
    FEATURE_DEEP_FOCUS: ['RESTORE', 'REVITA'],

    // Resources
    FEATURE_MEMORY_ARTICLES: ['REVERSE', 'RECOVER'],
    FEATURE_FOCUS_ARTICLES: ['RESTORE', 'REVITA'],
    FEATURE_SPEED_ARTICLES: ['REVITA', 'RECOVER'],
    FEATURE_PROBLEM_SOLVING_ARTICLES: ['RESTORE', 'RECOVER'],
  };

  // Get supplements required for a feature
  static List<String> getRequiredSupplements(String featureId) {
    return FEATURE_SUPPLEMENT_MAP[featureId] ?? [];
  }

  // Check if a feature exists in the mapping
  static bool isValidFeature(String featureId) {
    return FEATURE_SUPPLEMENT_MAP.containsKey(featureId);
  }
} 