import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/supplement.dart';

class UserProfileService extends ChangeNotifier {
  // Internal state
  UserProfile _currentUser = UserProfile.MEMORY_MASTER;
  
  // Getters
  UserProfile get currentUser => _currentUser;
  List<String> get ownedSupplements => _currentUser.ownedSupplementCodes;
  
  // Methods
  void switchUser(String userId) {
    final profiles = UserProfile.getPredefinedProfiles();
    final newProfile = profiles.firstWhere(
      (profile) => profile.id == userId,
      orElse: () => UserProfile.MEMORY_MASTER,
    );
    
    if (_currentUser.id != newProfile.id) {
      _currentUser = newProfile;
      notifyListeners();
    }
  }
  
  // Get the full supplement objects for the current user
  List<Supplement> getOwnedSupplements() {
    final supplements = <Supplement>[];
    
    for (final code in ownedSupplements) {
      final supplement = Supplement.getByCode(code);
      if (supplement != null) {
        supplements.add(supplement);
      }
    }
    
    return supplements;
  }
  
  // Check if user owns a specific supplement
  bool hasSupplement(String supplementCode) {
    return ownedSupplements.contains(supplementCode);
  }
} 