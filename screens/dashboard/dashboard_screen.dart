import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/user_profile.dart';
import '../../models/daily_log.dart';
import '../../services/storage_service.dart';
import '../../services/calculation_service.dart';
import '../../widgets/progress_ring.dart';
import '../../widgets/metric_card.dart';
import '../settings/settings_screen.dart';
import '../calculators/calorie_calculator_screen.dart';
import '../calculators/protein_calculator_screen.dart';
import '../calculators/water_calculator_screen.dart';
import '../calculators/sleep_tracker_screen.dart';
import '../log/log_entry_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  UserProfile? _profile;
  DailyLog? _todayLog;
  CalculationResult? _calculation;
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final profile = StorageService.getProfile();
    if (profile != null) {
      final calculation = CalculationService.getFullCalculation(profile);
      final todayLog = StorageService.getTodayLog().copyWith(
        caloriesTarget: calculation.targetCalories,
        proteinTarget: calculation.proteinGrams,
        waterTarget: calculation.waterLiters,
        sleepTarget: calculation.sleepHours,
      );

      setState(() {
        _profile = profile;
        _calculation = calculation;
        _todayLog = todayLog;
        _streak = StorageService.getCurrentStreak();
      });
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null || _calculation == null || _todayLog == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: AppTheme.primaryGreen,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 24),

                // Main progress card
                _buildMainProgressCard(),
                const SizedBox(height: 24),

                // Quick log buttons
                _buildQuickLogSection(),
                const SizedBox(height: 24),

                // Detailed metrics
                _buildDetailedMetrics(),
                const SizedBox(height: 24),

                // Calculators section
                _buildCalculatorsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _profile!.name ?? 'Athlete',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Streak badge
              if (_streak > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.calorieOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 4),
                      Text(
                        '$_streak',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.calorieOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 12),
              // Settings button
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                  _loadData();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.settings_outlined,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainProgressCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGreen.withValues(alpha: 0.2),
            AppTheme.darkGreen.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.primaryGreen.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniProgress(
                'Calories',
                _todayLog!.caloriesConsumed,
                _todayLog!.caloriesTarget,
                'kcal',
                AppTheme.calorieOrange,
              ),
              _buildMiniProgress(
                'Protein',
                _todayLog!.proteinConsumed.round(),
                _todayLog!.proteinTarget.round(),
                'g',
                AppTheme.proteinBlue,
              ),
              _buildMiniProgress(
                'Water',
                (_todayLog!.waterConsumed * 10).round(),
                (_todayLog!.waterTarget * 10).round(),
                'L',
                AppTheme.waterCyan,
                divisor: 10,
              ),
              _buildMiniProgress(
                'Sleep',
                (_todayLog!.sleepHours * 10).round(),
                (_todayLog!.sleepTarget * 10).round(),
                'hrs',
                AppTheme.sleepPurple,
                divisor: 10,
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Log today button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LogEntryScreen(
                      todayLog: _todayLog!,
                      calculation: _calculation!,
                    ),
                  ),
                );
                _loadData();
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Log Today\'s Progress'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniProgress(
    String label,
    int current,
    int target,
    String unit,
    Color color, {
    int divisor = 1,
  }) {
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    final displayCurrent = divisor > 1
        ? (current / divisor).toStringAsFixed(1)
        : current.toString();
    final displayTarget =
        divisor > 1 ? (target / divisor).toStringAsFixed(1) : target.toString();

    return Column(
      children: [
        ProgressRing(
          progress: progress,
          size: 60,
          strokeWidth: 5,
          color: color,
          child: Text(
            '${(progress * 100).round()}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          '$displayCurrent/$displayTarget',
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLogSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Log',
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
                child: _buildQuickLogButton(
                  '+100 kcal',
                  Icons.local_fire_department_rounded,
                  AppTheme.calorieOrange,
                  () => _quickLog(calories: 100),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickLogButton(
                  '+25g protein',
                  Icons.fitness_center_rounded,
                  AppTheme.proteinBlue,
                  () => _quickLog(protein: 25),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickLogButton(
                  '+1 glass',
                  Icons.water_drop_rounded,
                  AppTheme.waterCyan,
                  () => _quickLog(water: 0.25),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLogButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _quickLog(
      {int? calories, double? protein, double? water}) async {
    final newLog = _todayLog!.copyWith(
      caloriesConsumed:
          calories != null ? _todayLog!.caloriesConsumed + calories : null,
      proteinConsumed:
          protein != null ? _todayLog!.proteinConsumed + protein : null,
      waterConsumed: water != null ? _todayLog!.waterConsumed + water : null,
    );
    await StorageService.saveDailyLog(newLog);
    _loadData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Logged!'),
          backgroundColor: AppTheme.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Widget _buildDetailedMetrics() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s Targets',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          MetricCard(
            title: 'Daily Calories',
            value: '${_calculation!.targetCalories} kcal',
            subtitle:
                'BMR: ${_calculation!.bmr.round()} | TDEE: ${_calculation!.tdee.round()}',
            icon: Icons.local_fire_department_rounded,
            iconColor: AppTheme.calorieOrange,
          ),
          const SizedBox(height: 12),
          MetricCard(
            title: 'Protein Target',
            value: '${_calculation!.proteinGrams.round()}g',
            subtitle:
                'Carbs: ${_calculation!.carbsGrams.round()}g | Fats: ${_calculation!.fatsGrams.round()}g',
            icon: Icons.fitness_center_rounded,
            iconColor: AppTheme.proteinBlue,
          ),
          const SizedBox(height: 12),
          MetricCard(
            title: 'Water Intake',
            value: '${_calculation!.waterLiters.toStringAsFixed(1)}L',
            subtitle:
                '~${(_calculation!.waterLiters * 4).round()} glasses per day',
            icon: Icons.water_drop_rounded,
            iconColor: AppTheme.waterCyan,
          ),
          const SizedBox(height: 12),
          MetricCard(
            title: 'Sleep Goal',
            value: '${_calculation!.sleepHours.round()} hours',
            subtitle: 'Recommended: 7-9 hours for recovery',
            icon: Icons.bedtime_rounded,
            iconColor: AppTheme.sleepPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calculators',
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
                child: _buildCalculatorCard(
                  'Calories',
                  Icons.local_fire_department_rounded,
                  AppTheme.calorieOrange,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CalorieCalculatorScreen(profile: _profile!),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCalculatorCard(
                  'Protein',
                  Icons.fitness_center_rounded,
                  AppTheme.proteinBlue,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProteinCalculatorScreen(profile: _profile!),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildCalculatorCard(
                  'Water',
                  Icons.water_drop_rounded,
                  AppTheme.waterCyan,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WaterCalculatorScreen(profile: _profile!),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCalculatorCard(
                  'Sleep',
                  Icons.bedtime_rounded,
                  AppTheme.sleepPurple,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SleepTrackerScreen(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.surfaceDark,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
