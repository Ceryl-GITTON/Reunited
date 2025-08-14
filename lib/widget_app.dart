import 'package:flutter/material.dart';
import 'package:reunited_countdown/reunited_countdown.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const ReunitedCountdownWidgetApp());
}

class ReunitedCountdownWidgetApp extends StatelessWidget {
  const ReunitedCountdownWidgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reunited Countdown Widget',
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
      home: const CountdownWidget(),
    );
  }
}

class CountdownWidget extends StatefulWidget {
  const CountdownWidget({super.key});

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  @override
  Widget build(BuildContext context) {
    // Widget optimisé pour écran d'accueil
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF6B9D),
              Color(0xFFE91E63),
              Color(0xFFAD1457),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: ReunitedCountdown(
          config: CountdownConfig(
            targetDate: DateTime.now().add(const Duration(minutes: 2)),
            timezone: 'Local',
            locale: Localizations.localeOf(context),
            theme: CountdownThemeData.romantic.copyWith(
              // Style compact pour widget
              primaryColor: Colors.white,
              backgroundColor: Colors.transparent,
              textColor: Colors.white,
            ),
            onCountdownComplete: () {
              // Action quand le compte à rebours se termine
              _showCompletionNotification();
            },
          ),
        ),
      ),
    );
  }

  void _showCompletionNotification() {
    // Notification native ou callback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 Compte à rebours terminé !'),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
