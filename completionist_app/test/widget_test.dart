import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/screens/login_screen.dart';

void main() {
  // Helper function to create the LoginScreen widget
  Widget createLoginScreen() {
    return const MaterialApp(home: LoginScreen());
  }

  group('Part B: Widget Tests (User Interface)', () {
    // TEST 1: Presence
    // Goal: Verify that a specific widget (e.g., "Login Button") appears on the screen.
    testWidgets('Login button is present on screen', (
      WidgetTester tester,
    ) async {
      // Build the LoginScreen
      await tester.pumpWidget(createLoginScreen());

      // Search for the Login button by its text
      final buttonFinder = find.widgetWithText(ElevatedButton, 'LOGIN');

      // Check that the button appears exactly once
      expect(buttonFinder, findsOneWidget);
    });

    // TEST 2: Text Content
    // Goal: Verify that the screen displays the correct text (e.g., "Welcome, Student").
    testWidgets('Login Screen displays correct welcome text', (
      WidgetTester tester,
    ) async {
      // Build the LoginScreen
      await tester.pumpWidget(createLoginScreen());

      // Find the text widgets
      final welcomeFinder = find.text('Welcome to');
      final appNameFinder = find.text('Completionist');

      // Assert that both texts are found
      expect(welcomeFinder, findsOneWidget);
      expect(appNameFinder, findsOneWidget);
    });

    // TEST 3: State Change
    // Goal: Verify that tapping a button triggers a visual change (e.g., A Checkbox turns from unchecked to checked).
    testWidgets('Tapping "Remember me" checkbox toggles its state', (
      WidgetTester tester,
    ) async {
      // Build the LoginScreen
      await tester.pumpWidget(createLoginScreen());

      // Find the "Remember me" checkbox by its label
      final checkboxFinder = find.byType(Checkbox);

      // Initially, it is UNCHECKED (value is false)
      Checkbox checkbox = tester.widget(checkboxFinder);
      expect(checkbox.value, false);

      // Tap the checkbox
      await tester.tap(checkboxFinder);
      await tester.pump();

      // Now, it should be CHECKED (value is true)
      checkbox = tester.widget(checkboxFinder);
      expect(checkbox.value, true);
    });
  });
}
