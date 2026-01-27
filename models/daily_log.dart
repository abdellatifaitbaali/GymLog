class DailyLog {
  final DateTime date;
  final int caloriesConsumed;
  final int caloriesTarget;
  final double proteinConsumed; // grams
  final double proteinTarget; // grams
  final double waterConsumed; // liters
  final double waterTarget; // liters
  final double sleepHours;
  final double sleepTarget;
  final String? notes;

  DailyLog({
    required this.date,
    this.caloriesConsumed = 0,
    this.caloriesTarget = 2000,
    this.proteinConsumed = 0,
    this.proteinTarget = 100,
    this.waterConsumed = 0,
    this.waterTarget = 2.5,
    this.sleepHours = 0,
    this.sleepTarget = 8,
    this.notes,
  });

  // Calculate progress percentages
  double get calorieProgress => caloriesTarget > 0
      ? (caloriesConsumed / caloriesTarget).clamp(0.0, 1.5)
      : 0;

  double get proteinProgress =>
      proteinTarget > 0 ? (proteinConsumed / proteinTarget).clamp(0.0, 1.5) : 0;

  double get waterProgress =>
      waterTarget > 0 ? (waterConsumed / waterTarget).clamp(0.0, 1.5) : 0;

  double get sleepProgress =>
      sleepTarget > 0 ? (sleepHours / sleepTarget).clamp(0.0, 1.5) : 0;

  // Check if goals are met
  bool get isCalorieGoalMet => calorieProgress >= 1.0;
  bool get isProteinGoalMet => proteinProgress >= 1.0;
  bool get isWaterGoalMet => waterProgress >= 1.0;
  bool get isSleepGoalMet => sleepProgress >= 1.0;

  int get goalsMetCount {
    int count = 0;
    if (isCalorieGoalMet) count++;
    if (isProteinGoalMet) count++;
    if (isWaterGoalMet) count++;
    if (isSleepGoalMet) count++;
    return count;
  }

  DailyLog copyWith({
    DateTime? date,
    int? caloriesConsumed,
    int? caloriesTarget,
    double? proteinConsumed,
    double? proteinTarget,
    double? waterConsumed,
    double? waterTarget,
    double? sleepHours,
    double? sleepTarget,
    String? notes,
  }) {
    return DailyLog(
      date: date ?? this.date,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      caloriesTarget: caloriesTarget ?? this.caloriesTarget,
      proteinConsumed: proteinConsumed ?? this.proteinConsumed,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      waterConsumed: waterConsumed ?? this.waterConsumed,
      waterTarget: waterTarget ?? this.waterTarget,
      sleepHours: sleepHours ?? this.sleepHours,
      sleepTarget: sleepTarget ?? this.sleepTarget,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'caloriesConsumed': caloriesConsumed,
      'caloriesTarget': caloriesTarget,
      'proteinConsumed': proteinConsumed,
      'proteinTarget': proteinTarget,
      'waterConsumed': waterConsumed,
      'waterTarget': waterTarget,
      'sleepHours': sleepHours,
      'sleepTarget': sleepTarget,
      'notes': notes,
    };
  }

  factory DailyLog.fromJson(Map<String, dynamic> json) {
    return DailyLog(
      date: DateTime.parse(json['date']),
      caloriesConsumed: json['caloriesConsumed'],
      caloriesTarget: json['caloriesTarget'],
      proteinConsumed: json['proteinConsumed'].toDouble(),
      proteinTarget: json['proteinTarget'].toDouble(),
      waterConsumed: json['waterConsumed'].toDouble(),
      waterTarget: json['waterTarget'].toDouble(),
      sleepHours: json['sleepHours'].toDouble(),
      sleepTarget: json['sleepTarget'].toDouble(),
      notes: json['notes'],
    );
  }

  // Get unique key for storage
  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
