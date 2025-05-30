class ApiEndpoints {
  static String getBaseUrlForPlatform() {
    // For iOS simulator, use localhost
    return 'http://localhost:5001/api/v1';
  }

  // Auth endpoints
  static const String signup = '/users/signup';
  static const String users = '/users';
  static const String healthCheck = '/health';

  // Helper method for user by ID endpoint
  static String userById(String userId) => '/users/$userId';
} 