import 'package:flutter/material.dart';
import '../../data/services/auth_api_service.dart';
import '../../data/services/auth_service.dart';
import '../../../../core/models/api_exception.dart';
import 'package:provider/provider.dart';

class ApiTestWidget extends StatefulWidget {
  const ApiTestWidget({Key? key}) : super(key: key);

  @override
  State<ApiTestWidget> createState() => _ApiTestWidgetState();
}

class _ApiTestWidgetState extends State<ApiTestWidget> {
  final AuthApiService _authApiService = AuthApiService();
  late AuthService _authService;
  
  String _status = 'Ready to test';
  bool _isLoading = false;
  
  final _testEmailController = TextEditingController(text: 'test@example.com');
  final _testPasswordController = TextEditingController(text: 'Test123!');
  final _testUsernameController = TextEditingController(text: 'testuser');
  final _testNameController = TextEditingController(text: 'Test User');

  @override
  void initState() {
    super.initState();
    _authService = Provider.of<AuthService>(context, listen: false);
    _testEmailController.text = 'test@example.com';
    _testPasswordController.text = 'Test123!';
    _testUsernameController.text = 'testuser';
    _testNameController.text = 'Test User';
  }

  @override
  void dispose() {
    _testEmailController.dispose();
    _testPasswordController.dispose();
    _testUsernameController.dispose();
    _testNameController.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing gateway connection...';
    });

    try {
      final isConnected = await _authApiService.checkConnection();
      setState(() {
        _status = isConnected 
            ? '✅ Gateway connection successful' 
            : '❌ Gateway connection failed - Check if gateway is running on port 5001';
      });
    } catch (e) {
      setState(() {
        _status = '❌ Connection error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testAuthRequest() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing auth request...';
    });

    try {
      if (!_authService.isAuthenticated) {
        await _authService.signUpAndCreateUser(
          _testEmailController.text,
          _testPasswordController.text,
          _testUsernameController.text,
          _testNameController.text,
        );
      }

      final userProfile = await _authService.getCurrentUserProfile();
      setState(() {
        _status = 'Auth request successful!\nUser profile: ${userProfile?.toString()}';
      });
    } catch (e) {
      setState(() {
        _status = 'Auth request failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testSignup() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing full signup flow...';
    });

    try {
      final user = await _authService.signUpAndCreateUser(
        _testEmailController.text,
        _testPasswordController.text,
        _testUsernameController.text,
        _testNameController.text,
      );
      
      if (user != null) {
        setState(() {
          _status = '✅ Signup successful!\nUser created: ${user.username} (${user.name})\nID: ${user.id}';
        });
      } else {
        setState(() {
          _status = '❌ Signup failed: No user returned';
        });
      }
    } catch (e) {
      setState(() {
        if (e is UserConflictException) {
          _status = '❌ User already exists. Try signing in instead.';
        } else {
          _status = '❌ Signup error: $e';
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testSignin() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing sign in flow...';
    });

    try {
      final user = await _authService.signInAndSetupUser(
        _testEmailController.text,
        _testPasswordController.text,
        username: _testUsernameController.text,
        name: _testNameController.text,
      );
      
      if (user != null) {
        setState(() {
          _status = '✅ Sign in successful!\nUser: ${user.username} (${user.name})\nID: ${user.id}';
        });
      } else {
        setState(() {
          _status = '❌ Sign in failed: No user returned';
        });
      }
    } catch (e) {
      setState(() {
        _status = '❌ Sign in error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleSignOut() async {
    await _authService.signOut();
    setState(() {
      _status = 'Signed out successfully';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'API Connection Test',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  _buildAuthStatus(),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _status,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Test credentials form
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test Credentials',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _testEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  TextField(
                    controller: _testPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  TextField(
                    controller: _testUsernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  TextField(
                    controller: _testNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Test buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: _isLoading ? null : _testConnection,
                child: const Text('Test Gateway'),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _testSignup,
                child: const Text('Test Signup'),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _testSignin,
                child: const Text('Test Sign In'),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _testAuthRequest,
                child: const Text('Test Auth Request'),
              ),
              _buildSignOutButton(),
            ],
          ),
          
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildAuthStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Auth Status:'),
        Text(
          _authService.isAuthenticated && _authService.user != null
              ? 'Authenticated (${_authService.user?.email})'
              : 'Not Authenticated',
          style: TextStyle(
            color: _authService.isAuthenticated ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildSignOutButton() {
    return ElevatedButton(
      onPressed: _authService.isAuthenticated ? _handleSignOut : null,
      child: Text('Sign Out'),
    );
  }
} 