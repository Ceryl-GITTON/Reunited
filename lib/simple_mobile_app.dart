import 'package:flutter/material.dart';
import 'package:reunited_countdown/reunited_countdown.dart';

void main() {
  runApp(const SimpleMobileApp());
}

class SimpleMobileApp extends StatelessWidget {
  const SimpleMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reunited Countdown Mobile',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const MobileCountdownScreen(),
    );
  }
}

class MobileCountdownScreen extends StatefulWidget {
  const MobileCountdownScreen({super.key});

  @override
  State<MobileCountdownScreen> createState() => _MobileCountdownScreenState();
}

class _MobileCountdownScreenState extends State<MobileCountdownScreen> {
  int _currentDemo = 0;
  final List<String> _demoNames = ['Demo 1', 'Demo 2', 'Demo 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_demoNames[_currentDemo]),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: () {
              setState(() {
                _currentDemo = (_currentDemo + 1) % _demoNames.length;
              });
            },
          ),
        ],
      ),
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
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.favorite,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                'Reunited Countdown',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              ReunitedCountdown(
                config: CountdownConfig(
                  targetDate: DateTime.now().add(const Duration(minutes: 2)),
                  timezone: 'Local',
                  locale: const Locale('fr'),
                  theme: CountdownThemeData.romantic,
                  onCountdownComplete: () {
                    _showCompletionDialog();
                  },
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentDemo = (_currentDemo - 1) % _demoNames.length;
                      });
                    },
                    child: const Text('Précédent'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentDemo = (_currentDemo + 1) % _demoNames.length;
                      });
                    },
                    child: const Text('Suivant'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Colors.pink),
            SizedBox(width: 8),
            Text('Terminé !'),
          ],
        ),
        content: const Text('Le compte à rebours est terminé ! 🎉'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
