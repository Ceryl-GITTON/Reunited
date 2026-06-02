import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:reunited_countdown_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const ReunitedCountdownApp());
    // Advance past the 500ms delayed widget init to fire pending timers
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byType(ReunitedCountdownApp), findsOneWidget);
    // Dispose the widget tree so periodic timers are cancelled via dispose()
    await tester.pumpWidget(const SizedBox());
  });
}
