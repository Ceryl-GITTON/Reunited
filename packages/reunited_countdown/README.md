# 💖 Reunited Countdown

A beautiful, customizable countdown widget for Flutter with multi-language support and timezone management. Perfect for romantic apps, event countdowns, and deadline tracking.

## ✨ Features

- 🎯 **Beautiful countdown display** with days, hours, minutes, and seconds
- 🌍 **Multi-timezone support** with automatic DST calculation
- 🎨 **Customizable themes** (Romantic, Elegant, Vibrant, or create your own)
- 🌐 **Localization ready** (English, French, Indonesian)
- ✨ **Smooth animations** (heart beating, pulse effects)
- 💾 **Persistent preferences** with SharedPreferences
- 📱 **Responsive design** that works on all screen sizes
- ⚙️ **Highly configurable** with extensive customization options

## 🚀 Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

\`\`\`yaml
dependencies:
  reunited_countdown: ^1.0.0
\`\`\`

Then run:

\`\`\`bash
flutter pub get
\`\`\`

### Basic Usage

\`\`\`dart
import 'package:flutter/material.dart';
import 'package:reunited_countdown/reunited_countdown.dart';

class MyCountdownPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set your target date
    final targetDate = DateTime(2025, 12, 25, 18, 30); // Christmas 2025

    return Scaffold(
      body: ReunitedCountdown(
        config: CountdownConfig(
          targetDate: targetDate,
          timezone: 'France',
          locale: Locale('en'),
        ),
      ),
    );
  }
}
\`\`\`

## 🎨 Themes

The package comes with three predefined themes:

### Romantic Theme (Default)
\`\`\`dart
ReunitedCountdown(
  config: CountdownConfig(
    targetDate: yourDate,
    theme: CountdownThemeData.romantic,
  ),
)
\`\`\`

### Elegant Theme
\`\`\`dart
ReunitedCountdown(
  config: CountdownConfig(
    targetDate: yourDate,
    theme: CountdownThemeData.elegant,
  ),
)
\`\`\`

### Vibrant Theme
\`\`\`dart
ReunitedCountdown(
  config: CountdownConfig(
    targetDate: yourDate,
    theme: CountdownThemeData.vibrant,
  ),
)
\`\`\`

### Custom Theme
\`\`\`dart
ReunitedCountdown(
  config: CountdownConfig(
    targetDate: yourDate,
    theme: CountdownThemeData(
      gradientColors: [Color(0xFF667eea), Color(0xFF764ba2)],
      primaryTextColor: Colors.white,
      secondaryTextColor: Color(0xFF4a5568),
      enableHeartAnimation: true,
      enablePulseAnimation: false,
    ),
  ),
)
\`\`\`

## 🌍 Timezone Support

The widget supports multiple timezones with automatic DST (Daylight Saving Time) calculation:

\`\`\`dart
ReunitedCountdown(
  config: CountdownConfig(
    targetDate: yourDate,
    timezone: 'France',     // Supports DST
    // timezone: 'Indonesia', // UTC+7
    // timezone: 'Local',     // User's local timezone
  ),
)
\`\`\`

## ⚙️ Configuration Options

\`\`\`dart
CountdownConfig(
  targetDate: DateTime.now().add(Duration(days: 30)),
  timezone: 'France',
  locale: Locale('en'),
  savePreferences: true,              // Save user settings
  theme: CountdownThemeData.romantic,
  onCountdownComplete: () {
    // Called when countdown reaches zero
    print('Time\'s up!');
  },
  onConfigChanged: (newConfig) {
    // Called when user changes settings
    print('Configuration updated');
  },
)
\`\`\`

## 🎛️ Widget Options

\`\`\`dart
ReunitedCountdown(
  config: yourConfig,
  showLanguageSelector: true,    // Show language dropdown
  showTimezoneSelector: true,    // Show timezone selection
  allowDateModification: true,   // Allow user to change date
)
\`\`\`

## 🌐 Supported Languages

- 🇬🇧 English
- 🇫🇷 French
- 🇮🇩 Indonesian

## 📱 Responsive Design

The widget automatically adapts to different screen sizes and orientations, making it perfect for:
- Mobile apps
- Tablet interfaces
- Desktop applications
- Web applications

## 🎯 Use Cases

- **Romantic apps**: Countdown to anniversaries, dates, proposals
- **Event management**: Conference countdowns, product launches
- **Holiday apps**: Christmas, New Year, vacation countdowns
- **Deadline tracking**: Project deadlines, exam dates
- **Travel apps**: Trip departure countdowns

## 🔧 Advanced Customization

### Custom Animation Duration
\`\`\`dart
CountdownThemeData(
  animationDuration: Duration(milliseconds: 1500),
  enableHeartAnimation: true,
  enablePulseAnimation: false,
)
\`\`\`

### Custom Colors and Styling
\`\`\`dart
CountdownThemeData(
  gradientColors: [Colors.purple, Colors.blue, Colors.teal],
  cardBackgroundColor: Colors.white,
  cardBorderColor: Colors.purple,
  cardBorderRadius: 20.0,
  iconColor: Colors.white,
  iconSize: 60.0,
)
\`\`\`

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💝 Acknowledgments

- Inspired by the need for beautiful countdown widgets in romantic applications
- Built with love for the Flutter community
- Special thanks to all contributors

---

Made with 💖 by [Ceryl GITTON](https://github.com/Ceryl-GITTON)
