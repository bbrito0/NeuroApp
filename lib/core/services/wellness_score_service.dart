import '../datasources/static/wellness_scoring.dart';
import 'user_profile_service.dart';

class WellnessScoreService {
  final UserProfileService _userProfileService;
  
  WellnessScoreService(this._userProfileService);
  
  // Calculate the overall wellness score based on the user's supplements
  int calculateOverallScore() {
    final userSupplements = _userProfileService.ownedSupplements;
    
    // If user has no supplements, return a default score
    if (userSupplements.isEmpty) {
      return _calculateAverageBaseScore();
    }
    
    // Get combined weight profile for all user supplements
    final combinedWeights = _getCombinedWeightProfile(userSupplements);
    
    // Calculate weighted score
    int totalScore = 0;
    int totalWeight = 0;
    
    combinedWeights.forEach((category, weight) {
      final baseScore = WellnessScoring.getBaseCategoryScore(category);
      totalScore += baseScore * weight;
      totalWeight += weight;
    });
    
    // Ensure we don't divide by zero
    if (totalWeight == 0) return _calculateAverageBaseScore();
    
    return (totalScore / totalWeight).round();
  }
  
  // Calculate score for a specific category based on user's supplements
  int calculateCategoryScore(String category) {
    // For this demo, we'll just return the base category score
    // In a full implementation, this would incorporate user's health metrics
    return WellnessScoring.getBaseCategoryScore(category);
  }
  
  // Calculate all category scores
  Map<String, int> calculateAllCategoryScores() {
    final result = <String, int>{};
    
    for (final category in WellnessScoring.getAllCategories()) {
      result[category] = calculateCategoryScore(category);
    }
    
    return result;
  }
  
  // Get the influence percentage of each supplement on the overall score
  Map<String, double> getSupplementInfluence() {
    final userSupplements = _userProfileService.ownedSupplements;
    
    // If no supplements, return empty map
    if (userSupplements.isEmpty) {
      return {};
    }
    
    // Each supplement has equal influence if user has multiple
    final influencePerSupplement = 1.0 / userSupplements.length;
    
    final result = <String, double>{};
    for (final supplement in userSupplements) {
      result[supplement] = influencePerSupplement;
    }
    
    return result;
  }
  
  // Helper Methods
  
  // Calculate average base score across all categories
  int _calculateAverageBaseScore() {
    final scores = WellnessScoring.BASE_CATEGORY_SCORES.values;
    if (scores.isEmpty) return 50; // Default if no categories
    
    final sum = scores.reduce((a, b) => a + b);
    return (sum / scores.length).round();
  }
  
  // Combine weight profiles from multiple supplements
  Map<String, int> _getCombinedWeightProfile(List<String> supplementCodes) {
    // Start with empty weight profile
    final combined = <String, int>{};
    
    // Initialize all categories to 0
    for (final category in WellnessScoring.getAllCategories()) {
      combined[category] = 0;
    }
    
    // If no supplements, return equal weights
    if (supplementCodes.isEmpty) {
      final equalWeight = 100 ~/ combined.length;
      combined.updateAll((key, value) => equalWeight);
      return combined;
    }
    
    // Sum up weights from all supplements
    for (final code in supplementCodes) {
      final profile = WellnessScoring.getWeightProfile(code);
      
      profile.forEach((category, weight) {
        combined[category] = (combined[category] ?? 0) + weight;
      });
    }
    
    // Normalize to ensure weights sum to 100
    int totalWeight = combined.values.fold(0, (a, b) => a + b);
    
    // Avoid division by zero
    if (totalWeight == 0) {
      final equalWeight = 100 ~/ combined.length;
      combined.updateAll((key, value) => equalWeight);
    } else {
      // Scale weights to maintain proportions but sum to 100
      combined.forEach((category, weight) {
        combined[category] = ((weight / totalWeight) * 100).round();
      });
    }
    
    return combined;
  }
} 