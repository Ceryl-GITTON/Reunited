import 'dart:async';
import 'dart:io';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

class WidgetService {
  static const String _widgetName = 'ReunitedCountdownWidget';
  static const String _androidProviderName = 'ReunitedCountdownWidgetProvider';
  
  // Date de retrouvailles (même que dans l'app principale)
  static final DateTime _reunionDate = DateTime(2025, 9, 15, 10, 0); // 15 septembre 2025, 10h00
  
  /// Initialise le service de widget
  static Future<void> initialize() async {
    // Le widget n'est disponible que sur mobile (Android/iOS)
    if (!_isMobilePlatform()) return;
    
    try {
      await HomeWidget.setAppGroupId('group.reunited.countdown');
    } catch (e) {
      // Ignore les erreurs sur les plateformes non supportées
      print('Widget initialization failed: $e');
    }
  }
  
  /// Vérifie si on est sur une plateforme mobile
  static bool _isMobilePlatform() {
    return Platform.isAndroid || Platform.isIOS;
  }
  
  /// Met à jour les données du widget
  static Future<void> updateWidget() async {
    // Le widget n'est disponible que sur mobile (Android/iOS)
    if (!_isMobilePlatform()) return;
    
    try {
      final now = DateTime.now();
      final difference = _reunionDate.difference(now);
      
      if (difference.isNegative) {
        // La date est passée
        await HomeWidget.saveWidgetData<String>('status', 'completed');
        await HomeWidget.saveWidgetData<String>('message', 'Nous sommes réunis! 💖');
      } else {
        // Calcul du temps restant
        final days = difference.inDays;
        final hours = difference.inHours % 24;
        final minutes = difference.inMinutes % 60;
        final seconds = difference.inSeconds % 60;
        
        await HomeWidget.saveWidgetData<String>('status', 'counting');
        await HomeWidget.saveWidgetData<int>('days', days);
        await HomeWidget.saveWidgetData<int>('hours', hours);
        await HomeWidget.saveWidgetData<int>('minutes', minutes);
        await HomeWidget.saveWidgetData<int>('seconds', seconds);
        
        // Format de la date de réunion
        final dateFormat = DateFormat('dd MMMM yyyy', 'fr_FR');
        await HomeWidget.saveWidgetData<String>('reunion_date', dateFormat.format(_reunionDate));
        
        // Titre personnalisé selon la langue (pour l'instant français par défaut)
        await HomeWidget.saveWidgetData<String>('title', 'Retrouvailles 💖');
        
        // Message d'encouragement
        String message = '';
        if (days > 365) {
          message = 'Plus d\'un an à attendre...';
        } else if (days > 30) {
          message = 'Bientôt les retrouvailles!';
        } else if (days > 7) {
          message = 'Plus que quelques semaines!';
        } else if (days > 0) {
          message = 'C\'est pour très bientôt!';
        } else {
          message = 'C\'est aujourd\'hui! 🎉';
        }
        await HomeWidget.saveWidgetData<String>('message', message);
      }
      
      // Met à jour le widget sur l'écran d'accueil
      await HomeWidget.updateWidget(
        name: _widgetName,
        androidName: _androidProviderName,
      );
    } catch (e) {
      print('Widget update failed: $e');
    }
  }
  
  /// Démarre la mise à jour automatique du widget (toutes les minutes)
  static Timer? _updateTimer;
  
  static void startAutoUpdate() {
    // Le widget n'est disponible que sur mobile
    if (!_isMobilePlatform()) return;
    
    stopAutoUpdate(); // Arrête le timer existant s'il y en a un
    _updateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      updateWidget();
    });
  }
  
  static void stopAutoUpdate() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }
  
  /// Vérifie si les widgets sont supportés sur cet appareil
  static Future<bool> isWidgetSupported() async {
    if (!_isMobilePlatform()) return false;
    
    try {
      await HomeWidget.setAppGroupId('group.reunited.countdown');
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Ouvre les paramètres de widgets du système
  static Future<void> openWidgetSettings() async {
    if (!_isMobilePlatform()) return;
    
    try {
      await HomeWidget.requestPinWidget(
        name: _widgetName,
        androidName: _androidProviderName,
      );
    } catch (e) {
      print('Widget settings failed: $e');
    }
  }
}
