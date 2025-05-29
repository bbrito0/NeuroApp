import '../datasources/static/feature_mapping.dart';
import 'user_profile_service.dart';

class FeatureAccessService {
  final UserProfileService _userProfileService;
  final Map<String, List<String>> featureSupplementMap;
  
  FeatureAccessService(this._userProfileService)
      : featureSupplementMap = FeatureMapping.FEATURE_SUPPLEMENT_MAP;
  
  // Check if the current user can access a specific feature
  bool canAccess(String featureId) {
    // If the feature isn't in our map, allow access by default
    if (!featureSupplementMap.containsKey(featureId)) return true;
    
    // Get list of supplements that can unlock this feature
    final requiredSupplements = featureSupplementMap[featureId]!;
    
    // Get supplements the user currently owns
    final userSupplements = _userProfileService.ownedSupplements;
    
    // User can access if they own at least one of the required supplements
    return requiredSupplements.any((supplement) => 
      userSupplements.contains(supplement));
  }
  
  // Get list of supplements that can unlock a feature
  List<String> getRequiredSupplementsForFeature(String featureId) {
    return featureSupplementMap[featureId] ?? [];
  }
  
  // Get list of features the current user can access
  List<String> getAccessibleFeatures() {
    return featureSupplementMap.keys
        .where((featureId) => canAccess(featureId))
        .toList();
  }
} 