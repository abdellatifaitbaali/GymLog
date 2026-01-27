import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../models/user_profile.dart';
import '../../services/storage_service.dart';
import '../onboarding/onboarding_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserProfile? _profile;
  bool _isDarkTheme = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _profile = StorageService.getProfile();
      _isDarkTheme = StorageService.isDarkTheme();
    });
  }

  String _getGoalText(FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.lose:
        return 'Lose Weight';
      case FitnessGoal.maintain:
        return 'Maintain';
      case FitnessGoal.gain:
        return 'Build Muscle';
    }
  }

  String _getActivityText(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'Sedentary';
      case ActivityLevel.light:
        return 'Lightly Active';
      case ActivityLevel.moderate:
        return 'Moderately Active';
      case ActivityLevel.active:
        return 'Very Active';
      case ActivityLevel.veryActive:
        return 'Extra Active';
    }
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
            // Profile section
            _buildSectionTitle('Profile'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildProfileRow('Name', _profile!.name ?? 'Not set'),
                  const Divider(color: AppTheme.surfaceDark, height: 24),
                  _buildProfileRow('Age', '${_profile!.age} years'),
                  const Divider(color: AppTheme.surfaceDark, height: 24),
                  _buildProfileRow(
                    'Weight',
                    _profile!.unitSystem == UnitSystem.metric
                        ? '${_profile!.weight.toStringAsFixed(1)} kg'
                        : '${_profile!.weight.toStringAsFixed(1)} lbs',
                  ),
                  const Divider(color: AppTheme.surfaceDark, height: 24),
                  _buildProfileRow(
                    'Height',
                    _profile!.unitSystem == UnitSystem.metric
                        ? '${_profile!.height.toStringAsFixed(0)} cm'
                        : '${_profile!.height.toStringAsFixed(0)} in',
                  ),
                  const Divider(color: AppTheme.surfaceDark, height: 24),
                  _buildProfileRow('Gender',
                      _profile!.gender == Gender.male ? 'Male' : 'Female'),
                  const Divider(color: AppTheme.surfaceDark, height: 24),
                  _buildProfileRow(
                      'Activity', _getActivityText(_profile!.activityLevel)),
                  const Divider(color: AppTheme.surfaceDark, height: 24),
                  _buildProfileRow('Goal', _getGoalText(_profile!.goal)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  await StorageService.setOnboardingComplete(false);
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const OnboardingScreen()),
                      (route) => false,
                    );
                  }
                },
                child: const Text('Edit Profile'),
              ),
            ),
            const SizedBox(height: 24),

            // Preferences
            _buildSectionTitle('Preferences'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.dark_mode_rounded,
                    color: AppTheme.textSecondary),
                title: const Text('Dark Theme',
                    style: TextStyle(color: AppTheme.textPrimary)),
                trailing: Switch(
                  value: _isDarkTheme,
                  activeColor: AppTheme.primaryGreen,
                  onChanged: (value) async {
                    await StorageService.setDarkTheme(value);
                    setState(() => _isDarkTheme = value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Legal
            _buildSectionTitle('Legal'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined,
                        color: AppTheme.textSecondary),
                    title: const Text('Privacy Policy',
                        style: TextStyle(color: AppTheme.textPrimary)),
                    trailing: const Icon(Icons.open_in_new_rounded,
                        size: 18, color: AppTheme.textMuted),
                    onTap: () => _launchUrl(
                        'https://nexodev.site/gym-calc/privacy-policy'),
                  ),
                  const Divider(color: AppTheme.surfaceDark, height: 1),
                  ListTile(
                    leading: const Icon(Icons.description_outlined,
                        color: AppTheme.textSecondary),
                    title: const Text('Terms of Service',
                        style: TextStyle(color: AppTheme.textPrimary)),
                    trailing: const Icon(Icons.open_in_new_rounded,
                        size: 18, color: AppTheme.textMuted),
                    onTap: () =>
                        _launchUrl('https://nexodev.site/gym-calc/terms'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // About
            _buildSectionTitle('About'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.fitness_center_rounded,
                          color: AppTheme.primaryGreen),
                      SizedBox(width: 12),
                      Text(
                        'GymLog',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Health Calculator',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Made by NEXO Dev',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Danger zone
            _buildSectionTitle('Data'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: ListTile(
                leading:
                    const Icon(Icons.delete_outline_rounded, color: Colors.red),
                title: const Text('Clear All Data',
                    style: TextStyle(color: Colors.red)),
                subtitle: const Text(
                  'This will delete all your data permanently',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                ),
                onTap: () => _showClearDataDialog(),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppTheme.textSecondary,
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Future<void> _showClearDataDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text('Clear All Data?',
            style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text(
          'This will permanently delete all your profile data and logs. This action cannot be undone.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await StorageService.clearAllData();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const OnboardingScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
