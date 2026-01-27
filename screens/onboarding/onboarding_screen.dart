import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/user_profile.dart';
import '../../services/storage_service.dart';
import '../dashboard/dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form data
  String _name = '';
  int _age = 25;
  double _weight = 70;
  double _height = 170;
  Gender _gender = Gender.male;
  ActivityLevel _activityLevel = ActivityLevel.moderate;
  FitnessGoal _goal = FitnessGoal.maintain;
  UnitSystem _unitSystem = UnitSystem.metric;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final profile = UserProfile(
      name: _name.isEmpty ? null : _name,
      age: _age,
      weight: _weight,
      height: _height,
      gender: _gender,
      activityLevel: _activityLevel,
      goal: _goal,
      unitSystem: _unitSystem,
    );

    await StorageService.saveProfile(profile);
    await StorageService.setOnboardingComplete(true);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: index <= _currentPage
                            ? AppTheme.primaryGreen
                            : AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                },
                children: [
                  _buildPersonalInfoPage(),
                  _buildGoalsPage(),
                  _buildActivityPage(),
                ],
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousPage,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: AppTheme.primaryGreen),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 16),
                  Expanded(
                    flex: _currentPage > 0 ? 2 : 1,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      child:
                          Text(_currentPage == 2 ? 'Get Started' : 'Continue'),
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

  Widget _buildPersonalInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Let\'s get to\nknow you',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'We\'ll use this to calculate your daily targets',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // Name (optional)
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name (optional)',
                hintText: 'Enter your name',
              ),
              onChanged: (value) => _name = value,
            ),
            const SizedBox(height: 20),

            // Unit System Toggle
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _unitSystem = UnitSystem.metric),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _unitSystem == UnitSystem.metric
                              ? AppTheme.primaryGreen
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Metric (kg, cm)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _unitSystem == UnitSystem.metric
                                ? Colors.white
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _unitSystem = UnitSystem.imperial),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _unitSystem == UnitSystem.imperial
                              ? AppTheme.primaryGreen
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Imperial (lbs, in)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _unitSystem == UnitSystem.imperial
                                ? Colors.white
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Gender
            const Text(
              'Gender',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildOptionCard(
                    'Male',
                    Icons.male_rounded,
                    _gender == Gender.male,
                    () => setState(() => _gender = Gender.male),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildOptionCard(
                    'Female',
                    Icons.female_rounded,
                    _gender == Gender.female,
                    () => setState(() => _gender = Gender.female),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Age slider
            _buildSliderSection(
              'Age',
              '$_age years',
              _age.toDouble(),
              15,
              80,
              (value) => setState(() => _age = value.round()),
            ),
            const SizedBox(height: 24),

            // Weight slider
            _buildSliderSection(
              'Weight',
              _unitSystem == UnitSystem.metric
                  ? '${_weight.toStringAsFixed(1)} kg'
                  : '${_weight.toStringAsFixed(1)} lbs',
              _weight,
              _unitSystem == UnitSystem.metric ? 40 : 88,
              _unitSystem == UnitSystem.metric ? 150 : 330,
              (value) => setState(() => _weight = value),
            ),
            const SizedBox(height: 24),

            // Height slider
            _buildSliderSection(
              'Height',
              _unitSystem == UnitSystem.metric
                  ? '${_height.toStringAsFixed(0)} cm'
                  : '${_height.toStringAsFixed(0)} in',
              _height,
              _unitSystem == UnitSystem.metric ? 140 : 55,
              _unitSystem == UnitSystem.metric ? 220 : 87,
              (value) => setState(() => _height = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What\'s your\ngoal?',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This helps us calculate your daily calorie target',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          _buildGoalCard(
            'Lose Weight',
            'Burn fat while preserving muscle mass',
            Icons.trending_down_rounded,
            AppTheme.calorieOrange,
            FitnessGoal.lose,
          ),
          const SizedBox(height: 16),
          _buildGoalCard(
            'Maintain',
            'Keep your current weight and physique',
            Icons.balance_rounded,
            AppTheme.primaryGreen,
            FitnessGoal.maintain,
          ),
          const SizedBox(height: 16),
          _buildGoalCard(
            'Build Muscle',
            'Gain lean muscle mass with minimal fat',
            Icons.trending_up_rounded,
            AppTheme.proteinBlue,
            FitnessGoal.gain,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How active\nare you?',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Be honest for accurate calculations',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          _buildActivityCard(
            'Sedentary',
            'Little or no exercise',
            '🪑',
            ActivityLevel.sedentary,
          ),
          const SizedBox(height: 12),
          _buildActivityCard(
            'Lightly Active',
            'Light exercise 1-3 days/week',
            '🚶',
            ActivityLevel.light,
          ),
          const SizedBox(height: 12),
          _buildActivityCard(
            'Moderately Active',
            'Moderate exercise 3-5 days/week',
            '🏃',
            ActivityLevel.moderate,
          ),
          const SizedBox(height: 12),
          _buildActivityCard(
            'Very Active',
            'Hard exercise 6-7 days/week',
            '🏋️',
            ActivityLevel.active,
          ),
          const SizedBox(height: 12),
          _buildActivityCard(
            'Extra Active',
            'Very hard exercise, physical job',
            '⚡',
            ActivityLevel.veryActive,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(
      String label, IconData icon, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryGreen.withValues(alpha: 0.15)
              : AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppTheme.primaryGreen : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: selected ? AppTheme.primaryGreen : AppTheme.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color:
                    selected ? AppTheme.primaryGreen : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSection(
    String label,
    String value,
    double currentValue,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppTheme.primaryGreen,
            inactiveTrackColor: AppTheme.surfaceDark,
            thumbColor: AppTheme.primaryGreen,
            overlayColor: AppTheme.primaryGreen.withValues(alpha: 0.2),
            trackHeight: 6,
          ),
          child: Slider(
            value: currentValue,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCard(String title, String subtitle, IconData icon,
      Color color, FitnessGoal goalType) {
    final selected = _goal == goalType;
    return GestureDetector(
      onTap: () => setState(() => _goal = goalType),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.15) : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? color : AppTheme.surfaceDark,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: selected ? color : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_circle_rounded, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(
      String title, String subtitle, String emoji, ActivityLevel level) {
    final selected = _activityLevel == level;
    return GestureDetector(
      onTap: () => setState(() => _activityLevel = level),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryGreen.withValues(alpha: 0.15)
              : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppTheme.primaryGreen : AppTheme.surfaceDark,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: selected
                          ? AppTheme.primaryGreen
                          : AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded,
                  color: AppTheme.primaryGreen),
          ],
        ),
      ),
    );
  }
}
