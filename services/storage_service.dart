import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/daily_log.dart';

class StorageService {
  static const String _profileKey = 'user_profile';
  static const String _logsKey = 'daily_logs';
  static const String _onboardingKey = 'onboarding_complete';
  static const String _themeKey = 'dark_theme';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Onboarding status
  static bool isOnboardingComplete() {
    return _prefs?.getBool(_onboardingKey) ?? false;
  }

  static Future<void> setOnboardingComplete(bool complete) async {
    await _prefs?.setBool(_onboardingKey, complete);
  }

  // Theme preference
  static bool isDarkTheme() {
    return _prefs?.getBool(_themeKey) ?? true; // Default to dark
  }

  static Future<void> setDarkTheme(bool isDark) async {
    await _prefs?.setBool(_themeKey, isDark);
  }

  // User Profile
  static Future<void> saveProfile(UserProfile profile) async {
    final json = jsonEncode(profile.toJson());
    await _prefs?.setString(_profileKey, json);
  }

  static UserProfile? getProfile() {
    final json = _prefs?.getString(_profileKey);
    if (json == null) return null;
    try {
      return UserProfile.fromJson(jsonDecode(json));
    } catch (e) {
      return null;
    }
  }

  static Future<void> deleteProfile() async {
    await _prefs?.remove(_profileKey);
  }

  // Daily Logs
  static Future<void> saveDailyLog(DailyLog log) async {
    final logs = getAllDailyLogs();
    logs[log.dateKey] = log;

    final logsJson = logs.map((key, value) => MapEntry(key, value.toJson()));
    await _prefs?.setString(_logsKey, jsonEncode(logsJson));
  }

  static Map<String, DailyLog> getAllDailyLogs() {
    final json = _prefs?.getString(_logsKey);
    if (json == null) return {};

    try {
      final Map<String, dynamic> decoded = jsonDecode(json);
      return decoded.map((key, value) =>
          MapEntry(key, DailyLog.fromJson(value as Map<String, dynamic>)));
    } catch (e) {
      return {};
    }
  }

  static DailyLog? getDailyLog(DateTime date) {
    final logs = getAllDailyLogs();
    final key =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return logs[key];
  }

  static DailyLog getTodayLog() {
    final today = DateTime.now();
    return getDailyLog(today) ?? DailyLog(date: today);
  }

  static Future<void> deleteDailyLog(DateTime date) async {
    final logs = getAllDailyLogs();
    final key =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    logs.remove(key);

    final logsJson = logs.map((key, value) => MapEntry(key, value.toJson()));
    await _prefs?.setString(_logsKey, jsonEncode(logsJson));
  }

  // Get logs for date range
  static List<DailyLog> getLogsForRange(DateTime start, DateTime end) {
    final allLogs = getAllDailyLogs();
    return allLogs.values
        .where((log) =>
            log.date.isAfter(start.subtract(const Duration(days: 1))) &&
            log.date.isBefore(end.add(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // Get last 7 days of logs
  static List<DailyLog> getWeeklyLogs() {
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 7));
    return getLogsForRange(start, end);
  }

  // Calculate streak
  static int getCurrentStreak() {
    final logs = getAllDailyLogs();
    if (logs.isEmpty) return 0;

    int streak = 0;
    DateTime date = DateTime.now();

    while (true) {
      final key =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final log = logs[key];

      if (log != null && log.goalsMetCount >= 2) {
        streak++;
        date = date.subtract(const Duration(days: 1));
      } else if (streak == 0 && date.day == DateTime.now().day) {
        // Allow current day to not have log yet
        date = date.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  // Clear all data
  static Future<void> clearAllData() async {
    await _prefs?.clear();
  }
}
