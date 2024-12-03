import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _dietKey = 'selected_diet';
  static const String _allergiesKey = 'selected_allergies';
  static const String _dislikesKey = 'selected_dislikes';
  static const String _reminderEnabledKey = 'reminder_enabled';
  static const String _reminderTimeKey = 'reminder_time';
  static const String _reminderDayKey = 'reminder_day';
  static const String _dietaryPreferencesKey = 'dietary_preferences';

  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  Future<void> saveDiet(String diet) async {
    await _prefs.setString(_dietKey, diet);
  }

  String? getDiet() {
    return _prefs.getString(_dietKey);
  }

  Future<void> saveAllergies(List<String> allergies) async {
    await _prefs.setStringList(_allergiesKey, allergies);
  }

  List<String> getAllergies() {
    return _prefs.getStringList(_allergiesKey) ?? [];
  }

  Future<void> saveDislikes(List<String> dislikes) async {
    await _prefs.setStringList(_dislikesKey, dislikes);
  }

  List<String> getDislikes() {
    return _prefs.getStringList(_dislikesKey) ?? [];
  }

  Future<void> saveDietaryPreferences(List<String> preferences) async {
    await _prefs.setStringList(_dietaryPreferencesKey, preferences);
  }

  List<String> getDietaryPreferences() {
    return _prefs.getStringList(_dietaryPreferencesKey) ?? [];
  }

  Future<void> saveReminderSettings({
    required bool enabled,
    String? time,
    String? day,
  }) async {
    await _prefs.setBool(_reminderEnabledKey, enabled);
    if (time != null) await _prefs.setString(_reminderTimeKey, time);
    if (day != null) await _prefs.setString(_reminderDayKey, day);
  }

  bool getReminderEnabled() {
    return _prefs.getBool(_reminderEnabledKey) ?? false;
  }

  String? getReminderTime() {
    return _prefs.getString(_reminderTimeKey);
  }

  String? getReminderDay() {
    return _prefs.getString(_reminderDayKey);
  }

  Future<void> clearAllPreferences() async {
    await _prefs.clear();
  }
} 