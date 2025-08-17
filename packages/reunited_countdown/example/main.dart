import 'package:flutter/material.dart';
import 'package:reunited_countdown/reunited_countdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reunited Countdown Example',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const CountdownExample(),
    );
  }
}

class CountdownExample extends StatelessWidget {
  const CountdownExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Set target date to 30 days from now
    final targetDate = DateTime.now().add(const Duration(days: 30));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdown Widget Demo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: ReunitedCountdown(
        config: CountdownConfig(
          targetDate: targetDate,
          timezone: 'France',
          locale: const Locale('en'),
          theme: CountdownThemeData.romantic,
          onCountdownComplete: () {
            // Show celebration dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('🎉 Celebration!'),
                content: const Text('The countdown has reached zero!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          onConfigChanged: (newConfig) {
            print('Configuration changed: \${newConfig.targetDate}');
          },
        ),
      ),
    );
  }
}

// Example of different themes
class ThemeExamples extends StatelessWidget {
  const ThemeExamples({super.key});

  @override
  Widget build(BuildContext context) {
    final targetDate = DateTime.now().add(const Duration(days: 7));

    return Scaffold(
      appBar: AppBar(title: const Text('Theme Examples')),
      body: PageView(
        children: [
          // Romantic theme
          ReunitedCountdown(
            config: CountdownConfig(
              targetDate: targetDate,
              theme: CountdownThemeData.romantic,
            ),
          ),

          // Elegant theme
          ReunitedCountdown(
            config: CountdownConfig(
              targetDate: targetDate,
              theme: CountdownThemeData.elegant,
            ),
          ),

          // Vibrant theme
          ReunitedCountdown(
            config: CountdownConfig(
              targetDate: targetDate,
              theme: CountdownThemeData.vibrant,
            ),
          ),

          // Custom theme
          ReunitedCountdown(
            config: CountdownConfig(
              targetDate: targetDate,
              theme: const CountdownThemeData(
                gradientColors: [
                  Color(0xFF667eea),
                  Color(0xFF764ba2),
                ],
                primaryTextColor: Colors.white,
                secondaryTextColor: Color(0xFF4a5568),
                cardBorderColor: Color(0xFF667eea),
                enableHeartAnimation: false,
                enablePulseAnimation: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
