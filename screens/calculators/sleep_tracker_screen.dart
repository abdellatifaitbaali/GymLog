import 'package:flutter/material.dart';
import '../../config/theme.dart';

class SleepTrackerScreen extends StatefulWidget {
  const SleepTrackerScreen({super.key});

  @override
  State<SleepTrackerScreen> createState() => _SleepTrackerScreenState();
}

class _SleepTrackerScreenState extends State<SleepTrackerScreen> {
  double _targetHours = 8.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Tracker'),
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
            // Main sleep card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.sleepPurple.withValues(alpha: 0.2),
                    AppTheme.sleepPurple.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.sleepPurple.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  const Text('🌙', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  const Text(
                    'Recommended Sleep',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_targetHours.toStringAsFixed(0)} hours',
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.sleepPurple,
                    ),
                  ),
                  const Text(
                    'for optimal recovery',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Adjust target
            const Text(
              'Your Target',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Hours per night',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                      Text(
                        '${_targetHours.toStringAsFixed(1)} hrs',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.sleepPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppTheme.sleepPurple,
                      inactiveTrackColor: AppTheme.surfaceDark,
                      thumbColor: AppTheme.sleepPurple,
                      overlayColor: AppTheme.sleepPurple.withValues(alpha: 0.2),
                      trackHeight: 6,
                    ),
                    child: Slider(
                      value: _targetHours,
                      min: 5,
                      max: 10,
                      divisions: 10,
                      onChanged: (value) {
                        setState(() => _targetHours = value);
                      },
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('5h',
                          style: TextStyle(
                              color: AppTheme.textMuted, fontSize: 12)),
                      Text('7-9h optimal',
                          style: TextStyle(
                              color: AppTheme.primaryGreen, fontSize: 12)),
                      Text('10h',
                          style: TextStyle(
                              color: AppTheme.textMuted, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sleep stages info
            const Text(
              'Why Sleep Matters for Fitness',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              '💪',
              'Muscle Recovery',
              'Growth hormone is released during deep sleep, repairing and building muscle tissue.',
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              '⚡',
              'Energy Restoration',
              'Sleep restores glycogen levels, essential for next-day workout performance.',
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              '🧠',
              'Mental Focus',
              'Quality sleep improves coordination, reaction time, and motivation.',
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              '🔥',
              'Fat Burning',
              'Poor sleep increases cortisol and hunger hormones, making weight management harder.',
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
                          color: AppTheme.sleepPurple, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Better Sleep Tips',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTip('Keep a consistent sleep schedule'),
                  _buildTip('Avoid screens 1 hour before bed'),
                  _buildTip('Keep your room cool (65-68°F / 18-20°C)'),
                  _buildTip('Limit caffeine after 2 PM'),
                  _buildTip('Exercise regularly (but not too late)'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String emoji, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceDark),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
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
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
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
              color: AppTheme.sleepPurple, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
