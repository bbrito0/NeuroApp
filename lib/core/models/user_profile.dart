class UserProfile {
  final String id;
  final String name;
  final List<String> ownedSupplementCodes;
  final String focusArea;
  final String description;

  const UserProfile({
    required this.id,
    required this.name,
    required this.ownedSupplementCodes,
    required this.focusArea,
    required this.description,
  });

  // Predefined user profiles
  static const MEMORY_MASTER = UserProfile(
    id: 'memory_master',
    name: 'Memory Master',
    ownedSupplementCodes: ['REVERSE', 'RELAX'],
    focusArea: 'Memory & Stress Relief',
    description: 'Focused on improving memory and reducing stress levels',
  );

  static const ENERGY_ENTHUSIAST = UserProfile(
    id: 'energy_enthusiast',
    name: 'Energy Enthusiast',
    ownedSupplementCodes: ['RECOVER', 'REVITA'],
    focusArea: 'Cognitive Function & Energy',
    description: 'Focused on boosting energy and enhancing cognitive performance',
  );

  // Get all predefined user profiles
  static List<UserProfile> getPredefinedProfiles() {
    return [MEMORY_MASTER, ENERGY_ENTHUSIAST];
  }
} 