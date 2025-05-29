/// Defines the wellness category scores and supplement weight profiles
class WellnessScoring {
  // Health categories
  static const String CATEGORY_CELLULAR_HEALTH = 'CellularHealth';
  static const String CATEGORY_SLEEP = 'Sleep';
  static const String CATEGORY_STRESS = 'Stress';
  static const String CATEGORY_COGNITIVE = 'Cognitive';
  static const String CATEGORY_ENERGY = 'Energy';
  static const String CATEGORY_IMMUNE = 'Immune';

  // Base category scores (0-100)
  static const Map<String, int> BASE_CATEGORY_SCORES = {
    CATEGORY_CELLULAR_HEALTH: 65,
    CATEGORY_SLEEP: 70,
    CATEGORY_STRESS: 60,
    CATEGORY_COGNITIVE: 75,
    CATEGORY_ENERGY: 68,
    CATEGORY_IMMUNE: 72,
  };

  // Supplement weight profiles (in %)
  static const Map<String, Map<String, int>> SUPPLEMENT_WEIGHTS = {
    'REVERSE': {
      CATEGORY_CELLULAR_HEALTH: 60,
      CATEGORY_SLEEP: 10,
      CATEGORY_STRESS: 5,
      CATEGORY_COGNITIVE: 0,
      CATEGORY_ENERGY: 20,
      CATEGORY_IMMUNE: 5,
    },
    'RESET': {
      CATEGORY_CELLULAR_HEALTH: 5,
      CATEGORY_SLEEP: 70,
      CATEGORY_STRESS: 20,
      CATEGORY_COGNITIVE: 0,
      CATEGORY_ENERGY: 0,
      CATEGORY_IMMUNE: 5,
    },
    'RELAX': {
      CATEGORY_CELLULAR_HEALTH: 5,
      CATEGORY_SLEEP: 15,
      CATEGORY_STRESS: 70,
      CATEGORY_COGNITIVE: 0,
      CATEGORY_ENERGY: 0,
      CATEGORY_IMMUNE: 10,
    },
    'RECOVER': {
      CATEGORY_CELLULAR_HEALTH: 10,
      CATEGORY_SLEEP: 5,
      CATEGORY_STRESS: 5,
      CATEGORY_COGNITIVE: 70,
      CATEGORY_ENERGY: 5,
      CATEGORY_IMMUNE: 5,
    },
    'RESTORE': {
      CATEGORY_CELLULAR_HEALTH: 5,
      CATEGORY_SLEEP: 0,
      CATEGORY_STRESS: 0,
      CATEGORY_COGNITIVE: 85,
      CATEGORY_ENERGY: 5,
      CATEGORY_IMMUNE: 5,
    },
    'REVITA': {
      CATEGORY_CELLULAR_HEALTH: 10,
      CATEGORY_SLEEP: 5,
      CATEGORY_STRESS: 5,
      CATEGORY_COGNITIVE: 0,
      CATEGORY_ENERGY: 75,
      CATEGORY_IMMUNE: 5,
    },
    'REGEN': {
      CATEGORY_CELLULAR_HEALTH: 15,
      CATEGORY_SLEEP: 5,
      CATEGORY_STRESS: 10,
      CATEGORY_COGNITIVE: 0,
      CATEGORY_ENERGY: 5,
      CATEGORY_IMMUNE: 65,
    },
  };

  // Get all category names
  static List<String> getAllCategories() {
    return [
      CATEGORY_CELLULAR_HEALTH,
      CATEGORY_SLEEP,
      CATEGORY_STRESS,
      CATEGORY_COGNITIVE,
      CATEGORY_ENERGY,
      CATEGORY_IMMUNE
    ];
  }

  // Get weight profile for a specific supplement
  static Map<String, int> getWeightProfile(String supplementCode) {
    return SUPPLEMENT_WEIGHTS[supplementCode] ?? {};
  }

  // Get base score for a specific category
  static int getBaseCategoryScore(String category) {
    return BASE_CATEGORY_SCORES[category] ?? 50; // Default to 50 if not found
  }
} 