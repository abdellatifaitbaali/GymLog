import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/user_profile.dart';
import '../../services/calculation_service.dart';

class ProteinCalculatorScreen extends StatefulWidget {
  final UserProfile profile;

  const ProteinCalculatorScreen({super.key, required this.profile});

  @override
  State<ProteinCalculatorScreen> createState() =>
      _ProteinCalculatorScreenState();
}

class _ProteinCalculatorScreenState extends State<ProteinCalculatorScreen> {
  late Map<String, double> _macros;

  @override
  void initState() {
    super.initState();
    _macros = CalculationService.calculateMacros(widget.profile);
  }

  @override
  Widget build(BuildContext context) {
    final proteinGrams = _macros['protein']!;
    final carbsGrams = _macros['carbs']!;
    final fatsGrams = _macros['fats']!;

    // Calculate percentages
    final totalCals = (proteinGrams * 4) + (carbsGrams * 4) + (fatsGrams * 9);
    final proteinPercent = (proteinGrams * 4 / totalCals * 100).round();
    final carbsPercent = (carbsGrams * 4 / totalCals * 100).round();
    final fatsPercent = (fatsGrams * 9 / totalCals * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Protein & Macros'),
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
            // Main protein card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.proteinBlue.withValues(alpha: 0.2),
                    AppTheme.proteinBlue.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.proteinBlue.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Daily Protein Target',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${proteinGrams.round()}g',
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.proteinBlue,
                    ),
                  ),
                  Text(
                    '~${(proteinGrams / widget.profile.weightInKg).toStringAsFixed(1)}g per kg body weight',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Macro breakdown
            const Text(
              'Full Macro Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Visual bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  Expanded(
                    flex: proteinPercent,
                    child: Container(
                      height: 24,
                      color: AppTheme.proteinBlue,
                    ),
                  ),
                  Expanded(
                    flex: carbsPercent,
                    child: Container(
                      height: 24,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  Expanded(
                    flex: fatsPercent,
                    child: Container(
                      height: 24,
                      color: AppTheme.calorieOrange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Macro cards
            _buildMacroCard(
              'Protein',
              '${proteinGrams.round()}g',
              '$proteinPercent%',
              '${(proteinGrams * 4).round()} kcal',
              AppTheme.proteinBlue,
              Icons.fitness_center_rounded,
            ),
            const SizedBox(height: 12),
            _buildMacroCard(
              'Carbohydrates',
              '${carbsGrams.round()}g',
              '$carbsPercent%',
              '${(carbsGrams * 4).round()} kcal',
              AppTheme.primaryGreen,
              Icons.grain_rounded,
            ),
            const SizedBox(height: 12),
            _buildMacroCard(
              'Fats',
              '${fatsGrams.round()}g',
              '$fatsPercent%',
              '${(fatsGrams * 9).round()} kcal',
              AppTheme.calorieOrange,
              Icons.opacity_rounded,
            ),
            const SizedBox(height: 24),

            // Protein sources tips
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('🥩', style: TextStyle(fontSize: 20)),
                      SizedBox(width: 8),
                      Text(
                        'High Protein Foods',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildFoodItem('Chicken Breast', '31g per 100g'),
                  _buildFoodItem('Greek Yogurt', '10g per 100g'),
                  _buildFoodItem('Eggs', '6g per egg'),
                  _buildFoodItem('Salmon', '25g per 100g'),
                  _buildFoodItem('Lentils', '9g per 100g cooked'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroCard(
    String title,
    String grams,
    String percent,
    String calories,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceDark),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  grams,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                percent,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                calories,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(String name, String protein) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
          Text(
            protein,
            style: const TextStyle(
              color: AppTheme.proteinBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
