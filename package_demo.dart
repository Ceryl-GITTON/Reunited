import 'package:flutter/material.dart';
import 'package:reunited_countdown/reunited_countdown.dart';

void main() {
  runApp(const ReunitedCountdownDemo());
}

class ReunitedCountdownDemo extends StatelessWidget {
  const ReunitedCountdownDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reunited Countdown Package Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const PackageDemoScreen(),
    );
  }
}

class PackageDemoScreen extends StatelessWidget {
  const PackageDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Package Demo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: PageView(
        children: [
          // Demo 1: Basic usage
          _buildBasicDemo(),

          // Demo 2: Elegant theme
          _buildElegantDemo(),

          // Demo 3: Vibrant theme
          _buildVibrantDemo(),

          // Demo 4: Custom theme
          _buildCustomDemo(),
        ],
      ),
    );
  }

  Widget _buildBasicDemo() {
    final targetDate = DateTime.now().add(const Duration(days: 30));

    return ReunitedCountdown(
      config: CountdownConfig(
        targetDate: targetDate,
        timezone: 'France',
        locale: const Locale('en'),
        theme: CountdownThemeData.romantic,
        onCountdownComplete: () {
          print('Romantic countdown completed! 💖');
        },
      ),
    );
  }

  Widget _buildElegantDemo() {
    final targetDate = DateTime.now().add(const Duration(days: 7));

    return ReunitedCountdown(
      config: CountdownConfig(
        targetDate: targetDate,
        timezone: 'Indonesia',
        locale: const Locale('en'),
        theme: CountdownThemeData.elegant,
        onCountdownComplete: () {
          print('Elegant countdown completed! ✨');
        },
      ),
    );
  }

  Widget _buildVibrantDemo() {
    final targetDate = DateTime.now().add(const Duration(days: 14));

    return ReunitedCountdown(
      config: CountdownConfig(
        targetDate: targetDate,
        timezone: 'Local',
        locale: const Locale('fr'),
        theme: CountdownThemeData.vibrant,
        onCountdownComplete: () {
          print('Vibrant countdown completed! 🎉');
        },
      ),
    );
  }

  Widget _buildCustomDemo() {
    final targetDate = DateTime.now().add(const Duration(days: 21));

    return ReunitedCountdown(
      config: CountdownConfig(
        targetDate: targetDate,
        timezone: 'France',
        locale: const Locale('en'),
        theme: const CountdownThemeData(
          gradientColors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
            Color(0xFF6B73FF),
          ],
          primaryTextColor: Colors.white,
          secondaryTextColor: Color(0xFF4a5568),
          cardBorderColor: Color(0xFF667eea),
          enableHeartAnimation: false,
          enablePulseAnimation: true,
          animationDuration: Duration(milliseconds: 2000),
        ),
        onCountdownComplete: () {
          print('Custom countdown completed! 🚀');
        },
      ),
      allowDateModification: false, // Read-only demo
    );
  }
}
