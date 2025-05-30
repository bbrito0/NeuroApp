import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import '../utils/api_endpoints.dart';
import '../models/api_exception.dart';

class ApiService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  /// Get Firebase ID Token for authenticated requests
  Future<String?> _getIdToken() async {
    final user = _auth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }
  
  /// Make authenticated HTTP request with Firebase token
  Future<http.Response> _makeAuthenticatedRequest(
    String method,
    String endpoint,
    {Map<String, dynamic>? body}
  ) async {
    final token = await _getIdToken();
    if (token == null) {
      throw AuthException('User not authenticated');
    }
    
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    
    final url = Uri.parse('${ApiEndpoints.getBaseUrlForPlatform()}$endpoint');
    
    // Debug logging
    print('DEBUG API: Making $method request to: $url');
    print('DEBUG API: Headers: $headers');
    if (body != null) {
      print('DEBUG API: Body: ${json.encode(body)}');
    }
    
    http.Response response;
    
    try {
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(url, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            url,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PATCH':
          response = await http.patch(
            url,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers);
          break;
        default:
          throw ApiException('Unsupported HTTP method: $method');
      }
      
      print('DEBUG API: Response status: ${response.statusCode}');
      print('DEBUG API: Response body: ${response.body}');
      
      return response;
    } catch (e) {
      print('DEBUG API: Request failed with error: $e');
      throw NetworkException('Network request failed: $e');
    }
  }
  
  /// Test gateway connectivity (no authentication required)
  Future<bool> checkConnection() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.getBaseUrlForPlatform()}${ApiEndpoints.healthCheck}')
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  /// Create user in backend after Firebase authentication
  Future<Map<String, dynamic>> signupUser({
    required String username,
    required String name,
    required String email,
    required String firebaseUid,
  }) async {
    final requestBody = {
      'username': username,
      'name': name,
      'email': email,
      'firebase_uid': firebaseUid,
    };
    
    final response = await _makeAuthenticatedRequest(
      'POST',
      ApiEndpoints.signup,
      body: requestBody,
    );
    
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else if (response.statusCode == 409) {
      throw UserConflictException('Username or email already exists');
    } else {
      throw ApiException('Failed to create user: ${response.body}', statusCode: response.statusCode);
    }
  }
  
  /// Get current authenticated user's profile
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await _makeAuthenticatedRequest('GET', ApiEndpoints.users);
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw UserNotFoundException();
    } else {
      throw ApiException('Failed to get user: ${response.body}', statusCode: response.statusCode);
    }
  }
  
  /// Update current user's profile
  Future<Map<String, dynamic>> updateUser({
    String? username,
    String? name,
  }) async {
    final body = <String, dynamic>{};
    if (username != null) body['username'] = username;
    if (name != null) body['name'] = name;
    
    final response = await _makeAuthenticatedRequest(
      'PATCH',
      ApiEndpoints.users,
      body: body,
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ApiException('Failed to update user: ${response.body}', statusCode: response.statusCode);
    }
  }
  
  /// Get user by ID
  Future<Map<String, dynamic>> getUserById(String userId) async {
    final response = await _makeAuthenticatedRequest(
      'GET',
      ApiEndpoints.userById(userId),
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw UserNotFoundException();
    } else {
      throw ApiException('Failed to get user: ${response.body}', statusCode: response.statusCode);
    }
  }
  
  /// Delete user account
  Future<bool> deleteUser(String userId) async {
    final response = await _makeAuthenticatedRequest(
      'DELETE',
      ApiEndpoints.userById(userId),
    );
    
    return response.statusCode == 204;
  }
} 