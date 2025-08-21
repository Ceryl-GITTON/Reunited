import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const SimpleWebApp());
}

class SimpleWebApp extends StatelessWidget {
  const SimpleWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reunited Countdown - Web',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const SimpleCountdownScreen(),
    );
  }
}

class SimpleCountdownScreen extends StatefulWidget {
  const SimpleCountdownScreen({super.key});

  @override
  State<SimpleCountdownScreen> createState() => _SimpleCountdownScreenState();
}

class _SimpleCountdownScreenState extends State<SimpleCountdownScreen>
    with TickerProviderStateMixin {
  late Timer _timer;
  DateTime _reunionDate = DateTime.now().add(const Duration(days: 30));
  Duration _timeRemaining = Duration.zero;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    final now = DateTime.now();
    final difference = _reunionDate.difference(now);

    setState(() {
      _timeRemaining = difference.isNegative ? Duration.zero : difference;
    });
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _reunionDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_reunionDate),
      );

      if (pickedTime != null) {
        setState(() {
          _reunionDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
        _updateCountdown();
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _timeRemaining.inDays;
    final hours = _timeRemaining.inHours % 24;
    final minutes = _timeRemaining.inMinutes % 60;
    final seconds = _timeRemaining.inSeconds % 60;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFB6C1),
              Color(0xFFFF69B4),
              Color(0xFFFF1493),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.web, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Version Web',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Icon(
                      Icons.favorite,
                      size: 50,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Temps avant les retrouvailles',
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

              // Countdown
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
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
                                      'C\'est l\'heure ! 🎉',
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildTimeCard(days, 'Jours'),
                                        _buildTimeCard(hours, 'Heures'),
                                        _buildTimeCard(minutes, 'Minutes'),
                                        _buildTimeCard(seconds, 'Secondes'),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Rendez-vous le ${_reunionDate.day.toString().padLeft(2, '0')}/${_reunionDate.month.toString().padLeft(2, '0')}/${_reunionDate.year} à ${_reunionDate.hour.toString().padLeft(2, '0')}:${_reunionDate.minute.toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.pink[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _selectDate,
                      icon: const Icon(Icons.calendar_today,
                          color: Colors.white),
                      label: const Text(
                        'Modifier la date',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[600],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () => _showDownloadDialog(context),
                      icon: const Icon(Icons.android,
                          color: Colors.white70, size: 20),
                      label: const Text(
                        'Télécharger l\'APK Android avec Widget',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.pink[800],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.pink[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showDownloadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.android, color: Colors.green),
              SizedBox(width: 8),
              Text('Version Android'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Téléchargez l\'APK Android pour :'),
              SizedBox(height: 10),
              Text('📱 Widget sur écran d\'accueil'),
              Text('🔔 Notifications automatiques'),
              Text('⏰ Mise à jour en arrière-plan'),
              Text('🌍 Support multi-langues'),
              SizedBox(height: 15),
              Text('🔗 Lien de téléchargement :'),
              SelectableText(
                'github.com/Ceryl-GITTON/Reunited/releases',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
