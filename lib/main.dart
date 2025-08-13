import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

void main() {
  tz.initializeTimeZones();
  runApp(const ReunitedCountdownApp());
}

class ReunitedCountdownApp extends StatelessWidget {
  const ReunitedCountdownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reunited Countdown',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const CountdownScreen(),
    );
  }
}

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen>
    with TickerProviderStateMixin {
  late Timer _timer;
  DateTime? _reunionDate;
  Duration _timeRemaining = Duration.zero;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _heartController;
  late Animation<double> _heartAnimation;
  
  // Fuseaux horaires
  String _selectedTimezone = 'Asia/Jakarta'; // Par défaut Indonésie
  final Map<String, String> _timezones = {
    'Europe/Paris': '🇫🇷 France',
    'Asia/Jakarta': '🇮🇩 Indonésie (Java)',
  };

  @override
  void initState() {
    super.initState();
    
    // Animation pour le cœur qui bat
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
    
    // Animation pour l'effet de pulsation
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

    _startAnimations();
    _loadReunionDate();
    _startTimer();
  }

  void _startAnimations() {
    _heartController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
  }

  void _loadReunionDate() {
    // Date par défaut dans 30 jours en heure locale de l'Indonésie
    final jakarta = tz.getLocation('Asia/Jakarta');
    final now = tz.TZDateTime.now(jakarta);
    _reunionDate = now.add(const Duration(days: 30));
    _updateCountdown();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    if (_reunionDate != null) {
      // Obtenir l'heure actuelle dans le fuseau de la France
      final paris = tz.getLocation('Europe/Paris');
      final nowInParis = tz.TZDateTime.now(paris);
      
      // Convertir la date de retrouvailles en heure française pour comparaison
      final selectedLocation = tz.getLocation(_selectedTimezone);
      final reunionInSelectedTz = tz.TZDateTime.from(_reunionDate!, selectedLocation);
      final reunionInParis = tz.TZDateTime.from(reunionInSelectedTz, paris);
      
      final difference = reunionInParis.difference(nowInParis);
      
      setState(() {
        _timeRemaining = difference.isNegative ? Duration.zero : difference;
      });
    }
  }

  Future<void> _selectReunionDate() async {
    // D'abord choisir le fuseau horaire
    final String? selectedTz = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Où auront lieu vos retrouvailles ? 🌍'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _timezones.entries.map((entry) {
              return ListTile(
                title: Text(entry.value),
                onTap: () => Navigator.of(context).pop(entry.key),
              );
            }).toList(),
          ),
        );
      },
    );

    if (selectedTz != null) {
      setState(() {
        _selectedTimezone = selectedTz;
      });
    }

    final selectedLocation = tz.getLocation(_selectedTimezone);
    final nowInSelectedTz = tz.TZDateTime.now(selectedLocation);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _reunionDate?.toLocal() ?? nowInSelectedTz.add(const Duration(days: 1)).toLocal(),
      firstDate: nowInSelectedTz.toLocal(),
      lastDate: nowInSelectedTz.add(const Duration(days: 365)).toLocal(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.pink,
              brightness: Brightness.light,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.pink,
                brightness: Brightness.light,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        // Créer la date dans le fuseau horaire sélectionné
        final reunionDateTime = tz.TZDateTime(
          selectedLocation,
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        
        setState(() {
          _reunionDate = reunionDateTime;
        });
        _updateCountdown();
      }
    }
  }

  String _formatTimeComponent(int value, String label) {
    return '$value\n$label${value > 1 ? 's' : ''}';
  }

  @override
  void dispose() {
    _timer.cancel();
    _heartController.dispose();
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
              Color(0xFFFFB6C1), // Rose clair
              Color(0xFFFF69B4), // Rose hot
              Color(0xFFFF1493), // Rose profond
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header avec titre
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
                      'Temps avant nos retrouvailles',
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

              // Widget de compte à rebours principal
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
                                      'C\'est le moment ! 💕',
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
                                    // Affichage du temps
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildTimeCard(days, 'Jour'),
                                        _buildTimeCard(hours, 'Heure'),
                                        _buildTimeCard(minutes, 'Minute'),
                                        _buildTimeCard(seconds, 'Seconde'),
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    if (_reunionDate != null)
                                      Column(
                                        children: [
                                          Text(
                                            'Rendez-vous le ${DateFormat('dd/MM/yyyy à HH:mm').format(_reunionDate!)}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.pink[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '${_timezones[_selectedTimezone]}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.pink[600],
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
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

              // Bouton pour modifier la date
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton.icon(
                  onPressed: _selectReunionDate,
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  label: const Text(
                    'Modifier la date des retrouvailles',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[600],
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5,
                  ),
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
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
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
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.pink[800],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label + (value > 1 ? 's' : ''),
            style: TextStyle(
              fontSize: 12,
              color: Colors.pink[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
