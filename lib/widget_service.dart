import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

/// Service de gestion des widgets d'écran d'accueil (solution simple)
class WidgetService {
  static Timer? _updateTimer;
  static const platform = MethodChannel('com.reunited.countdown/widget');

  /// Initialize widget service
  static Future<void> initialize() async {
    if (kIsWeb) {
      developer.log('Widget service not available on web');
      return;
    }

    try {
      developer.log('WidgetService: Initialized successfully');
    } catch (e) {
      developer.log('WidgetService: Failed to initialize: $e');
    }
  }

  /// Check if widgets are supported on this platform
  static Future<bool> isWidgetSupported() async {
    if (kIsWeb) return false;
    
    try {
      // Sur Android/iOS, considérer que les widgets sont supportés
      return !kIsWeb;
    } catch (e) {
      developer.log('WidgetService: Widget not supported: $e');
      return false;
    }
  }

  /// Configure widget with reunion date and timezone
  static Future<void> configureWidget({
    required DateTime reunionDate,
    required String timezone,
  }) async {
    if (kIsWeb) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Sauvegarder les données dans SharedPreferences
      await prefs.setString('widget_reunionDate', reunionDate.toIso8601String());
      await prefs.setString('widget_timezone', timezone);
      await prefs.setString('widget_lastUpdate', DateTime.now().toIso8601String());
      
      // Mettre à jour le widget
      await updateWidget();
      
      developer.log('WidgetService: Widget configured successfully');
    } catch (e) {
      developer.log('WidgetService: Failed to configure widget: $e');
      rethrow;
    }
  }

  /// Update widget with current countdown data
  static Future<void> updateWidget() async {
    if (kIsWeb) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Vérifier d'abord s'il y a des valeurs directes de l'app (plus précises)
      final directDays = prefs.getInt('widget_days');
      final directHours = prefs.getInt('widget_hours');
      final directMinutes = prefs.getInt('widget_minutes');
      final directSeconds = prefs.getInt('widget_seconds');
      
      if (directDays != null && directHours != null && directMinutes != null && directSeconds != null) {
        // Utiliser les valeurs directes de l'app (SYNCHRONISATION PARFAITE)
        developer.log('WidgetService: Using direct app values - Days: $directDays, Hours: $directHours');
        
        // Transmettre au widget Android
        try {
          await platform.invokeMethod('updateWidget', {
            'days': directDays,
            'hours': directHours,
            'minutes': directMinutes,
            'seconds': directSeconds,
            'isTimeUp': prefs.getBool('widget_isTimeUp') ?? false,
            'reunionDate': prefs.getString('widget_reunionDateFormatted') ?? '',
            'timezone': prefs.getString('widget_timezone') ?? '',
          });
          developer.log('WidgetService: Direct sync completed');
        } catch (e) {
          developer.log('WidgetService: Platform channel error: $e');
        }
        return;
      }
      
      // Sinon, utiliser l'ancien système de calcul (fallback)
      final reunionDateStr = prefs.getString('widget_reunionDate');
      final timezone = prefs.getString('widget_timezone') ?? 'Indonesia';
      
      if (reunionDateStr != null) {
        final reunionDate = DateTime.parse(reunionDateStr);
        
        // Utiliser EXACTEMENT la même logique que l'application
        final now = DateTime.now();
        
        // Obtenir le décalage UTC de la machine locale automatiquement
        final localOffset = _getLocalTimezoneOffset();
        
        // Date de retrouvailles saisie dans le fuseau de destination
        final destinationOffset = getTimezoneOffset(timezone);
        final offsetDifference = localOffset - destinationOffset;
        
        // Convertir l'heure de retrouvailles vers mon fuseau horaire local
        final reunionInMyTimezone = reunionDate.add(Duration(hours: offsetDifference));
        
        // Calculer le temps restant depuis ma perspective locale
        final timeRemaining = reunionInMyTimezone.difference(now);
        
        // Sauvegarder les données pour le widget
        if (timeRemaining.isNegative) {
          await prefs.setString('widget_timeRemaining', 'C\'est l\'heure !');
          await prefs.setBool('widget_isTimeUp', true);
          await prefs.setInt('widget_days', 0);
          await prefs.setInt('widget_hours', 0);
          await prefs.setInt('widget_minutes', 0);
          await prefs.setInt('widget_seconds', 0);
        } else {
          final days = timeRemaining.inDays;
          final hours = timeRemaining.inHours % 24;
          final minutes = timeRemaining.inMinutes % 60;
          final seconds = timeRemaining.inSeconds % 60;
          
          final timeStr = '${days}j ${hours}h ${minutes}m ${seconds}s';
          await prefs.setString('widget_timeRemaining', timeStr);
          await prefs.setBool('widget_isTimeUp', false);
          
          // Sauvegarder aussi les valeurs séparément pour un meilleur design
          await prefs.setInt('widget_days', days);
          await prefs.setInt('widget_hours', hours);
          await prefs.setInt('widget_minutes', minutes);
          await prefs.setInt('widget_seconds', seconds);
        }
        
        await prefs.setString('widget_reunionDateFormatted', _formatDate(reunionDate));
        await prefs.setString('widget_timezone', _getTimezoneName(timezone));
        
        // Notifier le widget Android via MethodChannel
        try {
          await platform.invokeMethod('updateWidget', {
            'timeRemaining': prefs.getString('widget_timeRemaining'),
            'reunionDate': prefs.getString('widget_reunionDateFormatted'),
            'timezone': prefs.getString('widget_timezone'),
            'isTimeUp': prefs.getBool('widget_isTimeUp'),
            'days': prefs.getInt('widget_days'),
            'hours': prefs.getInt('widget_hours'),
            'minutes': prefs.getInt('widget_minutes'),
            'seconds': prefs.getInt('widget_seconds'),
          });
          developer.log('WidgetService: Widget updated via MethodChannel - Days: ${prefs.getInt('widget_days')}, Hours: ${prefs.getInt('widget_hours')}');
        } catch (e) {
          developer.log('WidgetService: Platform channel error: $e');
        }
      }
    } catch (e) {
      developer.log('WidgetService: Failed to update widget: $e');
    }
  }

  /// Start automatic widget updates
  static void startAutoUpdate() {
    if (kIsWeb) return;

    stopAutoUpdate();
    
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateWidget();
    });
    
    developer.log('WidgetService: Auto-update started');
  }

  /// Stop automatic widget updates
  static void stopAutoUpdate() {
    _updateTimer?.cancel();
    _updateTimer = null;
    developer.log('WidgetService: Auto-update stopped');
  }

  /// Get timezone offset for calculations
  static int getTimezoneOffset(String timezone) {
    switch (timezone) {
      case 'France':
        return _getFranceOffset();
      case 'Indonesia':
        return 7;
      default:
        return 0;
    }
  }

  /// Calculate France timezone offset (summer/winter time)
  static int _getFranceOffset() {
    final now = DateTime.now();
    final marchLastSunday = _getLastSundayOfMonth(now.year, 3);
    final octoberLastSunday = _getLastSundayOfMonth(now.year, 10);
    
    if (now.isAfter(marchLastSunday) && now.isBefore(octoberLastSunday)) {
      return 2; // UTC+2 (summer time)
    } else {
      return 1; // UTC+1 (winter time)
    }
  }

  /// Find last Sunday of a month
  static DateTime _getLastSundayOfMonth(int year, int month) {
    final lastDay = DateTime(year, month + 1, 0);
    final daysToSubtract = lastDay.weekday % 7;
    return DateTime(lastDay.year, lastDay.month, lastDay.day - daysToSubtract);
  }

  /// Get local timezone offset in hours
  static int _getLocalTimezoneOffset() {
    final now = DateTime.now();
    final offsetInMinutes = now.timeZoneOffset.inMinutes;
    return (offsetInMinutes / 60).round();
  }

  /// Format date for display
  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Get timezone display name
  static String _getTimezoneName(String timezone) {
    switch (timezone) {
      case 'France':
        return 'France 🇫🇷';
      case 'Indonesia':
        return 'Indonésie 🇮🇩';
      default:
        return timezone;
    }
  }
}
