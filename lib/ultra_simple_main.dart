import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const UltraSimpleApp());
}

class UltraSimpleApp extends StatelessWidget {
  const UltraSimpleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reunited Countdown',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const CountdownPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CountdownPage extends StatefulWidget {
  const CountdownPage({super.key});

  @override
  State<CountdownPage> createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  late Timer _timer;
  DateTime _targetDate = DateTime.now().add(const Duration(days: 30));
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final diff = _targetDate.difference(now);
      setState(() {
        _timeLeft = diff.isNegative ? Duration.zero : diff;
      });
    });
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_targetDate),
      );
      if (time != null) {
        setState(() {
          _targetDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours % 24;
    final minutes = _timeLeft.inMinutes % 60;
    final seconds = _timeLeft.inSeconds % 60;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFB6C1), Color(0xFFFF69B4), Color(0xFFFF1493)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Titre
                const Text(
                  '💕 Countdown des Retrouvailles',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // Compteur
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: _timeLeft == Duration.zero
                      ? Column(
                          children: [
                            const Icon(Icons.celebration, size: 80, color: Colors.pink),
                            const SizedBox(height: 20),
                            Text(
                              '🎉 C\'est l\'heure !',
                              style: TextStyle(fontSize: 24, color: Colors.pink[800]),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildTimeBox(days, 'Jours'),
                                _buildTimeBox(hours, 'Heures'),
                                _buildTimeBox(minutes, 'Minutes'),
                                _buildTimeBox(seconds, 'Sec'),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'RDV le ${_targetDate.day.toString().padLeft(2, '0')}/${_targetDate.month.toString().padLeft(2, '0')}/${_targetDate.year} à ${_targetDate.hour.toString().padLeft(2, '0')}:${_targetDate.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 16, color: Colors.pink),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                ),
                
                const SizedBox(height: 30),
                
                // Boutons
                ElevatedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Changer la date'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                ),
                
                const SizedBox(height: 15),
                
                TextButton.icon(
                  onPressed: () => _showAPKDialog(context),
                  icon: const Icon(Icons.android, color: Colors.white70),
                  label: const Text(
                    '📱 APK Android avec Widget',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeBox(int value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.pink[200]!, width: 2),
      ),
      child: Column(
        children: [
          Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink),
          ),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.pink)),
        ],
      ),
    );
  }

  void _showAPKDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [Icon(Icons.android, color: Colors.green), SizedBox(width: 8), Text('Version Android')],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📱 Widget sur écran d\'accueil'),
            Text('🔔 Notifications automatiques'),
            Text('🌍 Support multi-langues'),
            SizedBox(height: 15),
            Text('📥 Téléchargement :', style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(
              'github.com/Ceryl-GITTON/Reunited/releases',
              style: TextStyle(color: Colors.blue, fontSize: 12),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
