import 'package:flutter/material.dart' hide ThemeMode;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../theme/app_colors.dart';
import 'package:flutter/rendering.dart';

/// Service to manage app theme mode and preferences
class ThemeService extends ChangeNotifier {
  static const String _themePreferenceKey = 'app_theme_mode';
  
  // Singleton instance
  static final ThemeService _instance = ThemeService._internal();
  
  // Factory constructor
  factory ThemeService() => _instance;
  
  // Internal constructor
  ThemeService._internal();
  
  // Private variables
  bool _isInitialized = false;
  late PackageInfo _packageInfo;
  
  /// Initialize the service and load saved preferences
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Get package info
      _packageInfo = await PackageInfo.fromPlatform();
      
      // Load theme preferences
      final prefs = await SharedPreferences.getInstance();
      final savedThemeMode = prefs.getString(_themePreferenceKey);
      
      if (savedThemeMode != null) {
        // Convert string to enum
        if (savedThemeMode == 'dark') {
          AppColors.currentTheme = ThemeMode.dark;
        } else {
          AppColors.currentTheme = ThemeMode.light;
        }
      } else {
        // If no saved preference, check system preference
        final window = WidgetsBinding.instance.platformDispatcher;
        final platformBrightness = window.platformBrightness;
        
        if (platformBrightness == Brightness.dark) {
          AppColors.currentTheme = ThemeMode.dark;
        } else {
          AppColors.currentTheme = ThemeMode.light;
        }
        
        // Save the theme preference based on system
        await _saveThemePreference();
      }
      
      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to load theme preferences: $e');
    }
  }
  
  /// Get the current theme mode
  ThemeMode get currentThemeMode => AppColors.currentTheme;
  
  /// Check if the app is using dark mode
  bool get isDarkMode => AppColors.currentTheme == ThemeMode.dark;
  
  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    AppColors.toggleTheme();
    await _saveThemePreference();
    
    // Update system UI based on theme
    _updateSystemUI();
    
    // Notify listeners to rebuild widgets
    notifyListeners();
  }
  
  /// Set a specific theme mode
  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (AppColors.currentTheme == themeMode) return;
    
    AppColors.currentTheme = themeMode;
    await _saveThemePreference();
    
    // Update system UI based on theme
    _updateSystemUI();
    
    // Notify listeners to rebuild widgets
    notifyListeners();
  }
  
  /// Save the current theme preference
  Future<void> _saveThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeString = AppColors.currentTheme == ThemeMode.dark 
          ? 'dark' 
          : 'light';
      
      await prefs.setString(_themePreferenceKey, themeString);
    } catch (e) {
      debugPrint('Failed to save theme preference: $e');
    }
  }
  
  /// Update system UI based on current theme
  void _updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.surface,
        statusBarBrightness: statusBarBrightness,
        statusBarIconBrightness: statusBarIconBrightness,
      ),
    );
  }
  
  /// Returns appropriate status bar brightness based on theme
  Brightness get statusBarBrightness {
    return AppColors.currentTheme == ThemeMode.dark
        ? Brightness.dark
        : Brightness.light;
  }
  
  /// Returns appropriate status bar icon brightness based on theme
  Brightness get statusBarIconBrightness {
    return AppColors.currentTheme == ThemeMode.dark
        ? Brightness.light
        : Brightness.dark;
  }
  
  /// Get app version
  String get appVersion => _isInitialized ? _packageInfo.version : '';
  
  /// Get app build number
  String get buildNumber => _isInitialized ? _packageInfo.buildNumber : '';
} 