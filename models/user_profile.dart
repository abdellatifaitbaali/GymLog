enum Gender { male, female }

enum ActivityLevel { sedentary, light, moderate, active, veryActive }

enum FitnessGoal { lose, maintain, gain }

enum UnitSystem { metric, imperial }

class UserProfile {
  final String? name;
  final int age;
  final double weight; // kg or lbs based on unitSystem
  final double height; // cm or inches based on unitSystem
  final Gender gender;
  final ActivityLevel activityLevel;
  final FitnessGoal goal;
  final UnitSystem unitSystem;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.activityLevel,
    required this.goal,
    this.unitSystem = UnitSystem.metric,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert weight to kg if in imperial
  double get weightInKg {
    return unitSystem == UnitSystem.imperial ? weight * 0.453592 : weight;
  }

  // Convert weight to lbs if in metric
  double get weightInLbs {
    return unitSystem == UnitSystem.metric ? weight * 2.20462 : weight;
  }

  // Convert height to cm if in imperial
  double get heightInCm {
    return unitSystem == UnitSystem.imperial ? height * 2.54 : height;
  }

  // Convert height to inches if in metric
  double get heightInInches {
    return unitSystem == UnitSystem.metric ? height / 2.54 : height;
  }

  UserProfile copyWith({
    String? name,
    int? age,
    double? weight,
    double? height,
    Gender? gender,
    ActivityLevel? activityLevel,
    FitnessGoal? goal,
    UnitSystem? unitSystem,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      unitSystem: unitSystem ?? this.unitSystem,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender.index,
      'activityLevel': activityLevel.index,
      'goal': goal.index,
      'unitSystem': unitSystem.index,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      age: json['age'],
      weight: json['weight'].toDouble(),
      height: json['height'].toDouble(),
      gender: Gender.values[json['gender']],
      activityLevel: ActivityLevel.values[json['activityLevel']],
      goal: FitnessGoal.values[json['goal']],
      unitSystem: UnitSystem.values[json['unitSystem']],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
