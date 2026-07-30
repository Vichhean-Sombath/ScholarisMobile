import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scholaris/app.dart';

void main() {
  testWidgets('App builds and shows login when unauthenticated', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: ScholarisApp()),
    );

    // The auth notifier starts in loading, then moves to unauthenticated.
    // Pump enough frames for async init and any redirect animations.
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('Scholaris'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });
}
