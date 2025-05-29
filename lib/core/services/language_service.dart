import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  // Default locale
  Locale _locale = const Locale('en');
  
  // Getter for current locale
  Locale get locale => _locale;
  
  // Available languages - only English and Portuguese as per requirements
  final List<Locale> supportedLocales = [
    const Locale('en'), // English
    const Locale('pt'), // Portuguese
  ];
  
  // Get language name from locale
  String getDisplayLanguage(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'pt':
        return 'Português';
      default:
        return 'English';
    }
  }
  
  // Initialize service from saved preferences
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('language_code');
      
      if (savedLanguage != null && supportedLocales.any((locale) => locale.languageCode == savedLanguage)) {
        _locale = Locale(savedLanguage);
      }
    } catch (e) {
      // Default to English if there's an error
      _locale = const Locale('en');
    }
    
    notifyListeners();
  }
  
  // Change language
  Future<void> setLanguage(String languageCode) async {
    if (!supportedLocales.any((locale) => locale.languageCode == languageCode)) {
      return; // Invalid language code
    }
    
    _locale = Locale(languageCode);
    
    try {
      // Save preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', languageCode);
    } catch (e) {
      // Handle error (optional)
    }
    
    notifyListeners();
  }
} 