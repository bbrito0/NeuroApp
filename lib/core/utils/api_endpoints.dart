import 'dart:io';

class ApiEndpoints {
  static String getBaseUrlForPlatform() {
    // Platform-specific URLs for testing
    if (Platform.isAndroid) {
      // Android Emulator
      return 'http://10.0.2.2:5001';
    } else {
      // iOS Simulator and other platforms
      return 'http://localhost:5001';
    }
    
    // For Real Device testing, you would use:
    // return 'http://[YOUR_COMPUTER_IP]:5001';
  }

  // Auth endpoints - now include full API path
  static const String signup = '/api/v1/users/signup';
  static const String users = '/api/v1/users';
  static const String healthCheck = '/healthz';

  // Helper method for user by ID endpoint
  static String userById(String userId) => '/api/v1/users/$userId';
  
  // Debug helpers
  static String get baseUrl => getBaseUrlForPlatform();
  static String get signupUrl => '$baseUrl$signup';
  static String get usersUrl => '$baseUrl$users';
  static String get healthUrl => '$baseUrl$healthCheck';
} 