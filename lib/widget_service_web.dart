import 'package:flutter/foundation.dart';
import 'dart:async';

/// Stub implementation of WidgetService for web platform
/// This provides the same interface but with no-op implementations
class WidgetService {
  static Timer? _updateTimer;
  
  /// Initialize widget service (no-op on web)
  static Future<void> initialize() async {
    if (kDebugMode) {
      print('WidgetService: Web stub - initialize called');
    }
  }

  /// Check if widgets are supported (always false on web)
  static Future<bool> isWidgetSupported() async {
    return false;
  }

  /// Configure widget (no-op on web)
  static Future<void> configureWidget({
    required DateTime reunionDate,
    required String timezone,
  }) async {
    if (kDebugMode) {
      print('WidgetService: Web stub - configureWidget called');
    }
  }

  /// Update widget (no-op on web)
  static Future<void> updateWidget() async {
    if (kDebugMode) {
      print('WidgetService: Web stub - updateWidget called');
    }
  }

  /// Start auto-update (no-op on web)
  static void startAutoUpdate() {
    if (kDebugMode) {
      print('WidgetService: Web stub - startAutoUpdate called');
    }
  }

  /// Stop auto-update (no-op on web)
  static void stopAutoUpdate() {
    _updateTimer?.cancel();
    _updateTimer = null;
    if (kDebugMode) {
      print('WidgetService: Web stub - stopAutoUpdate called');
    }
  }

  /// Dispose resources (no-op on web)
  static void dispose() {
    stopAutoUpdate();
    if (kDebugMode) {
      print('WidgetService: Web stub - dispose called');
    }
  }
}
