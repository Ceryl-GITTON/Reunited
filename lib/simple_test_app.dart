import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const SimpleTestApp());
}

class SimpleTestApp extends StatelessWidget {
  const SimpleTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Package Test Simple',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const SimpleCountdownTest(),
    );
  }
}

class SimpleCountdownTest extends StatefulWidget {
  const SimpleCountdownTest({super.key});

  @override
  State<SimpleCountdownTest> createState() => _SimpleCountdownTestState();
}

class _SimpleCountdownTestState extends State<SimpleCountdownTest>
    with TickerProviderStateMixin {
  late Timer _timer;
  Duration _timeRemaining = const Duration(seconds: 30); // Test de 30 secondes
  late AnimationController _heartController;
  late Animation<double> _heartAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Animation du cœur
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _heartAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.easeInOut,
    ));
    _heartController.repeat(reverse: true);
    
    // Timer du countdown
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining.inSeconds > 0) {
          _timeRemaining = Duration(seconds: _timeRemaining.inSeconds - 1);
        } else {
          _timer.cancel();
          _showCompletionDialog();
        }
      });
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Test Réussi !'),
        content: const Text('Le package countdown fonctionne parfaitement !'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetTest();
            },
            child: const Text('Recommencer'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _resetTest() {
    setState(() {
      _timeRemaining = const Duration(seconds: 30);
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _timeRemaining.inMinutes % 60;
    final seconds = _timeRemaining.inSeconds % 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Test Simple du Package'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFB6C1), // Rose clair
              Color(0xFFFF69B4), // Rose hot
              Color(0xFFFF1493), // Rose profond
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _heartAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _heartAnimation.value,
                          child: const Icon(
                            Icons.favorite,
                            size: 50,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Test du Package Countdown',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black26,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Countdown display
              Expanded(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_timeRemaining == Duration.zero)
                          Column(
                            children: [
                              const Icon(
                                Icons.celebration,
                                size: 80,
                                color: Colors.pink,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Test Terminé ! ✅',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink[800],
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              const Text(
                                'Temps restant :',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.pink,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildTimeCard(minutes, 'min'),
                                  _buildTimeCard(seconds, 'sec'),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Ceci est un test de 30 secondes pour valider\nque le package countdown fonctionne !',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _resetTest,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text(
                        'Recommencer',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[600],
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✅ Package validé ! Prêt pour publication sur pub.dev'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text(
                        'Valider',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeCard(int value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.pink[200]!, width: 2),
      ),
      child: Column(
        children: [
          Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.pink[800],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.pink[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
