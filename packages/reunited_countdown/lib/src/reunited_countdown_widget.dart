import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'models/countdown_config.dart';
import 'timezone_config.dart';

/// A beautiful countdown widget with customizable themes and localization
class ReunitedCountdown extends StatefulWidget {
  /// Configuration for the countdown widget
  final CountdownConfig config;
  
  /// Whether to show the language selector
  final bool showLanguageSelector;
  
  /// Whether to show the timezone selector
  final bool showTimezoneSelector;
  
  /// Whether to allow date modification
  final bool allowDateModification;

  const ReunitedCountdown({
    super.key,
    required this.config,
    this.showLanguageSelector = true,
    this.showTimezoneSelector = true,
    this.allowDateModification = true,
  });

  @override
  State<ReunitedCountdown> createState() => _ReunitedCountdownState();
}

class _ReunitedCountdownState extends State<ReunitedCountdown>
    with TickerProviderStateMixin {
  late Timer _timer;
  DateTime? _reunionDate;
  Duration _timeRemaining = Duration.zero;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _heartController;
  late Animation<double> _heartAnimation;
  
  String _selectedTimezone = 'France';
  late CountdownConfig _currentConfig;

  @override
  void initState() {
    super.initState();
    _currentConfig = widget.config;
    _selectedTimezone = widget.config.timezone;
    _reunionDate = widget.config.targetDate;
    
    _initializeAnimations();
    _loadSavedData();
    _startTimer();
  }

  void _initializeAnimations() {
    final theme = _currentConfig.theme ?? CountdownThemeData.romantic;
    
    if (theme.enableHeartAnimation) {
      _heartController = AnimationController(
        duration: theme.animationDuration,
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
    }
    
    if (theme.enablePulseAnimation) {
      _pulseController = AnimationController(
        duration: Duration(milliseconds: theme.animationDuration.inMilliseconds * 2),
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
    }
  }

  Future<void> _loadSavedData() async {
    if (!widget.config.savePreferences) return;
    
    final prefs = await SharedPreferences.getInstance();
    
    final savedTimezone = prefs.getString('reunited_countdown_timezone');
    if (savedTimezone != null && TimezoneConfig.availableTimezones.contains(savedTimezone)) {
      _selectedTimezone = savedTimezone;
    }
    
    final savedDateString = prefs.getString('reunited_countdown_date');
    if (savedDateString != null) {
      try {
        _reunionDate = DateTime.parse(savedDateString);
      } catch (e) {
        _reunionDate = widget.config.targetDate;
      }
    }
    
    _updateCountdown();
  }

  Future<void> _saveData() async {
    if (!widget.config.savePreferences) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reunited_countdown_timezone', _selectedTimezone);
    
    if (_reunionDate != null) {
      await prefs.setString('reunited_countdown_date', _reunionDate!.toIso8601String());
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    if (_reunionDate != null) {
      final now = DateTime.now();
      final localOffset = TimezoneConfig.getTimezoneOffset('Local');
      final destinationOffset = TimezoneConfig.getTimezoneOffset(_selectedTimezone);
      final offsetDifference = localOffset - destinationOffset;
      
      final reunionInMyTimezone = _reunionDate!.add(Duration(hours: offsetDifference));
      final difference = reunionInMyTimezone.difference(now);
      
      setState(() {
        _timeRemaining = difference.isNegative ? Duration.zero : difference;
      });
      
      if (_timeRemaining == Duration.zero && widget.config.onCountdownComplete != null) {
        widget.config.onCountdownComplete!();
      }
    }
  }

  Future<void> _selectReunionDate() async {
    if (!widget.allowDateModification) return;

    if (widget.showTimezoneSelector) {
      final String? selectedTz = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Select Timezone'),
                SizedBox(width: 8),
                Icon(Icons.language),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: TimezoneConfig.availableTimezones.map((timezone) {
                return ListTile(
                  title: Text(TimezoneConfig.getTimezoneDisplayName(
                    timezone, 
                    _currentConfig.locale.languageCode
                  )),
                  onTap: () => Navigator.of(context).pop(timezone),
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
        _saveData();
      }
    }

    final now = DateTime.now();
    final theme = _currentConfig.theme ?? CountdownThemeData.romantic;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _reunionDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: theme.gradientColors.first,
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
                seedColor: theme.gradientColors.first,
                brightness: Brightness.light,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        final reunionDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        
        setState(() {
          _reunionDate = reunionDateTime;
        });
        
        _saveData();
        _updateCountdown();
        
        if (widget.config.onConfigChanged != null) {
          widget.config.onConfigChanged!(_currentConfig.copyWith(
            targetDate: reunionDateTime,
            timezone: _selectedTimezone,
          ));
        }
      }
    }
  }

  String _getLocalizedTimeLabel(int value, String timeType) {
    // TODO: Add proper localization support
    switch (timeType) {
      case 'day':
        return value > 1 ? 'days' : 'day';
      case 'hour':
        return value > 1 ? 'hours' : 'hour';
      case 'minute':
        return value > 1 ? 'minutes' : 'minute';
      case 'second':
        return value > 1 ? 'seconds' : 'second';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    if (_currentConfig.theme?.enableHeartAnimation ?? true) {
      _heartController.dispose();
    }
    if (_currentConfig.theme?.enablePulseAnimation ?? true) {
      _pulseController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _currentConfig.theme ?? CountdownThemeData.romantic;
    final days = _timeRemaining.inDays;
    final hours = _timeRemaining.inHours % 24;
    final minutes = _timeRemaining.inMinutes % 60;
    final seconds = _timeRemaining.inSeconds % 60;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: theme.gradientColors,
        ),
      ),
      child: Column(
        children: [
          // Header with heart animation
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (theme.enableHeartAnimation)
                  AnimatedBuilder(
                    animation: _heartAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _heartAnimation.value,
                        child: Icon(
                          Icons.favorite,
                          size: theme.iconSize,
                          color: theme.iconColor,
                        ),
                      );
                    },
                  )
                else
                  Icon(
                    Icons.favorite,
                    size: theme.iconSize,
                    color: theme.iconColor,
                  ),
                const SizedBox(height: 10),
                Text(
                  'Time Before Reunion', // TODO: Localize
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryTextColor,
                    shadows: const [
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

          // Main countdown display
          Expanded(
            child: Center(
              child: theme.enablePulseAnimation
                  ? AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: _buildCountdownCard(theme, days, hours, minutes, seconds),
                        );
                      },
                    )
                  : _buildCountdownCard(theme, days, hours, minutes, seconds),
            ),
          ),

          // Modify button
          if (widget.allowDateModification)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                onPressed: _selectReunionDate,
                icon: Icon(Icons.calendar_today, color: theme.primaryTextColor),
                label: Text(
                  'Modify Date', // TODO: Localize
                  style: TextStyle(
                    color: theme.primaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.gradientColors.last,
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
    );
  }

  Widget _buildCountdownCard(CountdownThemeData theme, int days, int hours, int minutes, int seconds) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: theme.cardBackgroundColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(theme.cardBorderRadius),
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
                Icon(
                  Icons.celebration,
                  size: 80,
                  color: theme.gradientColors.first,
                ),
                const SizedBox(height: 20),
                Text(
                  'It\'s Time!', // TODO: Localize
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.secondaryTextColor,
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeCard(days, _getLocalizedTimeLabel(days, 'day'), theme),
                    _buildTimeCard(hours, _getLocalizedTimeLabel(hours, 'hour'), theme),
                    _buildTimeCard(minutes, _getLocalizedTimeLabel(minutes, 'minute'), theme),
                    _buildTimeCard(seconds, _getLocalizedTimeLabel(seconds, 'second'), theme),
                  ],
                ),
                const SizedBox(height: 30),
                if (_reunionDate != null)
                  Column(
                    children: [
                      Text(
                        'Appointment on ${DateFormat('dd/MM/yyyy à HH:mm').format(_reunionDate!)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.secondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        TimezoneConfig.getTimezoneDisplayName(
                          _selectedTimezone, 
                          _currentConfig.locale.languageCode
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.secondaryTextColor.withOpacity(0.8),
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
    );
  }

  Widget _buildTimeCard(int value, String label, CountdownThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.cardBorderColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: theme.cardBorderColor, width: 2),
      ),
      child: Column(
        children: [
          Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: theme.secondaryTextColor.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
