// Basic Flutter widget test for GymLog app

import 'package:flutter_test/flutter_test.dart';
import 'package:gymlog/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GymLogApp());

    // Verify that the app name appears on splash screen
    expect(find.text('GymLog'), findsOneWidget);
    expect(find.text('Health Calculator'), findsOneWidget);
  });
}
