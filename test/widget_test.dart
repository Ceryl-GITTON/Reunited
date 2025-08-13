import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reunited_countdown/main.dart';

void main() {
  testWidgets('Countdown app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ReunitedCountdownApp());

    // Verify that the app displays the countdown screen
    expect(find.text('Temps avant nos retrouvailles'), findsOneWidget);
    expect(find.text('Modifier la date des retrouvailles'), findsOneWidget);
    
    // Verify heart icon is present
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
