import 'package:flutter/material.dart';

/// Configuration class for the countdown widget
class CountdownConfig {
  /// The target date for the countdown
  final DateTime targetDate;

  /// The timezone where the reunion will take place
  final String timezone;

  /// The locale for text localization
  final Locale locale;

  /// Whether to save preferences locally
  final bool savePreferences;

  /// Custom theme configuration
  final CountdownThemeData? theme;

  /// Callback when the countdown reaches zero
  final VoidCallback? onCountdownComplete;

  /// Callback when user changes settings
  final Function(CountdownConfig)? onConfigChanged;

  const CountdownConfig({
    required this.targetDate,
    this.timezone = 'France',
    this.locale = const Locale('en'),
    this.savePreferences = true,
    this.theme,
    this.onCountdownComplete,
    this.onConfigChanged,
  });

  CountdownConfig copyWith({
    DateTime? targetDate,
    String? timezone,
    Locale? locale,
    bool? savePreferences,
    CountdownThemeData? theme,
    VoidCallback? onCountdownComplete,
    Function(CountdownConfig)? onConfigChanged,
  }) {
    return CountdownConfig(
      targetDate: targetDate ?? this.targetDate,
      timezone: timezone ?? this.timezone,
      locale: locale ?? this.locale,
      savePreferences: savePreferences ?? this.savePreferences,
      theme: theme ?? this.theme,
      onCountdownComplete: onCountdownComplete ?? this.onCountdownComplete,
      onConfigChanged: onConfigChanged ?? this.onConfigChanged,
    );
  }
}

/// Theme data for the countdown widget
class CountdownThemeData {
  /// Primary gradient colors
  final List<Color> gradientColors;

  /// Text colors
  final Color primaryTextColor;
  final Color secondaryTextColor;

  /// Card styling
  final Color cardBackgroundColor;
  final Color cardBorderColor;
  final double cardBorderRadius;

  /// Icon styling
  final Color iconColor;
  final double iconSize;

  /// Animation settings
  final Duration animationDuration;
  final bool enableHeartAnimation;
  final bool enablePulseAnimation;

  const CountdownThemeData({
    this.gradientColors = const [
      Color(0xFFFFB6C1), // Rose clair
      Color(0xFFFF69B4), // Rose hot
      Color(0xFFFF1493), // Rose profond
    ],
    this.primaryTextColor = Colors.white,
    this.secondaryTextColor = const Color(0xFF8B0000),
    this.cardBackgroundColor = const Color(0xFFFFFFFF),
    this.cardBorderColor = const Color(0xFFFFB6C1),
    this.cardBorderRadius = 15.0,
    this.iconColor = Colors.white,
    this.iconSize = 50.0,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.enableHeartAnimation = true,
    this.enablePulseAnimation = true,
  });

  /// Predefined romantic theme
  static const CountdownThemeData romantic = CountdownThemeData();

  /// Predefined elegant theme
  static const CountdownThemeData elegant = CountdownThemeData(
    gradientColors: [
      Color(0xFF2C3E50),
      Color(0xFF4A6741),
      Color(0xFF708090),
    ],
    secondaryTextColor: Color(0xFF2C3E50),
    cardBorderColor: Color(0xFF708090),
  );

  /// Predefined vibrant theme
  static const CountdownThemeData vibrant = CountdownThemeData(
    gradientColors: [
      Color(0xFFFF6B6B),
      Color(0xFF4ECDC4),
      Color(0xFF45B7D1),
    ],
    secondaryTextColor: Color(0xFF2980B9),
    cardBorderColor: Color(0xFF3498DB),
  );
}
