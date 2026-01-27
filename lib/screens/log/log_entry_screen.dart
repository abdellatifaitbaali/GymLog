import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/daily_log.dart';
import '../../services/calculation_service.dart';
import '../../services/storage_service.dart';

class LogEntryScreen extends StatefulWidget {
  final DailyLog todayLog;
  final CalculationResult calculation;

  const LogEntryScreen({
    super.key,
    required this.todayLog,
    required this.calculation,
  });

  @override
  State<LogEntryScreen> createState() => _LogEntryScreenState();
}

class _LogEntryScreenState extends State<LogEntryScreen> {
  late int _calories;
  late double _protein;
  late double _water;
  late double _sleep;

  @override
  void initState() {
    super.initState();
    _calories = widget.todayLog.caloriesConsumed;
    _protein = widget.todayLog.proteinConsumed;
    _water = widget.todayLog.waterConsumed;
    _sleep = widget.todayLog.sleepHours;
  }

  Future<void> _save() async {
    final updatedLog = widget.todayLog.copyWith(
      caloriesConsumed: _calories,
      proteinConsumed: _protein,
      waterConsumed: _water,
      sleepHours: _sleep,
    );
    await StorageService.saveDailyLog(updatedLog);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Today'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(
              'Save',
              style: TextStyle(
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calories
            _buildLogSection(
              'Calories',
              Icons.local_fire_department_rounded,
              AppTheme.calorieOrange,
              '$_calories',
              'kcal',
              widget.calculation.targetCalories.toString(),
              _calories / widget.calculation.targetCalories,
              (value) => setState(() => _calories = value.round()),
              0,
              (widget.calculation.targetCalories * 2).toDouble(),
              quickValues: [100, 250, 500],
            ),
            const SizedBox(height: 24),

            // Protein
            _buildLogSection(
              'Protein',
              Icons.fitness_center_rounded,
              AppTheme.proteinBlue,
              _protein.round().toString(),
              'grams',
              widget.calculation.proteinGrams.round().toString(),
              _protein / widget.calculation.proteinGrams,
              (value) => setState(() => _protein = value),
              0,
              widget.calculation.proteinGrams * 2,
              quickValues: [10, 25, 50],
            ),
            const SizedBox(height: 24),

            // Water
            _buildLogSection(
              'Water',
              Icons.water_drop_rounded,
              AppTheme.waterCyan,
              _water.toStringAsFixed(1),
              'liters',
              widget.calculation.waterLiters.toStringAsFixed(1),
              _water / widget.calculation.waterLiters,
              (value) => setState(() => _water = value),
              0,
              widget.calculation.waterLiters * 2,
              quickValues: [0.25, 0.5, 1.0],
              isDecimal: true,
            ),
            const SizedBox(height: 24),

            // Sleep
            _buildLogSection(
              'Sleep (Last Night)',
              Icons.bedtime_rounded,
              AppTheme.sleepPurple,
              _sleep.toStringAsFixed(1),
              'hours',
              widget.calculation.sleepHours.round().toString(),
              _sleep / widget.calculation.sleepHours,
              (value) => setState(() => _sleep = value),
              0,
              12,
              quickValues: [6.0, 7.0, 8.0],
              isDecimal: true,
            ),
            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Progress'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogSection(
    String title,
    IconData icon,
    Color color,
    String currentValue,
    String unit,
    String target,
    double progress,
    ValueChanged<double> onChanged,
    double min,
    double max, {
    required List<num> quickValues,
    bool isDecimal = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.surfaceDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Target: $target $unit',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              // Current value
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currentValue,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    unit,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: AppTheme.surfaceDark,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).round().clamp(0, 999)}% of daily goal',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 16),

          // Slider
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: AppTheme.surfaceDark,
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.2),
              trackHeight: 6,
            ),
            child: Slider(
              value: isDecimal
                  ? (currentValue == '0.0' ? 0.0 : double.parse(currentValue))
                      .clamp(min, max)
                      .toDouble()
                  : double.parse(currentValue).clamp(min, max).toDouble(),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),

          // Quick add buttons
          Row(
            children: quickValues.map((value) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: OutlinedButton(
                    onPressed: () {
                      final newValue = isDecimal
                          ? (double.parse(currentValue) + value.toDouble())
                          : (double.parse(currentValue) + value.toDouble());
                      onChanged(newValue.clamp(min, max));
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: color,
                      side: BorderSide(color: color.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      '+${isDecimal ? value.toStringAsFixed(value is double && value < 1 ? 2 : 1) : value}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
