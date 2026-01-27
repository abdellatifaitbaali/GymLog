import '../models/user_profile.dart';
import '../config/constants.dart';

class CalculationResult {
  final double bmr;
  final double tdee;
  final int targetCalories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatsGrams;
  final double waterLiters;
  final double sleepHours;

  CalculationResult({
    required this.bmr,
    required this.tdee,
    required this.targetCalories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatsGrams,
    required this.waterLiters,
    required this.sleepHours,
  });
}

class CalculationService {
  /// Calculate BMR using the Mifflin-St Jeor Equation
  /// For men: BMR = 10W + 6.25H - 5A + 5
  /// For women: BMR = 10W + 6.25H - 5A - 161
  /// W = weight in kg, H = height in cm, A = age in years
  static double calculateBMR(UserProfile profile) {
    final weight = profile.weightInKg;
    final height = profile.heightInCm;
    final age = profile.age;

    if (profile.gender == Gender.male) {
      return (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      return (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }
  }

  /// Calculate TDEE (Total Daily Energy Expenditure)
  /// TDEE = BMR × Activity Multiplier
  static double calculateTDEE(UserProfile profile) {
    final bmr = calculateBMR(profile);
    final multiplier = _getActivityMultiplier(profile.activityLevel);
    return bmr * multiplier;
  }

  /// Calculate target calories based on goal
  static int calculateTargetCalories(UserProfile profile) {
    final tdee = calculateTDEE(profile);
    final adjustment = _getGoalAdjustment(profile.goal);
    return (tdee + adjustment).round();
  }

  /// Calculate daily protein requirement in grams
  /// Based on body weight and fitness goal
  static double calculateProtein(UserProfile profile) {
    final weightLbs = profile.weightInLbs;
    final multiplier = _getProteinMultiplier(profile.goal);
    return weightLbs * multiplier;
  }

  /// Calculate macro breakdown (protein, carbs, fats in grams)
  static Map<String, double> calculateMacros(UserProfile profile) {
    final targetCalories = calculateTargetCalories(profile);
    final protein = calculateProtein(profile);

    // Protein calories (4 cal/gram)
    final proteinCalories = protein * 4;

    // Fat: 25-30% of calories (9 cal/gram)
    final fatCalories = targetCalories * 0.25;
    final fatGrams = fatCalories / 9;

    // Remaining calories go to carbs (4 cal/gram)
    final carbCalories = targetCalories - proteinCalories - fatCalories;
    final carbGrams = carbCalories / 4;

    return {
      'protein': protein,
      'carbs': carbGrams > 0 ? carbGrams : 0,
      'fats': fatGrams,
    };
  }

  /// Calculate daily water intake in liters
  /// Based on body weight: 0.5 oz per pound, converted to liters
  static double calculateWaterIntake(UserProfile profile) {
    final weightLbs = profile.weightInLbs;
    final waterOz = weightLbs * AppConstants.waterOzPerLb;
    // Add more for active individuals
    final activityBonus = profile.activityLevel.index * 4; // oz
    return (waterOz + activityBonus) * 0.0295735; // Convert oz to liters
  }

  /// Get recommended sleep hours
  static double getRecommendedSleep() {
    return 8.0; // 7-9 hours recommended, 8 as target
  }

  /// Get full calculation result
  static CalculationResult getFullCalculation(UserProfile profile) {
    final bmr = calculateBMR(profile);
    final tdee = calculateTDEE(profile);
    final targetCalories = calculateTargetCalories(profile);
    final macros = calculateMacros(profile);
    final water = calculateWaterIntake(profile);
    final sleep = getRecommendedSleep();

    return CalculationResult(
      bmr: bmr,
      tdee: tdee,
      targetCalories: targetCalories,
      proteinGrams: macros['protein']!,
      carbsGrams: macros['carbs']!,
      fatsGrams: macros['fats']!,
      waterLiters: water,
      sleepHours: sleep,
    );
  }

  // Helper methods
  static double _getActivityMultiplier(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return AppConstants.activityMultipliers['sedentary']!;
      case ActivityLevel.light:
        return AppConstants.activityMultipliers['light']!;
      case ActivityLevel.moderate:
        return AppConstants.activityMultipliers['moderate']!;
      case ActivityLevel.active:
        return AppConstants.activityMultipliers['active']!;
      case ActivityLevel.veryActive:
        return AppConstants.activityMultipliers['veryActive']!;
    }
  }

  static int _getGoalAdjustment(FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.lose:
        return AppConstants.goalCalorieAdjustment['lose']!;
      case FitnessGoal.maintain:
        return AppConstants.goalCalorieAdjustment['maintain']!;
      case FitnessGoal.gain:
        return AppConstants.goalCalorieAdjustment['gain']!;
    }
  }

  static double _getProteinMultiplier(FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.lose:
        return AppConstants.proteinMultipliers[
            'buildMuscleLean']!; // Higher protein when cutting
      case FitnessGoal.maintain:
        return AppConstants.proteinMultipliers['maintain']!;
      case FitnessGoal.gain:
        return AppConstants.proteinMultipliers['buildMuscle']!;
    }
  }
}
