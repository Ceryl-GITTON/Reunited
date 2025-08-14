import 'package:flutter/material.dart';
import 'package:reunited_countdown/reunited_countdown.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const ReunitedCountdownMobileApp());
}

class ReunitedCountdownMobileApp extends StatefulWidget {
  const ReunitedCountdownMobileApp({super.key});

  @override
  State<ReunitedCountdownMobileApp> createState() => _ReunitedCountdownMobileAppState();
}

class _ReunitedCountdownMobileAppState extends State<ReunitedCountdownMobileApp> {
  Locale? _locale;

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reunited Countdown Mobile',
      locale: _locale,
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
        fontFamily: 'Roboto',
      ),
      home: MobileCountdownScreen(onLanguageChange: _changeLanguage),
    );
  }
}

class MobileCountdownScreen extends StatefulWidget {
  final Function(Locale) onLanguageChange;
  
  const MobileCountdownScreen({super.key, required this.onLanguageChange});

  @override
  State<MobileCountdownScreen> createState() => _MobileCountdownScreenState();
}

class _MobileCountdownScreenState extends State<MobileCountdownScreen> {
  int _currentDemo = 0;
  final List<String> _demoNames = ['Package Demo', 'Romantic Theme', 'Elegant Theme', 'Vibrant Theme'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_demoNames[_currentDemo]),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Language selector
          PopupMenuButton<String>(
            icon: const Icon(Icons.language, color: Colors.white),
            onSelected: (String languageCode) {
              widget.onLanguageChange(Locale(languageCode));
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'en',
                child: Row(
                  children: [
                    const Text('🇬🇧'),
                    const SizedBox(width: 8),
                    const Text('English'),
                    if (Localizations.localeOf(context).languageCode == 'en')
                      const Icon(Icons.check, color: Colors.pink, size: 16),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'fr',
                child: Row(
                  children: [
                    const Text('🇫🇷'),
                    const SizedBox(width: 8),
                    const Text('Français'),
                    if (Localizations.localeOf(context).languageCode == 'fr')
                      const Icon(Icons.check, color: Colors.pink, size: 16),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'id',
                child: Row(
                  children: [
                    const Text('🇮🇩'),
                    const SizedBox(width: 8),
                    const Text('Indonesia'),
                    if (Localizations.localeOf(context).languageCode == 'id')
                      const Icon(Icons.check, color: Colors.pink, size: 16),
                  ],
                ),
              ),
            ],
          ),
          // Demo selector
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white),
            onPressed: () {
              setState(() {
                _currentDemo = (_currentDemo + 1) % _demoNames.length;
              });
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: _buildCurrentDemo(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.pink[50],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _currentDemo = (_currentDemo - 1) % _demoNames.length;
                });
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text('Précédent', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[400],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _currentDemo = (_currentDemo + 1) % _demoNames.length;
                });
              },
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
              label: const Text('Suivant', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[600],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentDemo() {
    final targetDate = DateTime.now().add(Duration(days: _currentDemo + 1));

    switch (_currentDemo) {
      case 0: // Package Demo
        return ReunitedCountdown(
          config: CountdownConfig(
            targetDate: DateTime.now().add(const Duration(minutes: 2)),
            timezone: 'Local',
            locale: Localizations.localeOf(context),
            theme: CountdownThemeData.romantic,
            onCountdownComplete: () {
              _showCompletionDialog('Package Demo terminé ! 🎉');
            },
          ),
        );

      case 1: // Romantic Theme
        return ReunitedCountdown(
          config: CountdownConfig(
            targetDate: targetDate,
            timezone: 'France',
            locale: Localizations.localeOf(context),
            theme: CountdownThemeData.romantic,
            onCountdownComplete: () {
              _showCompletionDialog('Thème Romantique ! 💖');
            },
          ),
        );

      case 2: // Elegant Theme
        return ReunitedCountdown(
          config: CountdownConfig(
            targetDate: targetDate,
            timezone: 'Indonesia',
            locale: Localizations.localeOf(context),
            theme: CountdownThemeData.elegant,
            onCountdownComplete: () {
              _showCompletionDialog('Thème Élégant ! ✨');
            },
          ),
        );

      case 3: // Vibrant Theme
        return ReunitedCountdown(
          config: CountdownConfig(
            targetDate: targetDate,
            timezone: 'Local',
            locale: Localizations.localeOf(context),
            theme: CountdownThemeData.vibrant,
            onCountdownComplete: () {
              _showCompletionDialog('Thème Vibrant ! 🌈');
            },
          ),
        );

      default:
        return const Center(child: Text('Demo not found'));
    }
  }

  void _showCompletionDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Colors.pink),
            SizedBox(width: 8),
            Text('Félicitations !'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 16),
            const Text(
              'Le package Reunited Countdown fonctionne parfaitement sur mobile !',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Génial !'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentDemo = (_currentDemo + 1) % _demoNames.length;
              });
            },
            child: const Text('Démo suivante'),
          ),
        ],
      ),
    );
  }
}
