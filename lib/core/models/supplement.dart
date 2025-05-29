import 'package:flutter/material.dart';

class Supplement {
  final String code;
  final String name;
  final String description;
  final List<String> benefits;
  final String dosage;
  final Color accentColor;

  const Supplement({
    required this.code,
    required this.name,
    required this.description,
    required this.benefits,
    required this.dosage,
    required this.accentColor,
  });

  // Predefined supplements
  static const REVERSE = Supplement(
    code: 'REVERSE',
    name: 'REVERSE',
    description: 'Focus on cellular health and memory',
    benefits: ['Improved memory', 'Enhanced cellular health', 'Increased mental clarity', 'Better focus'],
    dosage: '1 capsule daily with food',
    accentColor: Color(0xFF4169E1), // Royal Blue
  );

  static const RELAX = Supplement(
    code: 'RELAX',
    name: 'RELAX',
    description: 'Focus on stress relief and sleep',
    benefits: ['Reduced stress levels', 'Improved sleep quality', 'Enhanced relaxation', 'Mood balance'],
    dosage: '1 capsule before bedtime',
    accentColor: Color(0xFF9932CC), // Dark Orchid
  );

  static const RECOVER = Supplement(
    code: 'RECOVER',
    name: 'RECOVER',
    description: 'Focus on cognitive recovery and memory',
    benefits: ['Cognitive regeneration', 'Memory enhancement', 'Mental fatigue reduction', 'Improved recall'],
    dosage: '1 capsule twice daily',
    accentColor: Color(0xFF32CD32), // Lime Green
  );

  static const REVITA = Supplement(
    code: 'REVITA',
    name: 'REVITA',
    description: 'Focus on energy and physical recovery',
    benefits: ['Increased energy levels', 'Improved stamina', 'Enhanced physical recovery', 'Mental alertness'],
    dosage: '1 capsule in the morning',
    accentColor: Color(0xFFFF8C00), // Dark Orange
  );

  static const RESTORE = Supplement(
    code: 'RESTORE',
    name: 'RESTORE',
    description: 'Focus on cognitive enhancement',
    benefits: ['Enhanced cognitive function', 'Improved mental processing', 'Better problem solving', 'Increased focus'],
    dosage: '1 capsule daily',
    accentColor: Color(0xFF00CED1), // Dark Turquoise
  );

  static const RESET = Supplement(
    code: 'RESET',
    name: 'RESET',
    description: 'Focus on sleep and rest',
    benefits: ['Better sleep quality', 'Reduced insomnia', 'Natural sleep cycle restoration', 'Mental refreshment'],
    dosage: '1 capsule 30 minutes before sleep',
    accentColor: Color(0xFF6A5ACD), // Slate Blue
  );

  static const REGEN = Supplement(
    code: 'REGEN',
    name: 'REGEN',
    description: 'Focus on immune system',
    benefits: ['Immune system support', 'Enhanced recovery', 'Cellular regeneration', 'Overall well-being'],
    dosage: '1 capsule with breakfast',
    accentColor: Color(0xFF20B2AA), // Light Sea Green
  );

  // Get all standard supplements
  static List<Supplement> getAllSupplements() {
    return [REVERSE, RELAX, RECOVER, REVITA, RESTORE, RESET, REGEN];
  }

  // Get supplement by code
  static Supplement? getByCode(String code) {
    try {
      return getAllSupplements().firstWhere((s) => s.code == code);
    } catch (e) {
      return null;
    }
  }
} 