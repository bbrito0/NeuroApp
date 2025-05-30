import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/models/api_exception.dart';
import 'auth_api_service.dart';
import '../models/signup_request.dart';
import '../models/user_response.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthApiService _authApiService = AuthApiService();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthService() {
    // Listen to authentication state changes
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      _errorMessage = null;
      notifyListeners();
    });
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void _setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  /// Sign up with Firebase and create user in backend
  Future<UserResponse?> signUpAndCreateUser(
    String email,
    String password,
    String username,
    String name,
  ) async {
    try {
      _setLoading(true);
      clearError();

      // 1. Create Firebase user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update display name in Firebase
        await credential.user?.updateDisplayName(name);

        // 2. Create user in backend
        final signupRequest = SignupRequest(
          username: username,
          name: name,
          email: email,
          firebaseUid: credential.user!.uid,
        );
        
        final userData = await _authApiService.signupUser(signupRequest);
        _setLoading(false);
        return userData;
      }
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      switch (e.code) {
        case 'weak-password':
          _setError('The password provided is too weak.');
          break;
        case 'email-already-in-use':
          _setError('An account already exists for that email.');
          break;
        case 'invalid-email':
          _setError('The email address is not valid.');
          break;
        default:
          _setError('Registration failed: ${e.message}');
      }
    } catch (e) {
      _setLoading(false);
      _setError('An unexpected error occurred: $e');
      print('Sign up error: $e');
    }
    return null;
  }

  /// Simple sign in with Firebase only (no backend interaction)
  Future<User?> signIn(String email, String password) async {
    try {
      _setLoading(true);
      clearError();

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _setLoading(false);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      switch (e.code) {
        case 'user-not-found':
          _setError('No user found for that email.');
          break;
        case 'wrong-password':
          _setError('Wrong password provided.');
          break;
        case 'invalid-email':
          _setError('The email address is not valid.');
          break;
        case 'user-disabled':
          _setError('This user account has been disabled.');
          break;
        default:
          _setError('Login failed: ${e.message}');
      }
    } catch (e) {
      _setLoading(false);
      _setError('An unexpected error occurred: $e');
      print('Sign in error: $e');
    }
    return null;
  }

  /// Sign in with Firebase and get/create user in backend
  Future<UserResponse?> signInAndSetupUser(
    String email,
    String password, {
    String? username,
    String? name,
  }) async {
    try {
      _setLoading(true);
      clearError();

      // 1. Authenticate with Firebase
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // 2. Try to get existing user from backend
        try {
          final userData = await _authApiService.getCurrentUser();
          _setLoading(false);
          return userData;
        } catch (e) {
          // 3. If user doesn't exist in backend, create them
          if (e is UserNotFoundException && username != null && name != null) {
            final signupRequest = SignupRequest(
              username: username,
              name: name,
              email: email,
              firebaseUid: credential.user!.uid,
            );
            final userData = await _authApiService.signupUser(signupRequest);
            _setLoading(false);
            return userData;
          }
          throw ApiException('User not found in backend and insufficient data to create');
        }
      }
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      switch (e.code) {
        case 'user-not-found':
          _setError('No user found for that email.');
          break;
        case 'wrong-password':
          _setError('Wrong password provided.');
          break;
        case 'invalid-email':
          _setError('The email address is not valid.');
          break;
        case 'user-disabled':
          _setError('This user account has been disabled.');
          break;
        default:
          _setError('Login failed: ${e.message}');
      }
    } catch (e) {
      _setLoading(false);
      _setError('An unexpected error occurred: $e');
      print('Sign in error: $e');
    }
    return null;
  }

  /// Sign out from Firebase
  Future<void> signOut() async {
    try {
      _setLoading(true);
      clearError();
      await _auth.signOut();
      _user = null;
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      _setError('Failed to sign out: $e');
    }
  }

  /// Get current user profile from backend
  Future<UserResponse?> getCurrentUserProfile() async {
    if (!isAuthenticated) return null;
    
    try {
      return await _authApiService.getCurrentUser();
    } catch (e) {
      print('Failed to get user profile: $e');
      return null;
    }
  }

  /// Update user profile in backend
  Future<UserResponse?> updateUserProfile({String? username, String? name}) async {
    if (!isAuthenticated) return null;
    
    try {
      if (name != null) {
        await _user?.updateDisplayName(name);
      }
      return await _authApiService.updateUser(username: username, name: name);
    } catch (e) {
      _setError('Failed to update profile: $e');
      return null;
    }
  }
} 