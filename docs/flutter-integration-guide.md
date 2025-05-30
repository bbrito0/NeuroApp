# Flutter Integration Guide for ChronoWell

This guide explains how to connect your Flutter app with Firebase authentication to the ChronoWell backend through the gateway service.

## Overview

The integration flow works as follows:
1. **Flutter App** → Authenticates with Firebase
2. **Flutter App** → Gets Firebase ID token
3. **Flutter App** → Sends HTTP requests to Gateway (port 5001) with Firebase token
4. **Gateway** → Validates Firebase token
5. **Gateway** → Forwards request to Backend with user context
6. **Backend** → Processes request and returns response

## Prerequisites

- Flutter app with Firebase authentication already set up
- ChronoWell Gateway running on port 5001
- ChronoWell Backend running on port 5002
- Firebase project properly configured

## Required Dependencies

Add these dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.1.0
  firebase_auth: ^4.15.3
  firebase_core: ^2.24.2
```

## 1. API Service Setup

Create the main API service class to handle all HTTP requests:

### `lib/services/api_service.dart`

```dart
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class ApiService {
  // Gateway URL - Update this to match your gateway port
  static const String baseUrl = 'http://localhost:5001';
  
  // For device testing:
  // Android Emulator: 'http://10.0.2.2:5001'
  // iOS Simulator: 'http://localhost:5001'
  // Real Device: 'http://[YOUR_COMPUTER_IP]:5001'
  
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
      throw Exception('User not authenticated');
    }
    
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    
    final url = Uri.parse('$baseUrl$endpoint');
    
    switch (method.toUpperCase()) {
      case 'GET':
        return await http.get(url, headers: headers);
      case 'POST':
        return await http.post(
          url,
          headers: headers,
          body: body != null ? json.encode(body) : null,
        );
      case 'PUT':
        return await http.put(
          url,
          headers: headers,
          body: body != null ? json.encode(body) : null,
        );
      case 'PATCH':
        return await http.patch(
          url,
          headers: headers,
          body: body != null ? json.encode(body) : null,
        );
      case 'DELETE':
        return await http.delete(url, headers: headers);
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  }
  
  /// Test gateway connectivity (no authentication required)
  Future<bool> checkConnection() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/healthz'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  /// Create user in backend after Firebase authentication
  Future<Map<String, dynamic>> signupUser({
    required String username,
    required String name,
  }) async {
    final response = await _makeAuthenticatedRequest(
      'POST',
      '/api/v1/users/signup',
      body: {
        'username': username,
        'name': name,
      },
    );
    
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create user: ${response.body}');
    }
  }
  
  /// Get current authenticated user's profile
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await _makeAuthenticatedRequest('GET', '/api/v1/users/');
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get user: ${response.body}');
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
      '/api/v1/users/',
      body: body,
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update user: ${response.body}');
    }
  }
  
  /// Get user by ID
  Future<Map<String, dynamic>> getUserById(String userId) async {
    final response = await _makeAuthenticatedRequest(
      'GET',
      '/api/v1/users/$userId',
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get user: ${response.body}');
    }
  }
  
  /// Delete user account
  Future<bool> deleteUser(String userId) async {
    final response = await _makeAuthenticatedRequest(
      'DELETE',
      '/api/v1/users/$userId',
    );
    
    return response.statusCode == 204;
  }
}
```

## 2. Authentication Service

Create an authentication service that combines Firebase auth with backend user management:

### `lib/services/auth_service.dart`

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'api_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiService _apiService = ApiService();
  
  /// Sign in with Firebase and get/create user in backend
  Future<Map<String, dynamic>?> signInAndSetupUser(
    String email,
    String password,
    {String? username, String? name}
  ) async {
    try {
      // 1. Authenticate with Firebase
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        // 2. Try to get existing user from backend
        try {
          final userData = await _apiService.getCurrentUser();
          return userData;
        } catch (e) {
          // 3. If user doesn't exist in backend, create them
          if (username != null && name != null) {
            final userData = await _apiService.signupUser(
              username: username,
              name: name,
            );
            return userData;
          }
          throw Exception('User not found in backend and insufficient data to create');
        }
      }
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
    return null;
  }
  
  /// Sign up with Firebase and create user in backend
  Future<Map<String, dynamic>?> signUpAndCreateUser(
    String email,
    String password,
    String username,
    String name,
  ) async {
    try {
      // 1. Create Firebase user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        // 2. Create user in backend
        final userData = await _apiService.signupUser(
          username: username,
          name: name,
        );
        return userData;
      }
    } catch (e) {
      print('Sign up error: $e');
      rethrow;
    }
    return null;
  }
  
  /// Sign out from Firebase
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  /// Get current Firebase user
  User? get currentUser => _auth.currentUser;
  
  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
```

## 3. Usage Examples

### Sign Up Flow

```dart
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  
  String _email = '';
  String _password = '';
  String _username = '';
  String _name = '';
  bool _isLoading = false;
  
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final userData = await _authService.signUpAndCreateUser(
        _email,
        _password,
        _username,
        _name,
      );
      
      if (userData != null) {
        // Navigate to home page or show success
        print('User created: $userData');
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onChanged: (value) => _email = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.length < 6 ? 'At least 6 characters' : null,
                onChanged: (value) => _password = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onChanged: (value) => _username = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onChanged: (value) => _name = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                child: _isLoading 
                  ? CircularProgressIndicator() 
                  : Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### User Profile Page

```dart
class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? error;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  Future<void> _loadUserData() async {
    try {
      final data = await _apiService.getCurrentUser();
      setState(() {
        userData = data;
        isLoading = false;
        error = null;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        error = e.toString();
      });
    }
  }
  
  Future<void> _updateProfile(String newName) async {
    try {
      final updatedData = await _apiService.updateUser(name: newName);
      setState(() {
        userData = updatedData;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: _loadUserData,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: userData != null
          ? Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: ListTile(
                      title: Text('Name'),
                      subtitle: Text(userData!['name'] ?? 'Not set'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditDialog('name'),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('Username'),
                      subtitle: Text(userData!['username'] ?? 'Not set'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditDialog('username'),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('Email'),
                      subtitle: Text(userData!['email'] ?? 'Not set'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('User ID'),
                      subtitle: Text(userData!['id'] ?? 'Not set'),
                    ),
                  ),
                ],
              ),
            )
          : Center(child: Text('No user data available')),
    );
  }
  
  void _showEditDialog(String field) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${field.toUpperCase()}'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: field),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (field == 'name') {
                _updateProfile(controller.text);
              }
              // Add username update logic if needed
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
```

## 4. Network Configuration

### Development Environment

- **Gateway URL:** `http://localhost:5001`
- **Backend URL:** `http://localhost:5002` (internal to gateway)

### Testing on Different Platforms

| Platform | URL |
|----------|-----|
| Android Emulator | `http://10.0.2.2:5001` |
| iOS Simulator | `http://localhost:5001` |
| Real Device | `http://[YOUR_COMPUTER_IP]:5001` |

To find your computer's IP address:
- **macOS/Linux:** `ifconfig | grep inet`
- **Windows:** `ipconfig`

## 5. Error Handling

The API returns these HTTP status codes:

| Status Code | Meaning | Action |
|-------------|---------|--------|
| 200 | Success | Process response data |
| 201 | Created | User/resource created successfully |
| 204 | No Content | Deletion successful |
| 401 | Unauthorized | Invalid/missing Firebase token |
| 404 | Not Found | User or resource not found |
| 409 | Conflict | Username/email already exists |
| 500 | Server Error | Internal server error |

Example error handling:

```dart
try {
  final userData = await apiService.getCurrentUser();
  // Handle success
} on Exception catch (e) {
  if (e.toString().contains('401')) {
    // Redirect to login
    Navigator.of(context).pushReplacementNamed('/login');
  } else if (e.toString().contains('404')) {
    // User not found, maybe create user
    showDialog(/* ... */);
  } else {
    // General error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
```

## 6. Testing Connection

Add this test widget to verify connectivity:

```dart
class ConnectionTestWidget extends StatefulWidget {
  @override
  _ConnectionTestWidgetState createState() => _ConnectionTestWidgetState();
}

class _ConnectionTestWidgetState extends State<ConnectionTestWidget> {
  final ApiService _apiService = ApiService();
  String _status = 'Not tested';
  
  Future<void> _testConnection() async {
    setState(() => _status = 'Testing...');
    
    try {
      // Test gateway health
      final isConnected = await _apiService.checkConnection();
      if (!isConnected) {
        setState(() => _status = 'Gateway not reachable');
        return;
      }
      
      // Test authenticated endpoint
      final userData = await _apiService.getCurrentUser();
      setState(() => _status = 'Success: ${userData['name']}');
      
    } catch (e) {
      setState(() => _status = 'Error: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Connection Status: $_status'),
        ElevatedButton(
          onPressed: _testConnection,
          child: Text('Test Connection'),
        ),
      ],
    );
  }
}
```

## 7. Security Best Practices

1. **Token Refresh:** Firebase automatically handles token refresh
2. **HTTPS:** Use HTTPS in production
3. **Error Messages:** Don't expose sensitive information in error messages
4. **Network Security:** Implement certificate pinning for production
5. **Local Storage:** Don't store sensitive data in local storage

## 8. Troubleshooting

### Common Issues

1. **Connection Refused**
   - Check if gateway is running on port 5001
   - Verify network configuration for your platform

2. **401 Unauthorized**
   - Ensure Firebase user is signed in
   - Check if Firebase token is being sent correctly

3. **404 Not Found**
   - User might not exist in backend
   - Call signup endpoint first

4. **Firebase Token Expired**
   - Firebase handles this automatically
   - If issues persist, sign out and sign in again

### Debug Logging

Add logging to track requests:

```dart
// In ApiService
print('Making request to: $url');
print('Headers: $headers');
print('Body: ${body != null ? json.encode(body) : 'null'}');
print('Response: ${response.statusCode} - ${response.body}');
```

## Conclusion

This integration allows your Flutter app to seamlessly authenticate users with Firebase and manage their data through the ChronoWell backend. The gateway handles token validation and forwards requests with proper user context, ensuring secure and efficient communication between your mobile app and backend services. 