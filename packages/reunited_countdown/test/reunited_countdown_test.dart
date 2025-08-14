import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:reunited_countdown/reunited_countdown.dart';

void main() {
  group('ReunitedCountdown Package Tests', () {
    testWidgets('ReunitedCountdown widget renders correctly', (WidgetTester tester) async {
      final targetDate = DateTime.now().add(const Duration(days: 1));
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReunitedCountdown(
              config: CountdownConfig(
                targetDate: targetDate,
                timezone: 'Local',
                savePreferences: false,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Vérifier que le widget se rend sans erreur
      expect(find.byType(ReunitedCountdown), findsOneWidget);
      
      // Vérifier la présence de l'icône de cœur
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    test('CountdownConfig creates correctly', () {
      final targetDate = DateTime.now().add(const Duration(days: 7));
      
      final config = CountdownConfig(
        targetDate: targetDate,
        timezone: 'France',
        locale: const Locale('fr'),
        savePreferences: true,
      );

      expect(config.targetDate, equals(targetDate));
      expect(config.timezone, equals('France'));
      expect(config.locale.languageCode, equals('fr'));
      expect(config.savePreferences, isTrue);
    });

    test('CountdownConfig copyWith works correctly', () {
      final originalDate = DateTime.now().add(const Duration(days: 7));
      final newDate = DateTime.now().add(const Duration(days: 14));
      
      final originalConfig = CountdownConfig(
        targetDate: originalDate,
        timezone: 'France',
        locale: const Locale('en'),
      );

      final newConfig = originalConfig.copyWith(
        targetDate: newDate,
        timezone: 'Indonesia',
      );

      expect(newConfig.targetDate, equals(newDate));
      expect(newConfig.timezone, equals('Indonesia'));
      expect(newConfig.locale.languageCode, equals('en')); // Should remain unchanged
    });

    test('CountdownThemeData predefined themes exist', () {
      // Test que les thèmes prédéfinis existent
      expect(CountdownThemeData.romantic, isNotNull);
      expect(CountdownThemeData.elegant, isNotNull);
      expect(CountdownThemeData.vibrant, isNotNull);

      // Test que les couleurs sont différentes
      expect(CountdownThemeData.romantic.gradientColors, 
             isNot(equals(CountdownThemeData.elegant.gradientColors)));
      expect(CountdownThemeData.elegant.gradientColors, 
             isNot(equals(CountdownThemeData.vibrant.gradientColors)));
    });

    test('TimezoneConfig returns correct offsets', () {
      // Test des offsets de fuseaux horaires
      expect(TimezoneConfig.getTimezoneOffset('Indonesia'), equals(7));
      
      // France devrait retourner 1 ou 2 (selon DST)
      final franceOffset = TimezoneConfig.getTimezoneOffset('France');
      expect(franceOffset, isIn([1, 2]));
      
      // Timezone inconnue devrait retourner 0
      expect(TimezoneConfig.getTimezoneOffset('Unknown'), equals(0));
    });

    test('TimezoneConfig display names are correct', () {
      // Test des noms d'affichage en différentes langues
      expect(TimezoneConfig.getTimezoneDisplayName('France', 'en'), equals('France'));
      expect(TimezoneConfig.getTimezoneDisplayName('France', 'fr'), equals('France'));
      expect(TimezoneConfig.getTimezoneDisplayName('France', 'id'), equals('Prancis'));

      expect(TimezoneConfig.getTimezoneDisplayName('Indonesia', 'en'), equals('Indonesia (Java)'));
      expect(TimezoneConfig.getTimezoneDisplayName('Indonesia', 'fr'), equals('Indonésie (Java)'));
      expect(TimezoneConfig.getTimezoneDisplayName('Indonesia', 'id'), equals('Indonesia (Jawa)'));
    });

    testWidgets('ReunitedCountdown with custom theme renders correctly', (WidgetTester tester) async {
      final targetDate = DateTime.now().add(const Duration(hours: 1));
      
      const customTheme = CountdownThemeData(
        gradientColors: [Colors.blue, Colors.green],
        primaryTextColor: Colors.white,
        secondaryTextColor: Colors.black,
        enableHeartAnimation: false,
        enablePulseAnimation: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReunitedCountdown(
              config: CountdownConfig(
                targetDate: targetDate,
                theme: customTheme,
                savePreferences: false,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Vérifier que le widget se rend avec le thème personnalisé
      expect(find.byType(ReunitedCountdown), findsOneWidget);
    });

    testWidgets('ReunitedCountdown with disabled features works', (WidgetTester tester) async {
      final targetDate = DateTime.now().add(const Duration(minutes: 30));
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReunitedCountdown(
              config: CountdownConfig(
                targetDate: targetDate,
                savePreferences: false,
              ),
              allowDateModification: false,
              showLanguageSelector: false,
              showTimezoneSelector: false,
            ),
          ),
        ),
      );

      await tester.pump();

      // Le widget devrait se rendre même avec les fonctionnalités désactivées
      expect(find.byType(ReunitedCountdown), findsOneWidget);
    });
  });

  group('Edge Cases Tests', () {
    test('Handles past target date', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 1));
      
      final config = CountdownConfig(
        targetDate: pastDate,
        timezone: 'Local',
      );

      // Ne devrait pas lever d'exception
      expect(config.targetDate, equals(pastDate));
    });

    test('Handles very far future date', () {
      final farFutureDate = DateTime.now().add(const Duration(days: 365 * 10));
      
      final config = CountdownConfig(
        targetDate: farFutureDate,
        timezone: 'Local',
      );

      expect(config.targetDate, equals(farFutureDate));
    });
  });
}
