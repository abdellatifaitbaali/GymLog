import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/user_profile.dart';
import '../../services/calculation_service.dart';

class CalorieCalculatorScreen extends StatefulWidget {
  final UserProfile profile;

  const CalorieCalculatorScreen({super.key, required this.profile});

  @override
  State<CalorieCalculatorScreen> createState() =>
      _CalorieCalculatorScreenState();
}

class _CalorieCalculatorScreenState extends State<CalorieCalculatorScreen> {
  late double _bmr;
  late double _tdee;
  late int _targetCalories;
  late FitnessGoal _selectedGoal;

  @override
  void initState() {
    super.initState();
    _selectedGoal = widget.profile.goal;
    _calculateValues();
  }

  void _calculateValues() {
    final tempProfile = widget.profile.copyWith(goal: _selectedGoal);
    _bmr = CalculationService.calculateBMR(widget.profile);
    _tdee = CalculationService.calculateTDEE(widget.profile);
    _targetCalories = CalculationService.calculateTargetCalories(tempProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Calculator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main result card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.calorieOrange.withValues(alpha: 0.2),
                    AppTheme.calorieOrange.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.calorieOrange.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Daily Calorie Target',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_targetCalories',
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.calorieOrange,
                    ),
                  ),
                  const Text(
                    'calories/day',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // BMR and TDEE breakdown
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    'BMR',
                    '${_bmr.round()} kcal',
                    'Basal Metabolic Rate\nCalories at rest',
                    Icons.bedtime_rounded,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoCard(
                    'TDEE',
                    '${_tdee.round()} kcal',
                    'Total Daily Energy\nWith activity',
                    Icons.directions_run_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Goal selector
            const Text(
              'Adjust for Goal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildGoalOption('Lose Weight', '-500 kcal/day', FitnessGoal.lose),
            const SizedBox(height: 8),
            _buildGoalOption(
                'Maintain Weight', '0 kcal/day', FitnessGoal.maintain),
            const SizedBox(height: 8),
            _buildGoalOption('Build Muscle', '+300 kcal/day', FitnessGoal.gain),
            const SizedBox(height: 24),

            // Explanation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: AppTheme.primaryGreen.withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'How it works',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '• BMR is calculated using the Mifflin-St Jeor equation\n'
                    '• TDEE = BMR × activity multiplier\n'
                    '• For weight loss: 500 kcal deficit ≈ 1 lb/week\n'
                    '• For muscle gain: 300 kcal surplus for lean gains',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      String title, String value, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppTheme.primaryGreen),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalOption(String title, String adjustment, FitnessGoal goal) {
    final isSelected = _selectedGoal == goal;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGoal = goal;
          _calculateValues();
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.calorieOrange.withValues(alpha: 0.15)
              : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.calorieOrange : AppTheme.surfaceDark,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color:
                    isSelected ? AppTheme.calorieOrange : AppTheme.textPrimary,
              ),
            ),
            Text(
              adjustment,
              style: TextStyle(
                color: isSelected
                    ? AppTheme.calorieOrange
                    : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
