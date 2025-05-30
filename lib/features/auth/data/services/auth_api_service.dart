import '../../../../core/services/api_service.dart';
import '../../../../core/models/api_exception.dart';
import '../models/signup_request.dart';
import '../models/user_response.dart';

class AuthApiService {
  final ApiService _apiService = ApiService();
  
  /// Test gateway connectivity (no auth required)
  Future<bool> checkConnection() async {
    try {
      return await _apiService.checkConnection();
    } catch (e) {
      return false;
    }
  }
  
  /// Sign up user in backend after Firebase auth
  Future<UserResponse> signupUser(SignupRequest request) async {
    try {
      final responseData = await _apiService.signupUser(
        username: request.username,
        name: request.name,
        email: request.email,
        firebaseUid: request.firebaseUid,
      );
      return UserResponse.fromJson(responseData);
    } catch (e) {
      if (e is UserConflictException) {
        rethrow;
      }
      throw ApiException('Signup failed: $e');
    }
  }
  
  /// Get current user profile
  Future<UserResponse> getCurrentUser() async {
    try {
      final responseData = await _apiService.getCurrentUser();
      return UserResponse.fromJson(responseData);
    } catch (e) {
      if (e is UserNotFoundException) {
        rethrow;
      }
      throw ApiException('Failed to get user: $e');
    }
  }
  
  /// Update user profile
  Future<UserResponse> updateUser({String? username, String? name}) async {
    try {
      final responseData = await _apiService.updateUser(
        username: username,
        name: name,
      );
      return UserResponse.fromJson(responseData);
    } catch (e) {
      throw ApiException('Failed to update user: $e');
    }
  }
  
  /// Get user by ID
  Future<UserResponse> getUserById(String userId) async {
    try {
      final responseData = await _apiService.getUserById(userId);
      return UserResponse.fromJson(responseData);
    } catch (e) {
      if (e is UserNotFoundException) {
        rethrow;
      }
      throw ApiException('Failed to get user: $e');
    }
  }
  
  /// Delete user account
  Future<bool> deleteUser(String userId) async {
    try {
      return await _apiService.deleteUser(userId);
    } catch (e) {
      throw ApiException('Failed to delete user: $e');
    }
  }
} 