import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const ReunitedCountdownApp());
}

class ReunitedCountdownApp extends StatelessWidget {
  const ReunitedCountdownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reunited Countdown',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('fr'), // French
        Locale('id'), // Indonesian
      ],
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
        fontFamily: 'Roboto',
        textTheme: const TextTheme().apply(
          fontFamily: 'Roboto',
          fontFamilyFallback: ['Noto Color Emoji', 'Apple Color Emoji', 'Segoe UI Emoji'],
        ),
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
  
  // Fuseaux horaires avec leurs décalages UTC
  String _selectedTimezone = 'Indonesia'; // Par défaut Indonésie

  // Liste des clés de fuseaux horaires valides
  static const List<String> _validTimezoneKeys = ['France', 'Indonesia'];

  // Fonction pour obtenir l'offset d'un fuseau horaire sans contexte
  int _getTimezoneOffset(String timezoneKey) {
    switch (timezoneKey) {
      case 'France':
        return _getFranceOffset();
      case 'Indonesia':
        return 7;
      default:
        return 0;
    }
  }

  // Fonction pour obtenir la Map des fuseaux avec calcul dynamique
  Map<String, Map<String, dynamic>> _getTimezones(BuildContext context) => {
    'France': {
      'displayName': AppLocalizations.of(context)!.france,
      'flagAsset': 'assets/france_flag.png',
      'flagEmoji': '🇫🇷',
      'offset': _getFranceOffset(), // Calcul dynamique été/hiver
    },
    'Indonesia': {
      'displayName': AppLocalizations.of(context)!.indonesiaJava,
      'flagAsset': 'assets/indonesia_flag.png',
      'flagEmoji': '🇮🇩',
      'offset': 7, // UTC+7
    },
  };

  // Fonction pour calculer l'offset de la France selon la saison
  static int _getFranceOffset() {
    final now = DateTime.now();
    
    // Heure d'été : dernier dimanche de mars à dernier dimanche d'octobre
    final marchLastSunday = _getLastSundayOfMonth(now.year, 3);
    final octoberLastSunday = _getLastSundayOfMonth(now.year, 10);
    
    if (now.isAfter(marchLastSunday) && now.isBefore(octoberLastSunday)) {
      return 2; // UTC+2 (heure d'été)
    } else {
      return 1; // UTC+1 (heure d'hiver)
    }
  }
  
  // Fonction pour trouver le dernier dimanche d'un mois
  static DateTime _getLastSundayOfMonth(int year, int month) {
    // Dernier jour du mois
    final lastDay = DateTime(year, month + 1, 0);
    
    // Trouver le dernier dimanche
    final daysToSubtract = lastDay.weekday % 7;
    return DateTime(lastDay.year, lastDay.month, lastDay.day - daysToSubtract);
  }

  // Fonction pour obtenir le décalage UTC de la machine locale
  int _getLocalTimezoneOffset() {
    final now = DateTime.now();
    final utc = now.toUtc();
    // Le décalage est calculé en heures : heure locale - heure UTC
    final offsetInMinutes = now.timeZoneOffset.inMinutes;
    return (offsetInMinutes / 60).round();
  }

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
    _loadSavedData(); // Charger les données sauvegardées
  }

  // Charger les données sauvegardées
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Charger le fuseau horaire de destination
    final savedTimezone = prefs.getString('selectedTimezone');
    if (savedTimezone != null && _validTimezoneKeys.contains(savedTimezone)) {
      _selectedTimezone = savedTimezone;
    }
    
    // Charger la date de retrouvailles
    final savedDateString = prefs.getString('reunionDate');
    if (savedDateString != null) {
      try {
        _reunionDate = DateTime.parse(savedDateString);
      } catch (e) {
        // Si la date sauvegardée est invalide, utiliser une date par défaut
        _setDefaultReunionDate();
      }
    } else {
      _setDefaultReunionDate();
    }
    
    _updateCountdown();
  }

  // Définir une date par défaut
  void _setDefaultReunionDate() {
    final now = DateTime.now();
    _reunionDate = now.add(const Duration(days: 30));
  }

  // Sauvegarder les données
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Sauvegarder le fuseau horaire
    await prefs.setString('selectedTimezone', _selectedTimezone);
    
    // Sauvegarder la date de retrouvailles
    if (_reunionDate != null) {
      await prefs.setString('reunionDate', _reunionDate!.toIso8601String());
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    if (_reunionDate != null) {
      // Heure actuelle locale
      final now = DateTime.now();
      
      // Obtenir le décalage UTC de la machine locale automatiquement
      final localOffset = _getLocalTimezoneOffset();
      
      // Date de retrouvailles saisie dans le fuseau de destination
      // Je dois la convertir vers mon fuseau local pour calculer le temps restant
      final destinationOffset = _getTimezoneOffset(_selectedTimezone);
      final offsetDifference = localOffset - destinationOffset;
      
      // Convertir l'heure de retrouvailles vers mon fuseau horaire local
      final reunionInMyTimezone = _reunionDate!.add(Duration(hours: offsetDifference));
      
      // Calculer le temps restant depuis ma perspective locale
      final difference = reunionInMyTimezone.difference(now);
      
      setState(() {
        _timeRemaining = difference.isNegative ? Duration.zero : difference;
      });
    }
  }

  Future<void> _selectReunionDate() async {
    // Choisir le fuseau horaire de destination seulement
    final String? selectedTz = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${AppLocalizations.of(context)!.whereWillReunionTakePlace} '),
              Image.asset(
                'assets/globe_icon.png',
                width: 20,
                height: 20,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('🌍');
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _getTimezones(context).entries.map((entry) {
              final timezone = entry.value;
              return ListTile(
                title: timezone['flagAsset'] != null 
                  ? _buildFlagWithText(timezone['flagAsset'], timezone['displayName'])
                  : Text('${timezone['flagEmoji']} ${timezone['displayName']}'),
                onTap: () => Navigator.of(context).pop(entry.key),
              );
            }).toList(),
          ),
        );
      },
    );

    if (selectedTz == null) return;

    setState(() {
      _selectedTimezone = selectedTz;
    });
    
    // Sauvegarder immédiatement le changement
    _saveData();

    // Utiliser l'heure actuelle pour la sélection
    final now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _reunionDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
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
        // Créer la date et heure dans le fuseau de destination (retrouvailles)
        final reunionDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        
        // Stocker directement l'heure de destination
        // Le calcul se fera dans _updateCountdown
        setState(() {
          _reunionDate = reunionDateTime;
        });
        
        // Sauvegarder immédiatement la nouvelle date
        _saveData();
        _updateCountdown();
      }
    }
  }

  String _formatTimeComponent(int value, String label) {
    return '$value\n$label${value > 1 ? 's' : ''}';
  }

  String _getLocalizedTimeLabel(BuildContext context, int value, String timeType) {
    switch (timeType) {
      case 'day':
        return value > 1 ? AppLocalizations.of(context)!.days : AppLocalizations.of(context)!.day;
      case 'hour':
        return value > 1 ? AppLocalizations.of(context)!.hours : AppLocalizations.of(context)!.hour;
      case 'minute':
        return value > 1 ? AppLocalizations.of(context)!.minutes : AppLocalizations.of(context)!.minute;
      case 'second':
        return value > 1 ? AppLocalizations.of(context)!.seconds : AppLocalizations.of(context)!.second;
      default:
        return '';
    }
  }

  Widget _buildFlagWithText(String flagAsset, String text) {
    return Row(
      children: [
        Image.asset(
          flagAsset,
          width: 24,
          height: 24,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.flag, size: 24);
          },
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }

  Widget _buildCenteredFlagWithText(String flagAsset, String text, TextStyle style) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          flagAsset,
          width: 20,
          height: 20,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.flag, size: 20);
          },
        ),
        const SizedBox(width: 8),
        Text(text, style: style, textAlign: TextAlign.center),
      ],
    );
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
                    Text(
                      AppLocalizations.of(context)!.timeBeforeReunion,
                      style: const TextStyle(
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
                                      AppLocalizations.of(context)!.itsTime,
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
                                        _buildTimeCard(days, _getLocalizedTimeLabel(context, days, 'day')),
                                        _buildTimeCard(hours, _getLocalizedTimeLabel(context, hours, 'hour')),
                                        _buildTimeCard(minutes, _getLocalizedTimeLabel(context, minutes, 'minute')),
                                        _buildTimeCard(seconds, _getLocalizedTimeLabel(context, seconds, 'second')),
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    if (_reunionDate != null)
                                      Column(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.appointmentOn(DateFormat('dd/MM/yyyy à HH:mm').format(_reunionDate!)),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.pink[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8),
                                          Builder(
                                            builder: (context) {
                                              final timezone = _getTimezones(context)[_selectedTimezone]!;
                                              if (timezone['flagAsset'] != null) {
                                                return _buildCenteredFlagWithText(
                                                  timezone['flagAsset'], 
                                                  timezone['displayName'],
                                                  TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.pink[600],
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                );
                                              } else {
                                                return Text(
                                                  '${timezone['flagEmoji']} ${timezone['displayName']}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.pink[600],
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                );
                                              }
                                            },
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
                  label: Text(
                    AppLocalizations.of(context)!.modifyReunionDate,
                    style: const TextStyle(
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
            label,
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
