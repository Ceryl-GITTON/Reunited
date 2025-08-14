import 'package:flutter/material.dart';
import 'package:reunited_countdown_package/reunited_countdown.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const PackageTestApp());
}

class PackageTestApp extends StatelessWidget {
  const PackageTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Package Test App',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('id'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const TestHomePage(),
    );
  }
}

class TestHomePage extends StatelessWidget {
  const TestHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Package Tests'),
        backgroundColor: Colors.pink[100],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Reunited Countdown Package Tests',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // Test 1: Thèmes prédéfinis
          _buildTestCard(
            context,
            '🎨 Predefined Themes',
            'Test all 3 predefined themes with different configurations',
            () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => const ThemeTestScreen(),
            )),
          ),
          
          // Test 2: Configurations avancées
          _buildTestCard(
            context,
            '⚙️ Advanced Config',
            'Test custom themes, animations, and callbacks',
            () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => const AdvancedTestScreen(),
            )),
          ),
          
          // Test 3: Fuseaux horaires
          _buildTestCard(
            context,
            '🌍 Timezone Tests',
            'Test different timezones and DST calculations',
            () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => const TimezoneTestScreen(),
            )),
          ),
          
          // Test 4: Performance
          _buildTestCard(
            context,
            '⚡ Performance Test',
            'Test multiple widgets and memory usage',
            () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => const PerformanceTestScreen(),
            )),
          ),
          
          // Test 5: Test rapide
          _buildTestCard(
            context,
            '🚀 Quick Demo',
            'Simple countdown demo in 30 seconds',
            () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => const QuickDemoScreen(),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildTestCard(BuildContext context, String title, String description, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

// Test des thèmes
class ThemeTestScreen extends StatefulWidget {
  const ThemeTestScreen({super.key});

  @override
  State<ThemeTestScreen> createState() => _ThemeTestScreenState();
}

class _ThemeTestScreenState extends State<ThemeTestScreen> {
  int _currentTheme = 0;
  final List<String> _themeNames = ['Romantic', 'Elegant', 'Vibrant'];

  @override
  Widget build(BuildContext context) {
    final targetDate = DateTime.now().add(const Duration(minutes: 5));

    return Scaffold(
      appBar: AppBar(
        title: Text('Theme: ${_themeNames[_currentTheme]}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: () {
              setState(() {
                _currentTheme = (_currentTheme + 1) % _themeNames.length;
              });
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: _buildThemeTest(targetDate),
    );
  }

  Widget _buildThemeTest(DateTime targetDate) {
    switch (_currentTheme) {
      case 0:
        return ReunitedCountdown(
          config: CountdownConfig(
            targetDate: targetDate,
            timezone: 'France',
            theme: CountdownThemeData.romantic,
            onCountdownComplete: () => _showResult('Romantic theme test completed! 💖'),
          ),
        );
      case 1:
        return ReunitedCountdown(
          config: CountdownConfig(
            targetDate: targetDate,
            timezone: 'Indonesia',
            theme: CountdownThemeData.elegant,
            onCountdownComplete: () => _showResult('Elegant theme test completed! ✨'),
          ),
        );
      case 2:
        return ReunitedCountdown(
          config: CountdownConfig(
            targetDate: targetDate,
            timezone: 'Local',
            theme: CountdownThemeData.vibrant,
            onCountdownComplete: () => _showResult('Vibrant theme test completed! 🎉'),
          ),
        );
      default:
        return const Center(child: Text('Unknown theme'));
    }
  }

  void _showResult(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }
}

// Test avancé
class AdvancedTestScreen extends StatelessWidget {
  const AdvancedTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final targetDate = DateTime.now().add(const Duration(seconds: 30));

    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Config Test')),
      extendBodyBehindAppBar: true,
      body: ReunitedCountdown(
        config: CountdownConfig(
          targetDate: targetDate,
          timezone: 'France',
          theme: const CountdownThemeData(
            gradientColors: [Color(0xFF4A90E2), Color(0xFF7B68EE), Color(0xFF9966CC)],
            primaryTextColor: Colors.white,
            secondaryTextColor: Color(0xFF2C3E50),
            cardBorderRadius: 30.0,
            enableHeartAnimation: false,
            enablePulseAnimation: true,
            animationDuration: Duration(milliseconds: 3000),
          ),
          onCountdownComplete: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🎊 Advanced test completed successfully!'),
                backgroundColor: Colors.purple,
              ),
            );
          },
          onConfigChanged: (config) {
            print('⚙️ Config changed: ${config.targetDate}');
          },
        ),
        allowDateModification: true,
        showLanguageSelector: false,
        showTimezoneSelector: true,
      ),
    );
  }
}

// Test fuseaux horaires
class TimezoneTestScreen extends StatefulWidget {
  const TimezoneTestScreen({super.key});

  @override
  State<TimezoneTestScreen> createState() => _TimezoneTestScreenState();
}

class _TimezoneTestScreenState extends State<TimezoneTestScreen> {
  String _currentTimezone = 'France';
  final List<String> _timezones = ['France', 'Indonesia', 'Local'];

  @override
  Widget build(BuildContext context) {
    final targetDate = DateTime.now().add(const Duration(minutes: 2));

    return Scaffold(
      appBar: AppBar(
        title: Text('Timezone: $_currentTimezone'),
        actions: [
          DropdownButton<String>(
            value: _currentTimezone,
            items: _timezones.map((tz) => DropdownMenuItem(
              value: tz,
              child: Text(tz),
            )).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _currentTimezone = value;
                });
              }
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: ReunitedCountdown(
        config: CountdownConfig(
          targetDate: targetDate,
          timezone: _currentTimezone,
          theme: CountdownThemeData.romantic,
          onCountdownComplete: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Timezone $_currentTimezone test completed! 🌍')),
            );
          },
        ),
      ),
    );
  }
}

// Test de performance
class PerformanceTestScreen extends StatelessWidget {
  const PerformanceTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Performance Test')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          final targetDate = DateTime.now().add(Duration(minutes: index + 1));
          final themes = [
            CountdownThemeData.romantic,
            CountdownThemeData.elegant,
            CountdownThemeData.vibrant,
            CountdownThemeData.romantic,
          ];

          return Card(
            child: ReunitedCountdown(
              config: CountdownConfig(
                targetDate: targetDate,
                timezone: 'Local',
                theme: themes[index],
                savePreferences: false,
              ),
              allowDateModification: false,
              showLanguageSelector: false,
              showTimezoneSelector: false,
            ),
          );
        },
      ),
    );
  }
}

// Demo rapide
class QuickDemoScreen extends StatelessWidget {
  const QuickDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final targetDate = DateTime.now().add(const Duration(seconds: 10));

    return Scaffold(
      appBar: AppBar(title: const Text('Quick Demo (10s)')),
      extendBodyBehindAppBar: true,
      body: ReunitedCountdown(
        config: CountdownConfig(
          targetDate: targetDate,
          timezone: 'Local',
          theme: CountdownThemeData.vibrant,
          onCountdownComplete: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('🎉 Demo Complete!'),
                content: const Text('The package is working perfectly!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Awesome!'),
                  ),
                ],
              ),
            );
          },
        ),
        allowDateModification: false,
        showLanguageSelector: false,
        showTimezoneSelector: false,
      ),
    );
  }
}
