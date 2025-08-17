/// Timezone configuration utilities
class TimezoneConfig {
  /// Available timezone keys
  static const List<String> availableTimezones = [
    'France',
    'Indonesia',
    'Local'
  ];

  /// Get timezone offset for a given timezone key
  static int getTimezoneOffset(String timezoneKey) {
    switch (timezoneKey) {
      case 'France':
        return _getFranceOffset();
      case 'Indonesia':
        return 7; // UTC+7
      case 'Local':
        return _getLocalTimezoneOffset();
      default:
        return 0;
    }
  }

  /// Get display name for timezone
  static String getTimezoneDisplayName(String timezoneKey,
      [String locale = 'en']) {
    switch (timezoneKey) {
      case 'France':
        switch (locale) {
          case 'fr':
            return 'France';
          case 'id':
            return 'Prancis';
          default:
            return 'France';
        }
      case 'Indonesia':
        switch (locale) {
          case 'fr':
            return 'Indonésie (Java)';
          case 'id':
            return 'Indonesia (Jawa)';
          default:
            return 'Indonesia (Java)';
        }
      case 'Local':
        switch (locale) {
          case 'fr':
            return 'Heure locale';
          case 'id':
            return 'Waktu lokal';
          default:
            return 'Local time';
        }
      default:
        return timezoneKey;
    }
  }

  /// Calculate France offset based on DST
  static int _getFranceOffset() {
    final now = DateTime.now();

    // DST: last Sunday of March to last Sunday of October
    final marchLastSunday = _getLastSundayOfMonth(now.year, 3);
    final octoberLastSunday = _getLastSundayOfMonth(now.year, 10);

    if (now.isAfter(marchLastSunday) && now.isBefore(octoberLastSunday)) {
      return 2; // UTC+2 (summer time)
    } else {
      return 1; // UTC+1 (winter time)
    }
  }

  /// Find the last Sunday of a given month
  static DateTime _getLastSundayOfMonth(int year, int month) {
    final lastDay = DateTime(year, month + 1, 0);
    final daysToSubtract = lastDay.weekday % 7;
    return DateTime(lastDay.year, lastDay.month, lastDay.day - daysToSubtract);
  }

  /// Get local machine timezone offset
  static int _getLocalTimezoneOffset() {
    final now = DateTime.now();
    final offsetInMinutes = now.timeZoneOffset.inMinutes;
    return (offsetInMinutes / 60).round();
  }
}
