class AppConstants {
  static const String appName = 'GymLog';
  static const String appSubtitle = 'Health Calculator';
  static const String appVersion = '1.0.0';

  // Activity Level Multipliers for TDEE
  static const Map<String, double> activityMultipliers = {
    'sedentary': 1.2, // Little or no exercise
    'light': 1.375, // Light exercise 1-3 days/week
    'moderate': 1.55, // Moderate exercise 3-5 days/week
    'active': 1.725, // Hard exercise 6-7 days/week
    'veryActive': 1.9, // Very hard exercise, physical job
  };

  // Protein multipliers (grams per pound of body weight)
  static const Map<String, double> proteinMultipliers = {
    'maintain': 0.8, // Maintain muscle
    'buildMuscle': 1.0, // Build muscle
    'buildMuscleLean': 1.2, // Build muscle while staying lean
  };

  // Goal calorie adjustments
  static const Map<String, int> goalCalorieAdjustment = {
    'lose': -500, // Lose ~1 lb/week
    'maintain': 0, // Maintain weight
    'gain': 300, // Gain muscle (lean bulk)
  };

  // Recommended values
  static const double minSleepHours = 7.0;
  static const double maxSleepHours = 9.0;
  static const double waterOzPerLb = 0.5; // oz per pound of body weight

  // UI Constants
  static const double cardRadius = 16.0;
  static const double buttonRadius = 12.0;
  static const double inputRadius = 12.0;
  static const double horizontalPadding = 20.0;
  static const double verticalPadding = 24.0;

  // Onboarding pages
  static const List<String> activityLevelDescriptions = [
    'Sedentary - Little or no exercise',
    'Lightly Active - Light exercise 1-3 days/week',
    'Moderately Active - Moderate exercise 3-5 days/week',
    'Very Active - Hard exercise 6-7 days/week',
    'Extra Active - Very hard exercise, physical job',
  ];

  static const List<String> goalDescriptions = [
    'Lose Weight - Burn fat while preserving muscle',
    'Maintain - Keep your current physique',
    'Build Muscle - Gain lean muscle mass',
  ];
}
