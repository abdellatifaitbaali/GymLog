import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/user_profile.dart';
import '../../services/calculation_service.dart';

class WaterCalculatorScreen extends StatelessWidget {
  final UserProfile profile;

  const WaterCalculatorScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final waterLiters = CalculationService.calculateWaterIntake(profile);
    final glasses = (waterLiters * 4).round(); // 250ml per glass
    final ounces = (waterLiters * 33.814).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Intake'),
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
            // Main water card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.waterCyan.withValues(alpha: 0.2),
                    AppTheme.waterCyan.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.waterCyan.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  const Text('💧', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  const Text(
                    'Daily Water Goal',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${waterLiters.toStringAsFixed(1)}L',
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.waterCyan,
                    ),
                  ),
                  Text(
                    '$glasses glasses • $ounces oz',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick reference
            const Text(
              'Quick Reference',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child:
                      _buildRefCard('🥤', '$glasses', 'Glasses\n(250ml each)'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildRefCard('🍶', '${(waterLiters * 2).round()}',
                      'Bottles\n(500ml each)'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildRefCard('🧴', '$ounces', 'Ounces\n(fl oz)'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tips
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
                      Icon(Icons.tips_and_updates_rounded,
                          color: AppTheme.waterCyan, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Hydration Tips',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTip('Start your day with a glass of water'),
                  _buildTip('Drink before you feel thirsty'),
                  _buildTip('Carry a reusable water bottle'),
                  _buildTip('Set hourly reminders'),
                  _buildTip('Increase intake during exercise'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Signs of dehydration
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.calorieOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.calorieOrange.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: AppTheme.calorieOrange, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Signs of Dehydration',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.calorieOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '• Dark yellow urine\n'
                    '• Feeling tired or dizzy\n'
                    '• Dry mouth or lips\n'
                    '• Headaches\n'
                    '• Decreased exercise performance',
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

  Widget _buildRefCard(String emoji, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceDark),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.waterCyan,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppTheme.waterCyan, size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
