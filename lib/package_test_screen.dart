import 'package:flutter/material.dart';
import 'package:reunited_countdown_package/reunited_countdown.dart';

class PackageTestScreen extends StatefulWidget {
  const PackageTestScreen({super.key});

  @override
  State<PackageTestScreen> createState() => _PackageTestScreenState();
}

class _PackageTestScreenState extends State<PackageTestScreen> {
  int _currentTheme = 0;
  final List<String> _themeNames = ['Romantic', 'Elegant', 'Vibrant', 'Custom'];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Package Test'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.palette),
            onSelected: (int value) {
              setState(() {
                _currentTheme = value;
              });
            },
            itemBuilder: (BuildContext context) => [
              for (int i = 0; i < _themeNames.length; i++)
                PopupMenuItem<int>(
                  value: i,
                  child: Row(
                    children: [
                      if (_currentTheme == i) 
                        const Icon(Icons.check, color: Colors.pink, size: 16),
                      const SizedBox(width: 8),
                      Text(_themeNames[i]),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: _buildCurrentThemeDemo(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentTheme = (_currentTheme + 1) % _themeNames.length;
          });
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildCurrentThemeDemo() {
    final targetDate = DateTime.now().add(const Duration(days: 15));

    switch (_currentTheme) {
      case 0: // Romantic
        return ReunitedCountdown(
          config: CountdownConfig(
            targetDate: targetDate,
            timezone: 'France',
            locale: const Locale('en'),
            theme: CountdownThemeData.romantic,
            onCountdownComplete: () {
              _showCompletionDialog('Romantic theme completed! 💖');
            },
            onConfigChanged: (newConfig) {
              print('Config changed: ${newConfig.targetDate}');
            },
          ),
        );

      case 1: // Elegant
        return ReunitedCountdown(
          config: CountdownConfig(
            targetDate: targetDate,
            timezone: 'Indonesia',
            locale: const Locale('fr'),
            theme: CountdownThemeData.elegant,
            onCountdownComplete: () {
              _showCompletionDialog('Elegant theme completed! ✨');
            },
          ),
        );

      case 2: // Vibrant
        return ReunitedCountdown(
          config: CountdownConfig(
            targetDate: targetDate,
            timezone: 'Local',
            locale: const Locale('id'),
            theme: CountdownThemeData.vibrant,
            onCountdownComplete: () {
              _showCompletionDialog('Vibrant theme completed! 🎉');
            },
          ),
        );

      case 3: // Custom
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
              cardBackgroundColor: Color(0xFFF7FAFC),
              cardBorderColor: Color(0xFF667eea),
              cardBorderRadius: 25.0,
              iconColor: Colors.white,
              iconSize: 60.0,
              enableHeartAnimation: false,
              enablePulseAnimation: true,
              animationDuration: Duration(milliseconds: 1500),
            ),
            onCountdownComplete: () {
              _showCompletionDialog('Custom theme completed! 🚀');
            },
          ),
          allowDateModification: true,
          showLanguageSelector: true,
          showTimezoneSelector: true,
        );

      default:
        return const Center(child: Text('Theme not found'));
    }
  }

  void _showCompletionDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎊 Countdown Complete!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }
}

// Widget de test rapide pour les différentes configurations
class QuickTestWidget extends StatelessWidget {
  const QuickTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Test')),
      body: Column(
        children: [
          // Test compact
          Expanded(
            child: ReunitedCountdown(
              config: CountdownConfig(
                targetDate: DateTime.now().add(const Duration(hours: 2, minutes: 30)),
                timezone: 'Local',
                theme: CountdownThemeData.romantic,
                savePreferences: false,
              ),
              allowDateModification: false,
              showLanguageSelector: false,
              showTimezoneSelector: false,
            ),
          ),
          
          // Informations de test
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Test Configuration:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('• Target: +2h 30min from now'),
                Text('• Timezone: Local'),
                Text('• Theme: Romantic'),
                Text('• No modifications allowed'),
                Text('• No language/timezone selectors'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
