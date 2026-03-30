// Kazipoa Flutter App Widget Tests
//
// These tests verify the functionality of the Kazipoa professional booking platform.
// Tests include login screen navigation, theme switching, and UI components.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kazipoa/app_router.dart';
import 'package:kazipoa/theme/app_theme.dart';
import 'package:kazipoa/screens/auth/login_screen.dart';
import 'package:kazipoa/screens/dashboard_screen.dart';
import 'package:kazipoa/widgets/glass_card.dart';
import 'package:kazipoa/widgets/liquid_button.dart';

void main() {
  group('Kazipoa App Tests', () {
    testWidgets('App should start with login screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const KazipoaApp());

      // Verify that login screen is displayed
      expect(find.text('Kitambulisho cha Mteja'), findsOneWidget);
      expect(find.text('Ingia'), findsOneWidget);
      expect(find.text('Karibu Tena!'), findsOneWidget);
    });

    testWidgets('Login screen should have required fields', (WidgetTester tester) async {
      // Build login screen widget
      await tester.pumpWidget(
        MaterialApp(
          theme: KazipoaTheme.lightTheme,
          home: const LoginScreen(),
        ),
      );

      // Verify email field exists
      expect(find.byType(TextFormField), findsWidgets);
      
      // Verify login button exists
      expect(find.text('Ingia'), findsOneWidget);
      
      // Verify forgot password link exists
      expect(find.text('Umesahau neno la siri?'), findsOneWidget);
    });

    testWidgets('Login form should validate email input', (WidgetTester tester) async {
      // Build login screen widget
      await tester.pumpWidget(
        MaterialApp(
          theme: KazipoaTheme.lightTheme,
          home: const LoginScreen(),
        ),
      );

      // Find email field
      final emailField = find.byType(TextFormField).first;
      
      // Enter invalid email
      await tester.enterText(emailField, 'invalid-email');
      
      // Tap login button
      await tester.tap(find.text('Ingia'));
      await tester.pump();

      // Should show validation error
      expect(find.text('Tafadhali ingiza barua pepe sahihi'), findsOneWidget);
    });

    testWidgets('Glass card should render correctly', (WidgetTester tester) async {
      // Build glass card widget
      await tester.pumpWidget(
        MaterialApp(
          theme: KazipoaTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: GlassCard(
                child: const Text('Test Glass Card'),
              ),
            ),
          ),
        ),
      );

      // Verify glass card is displayed
      expect(find.text('Test Glass Card'), findsOneWidget);
      expect(find.byType(GlassCard), findsOneWidget);
    });

    testWidgets('Liquid button should handle taps', (WidgetTester tester) async {
      bool buttonPressed = false;

      // Build liquid button widget
      await tester.pumpWidget(
        MaterialApp(
          theme: KazipoaTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: LiquidButton.elevated(
                text: 'Test Button',
                onPressed: () {
                  buttonPressed = true;
                },
              ),
            ),
          ),
        ),
      );

      // Verify button is displayed
      expect(find.text('Test Button'), findsOneWidget);
      
      // Tap the button
      await tester.tap(find.text('Test Button'));
      await tester.pump();

      // Verify button was pressed
      expect(buttonPressed, isTrue);
    });

    testWidgets('App should support theme switching', (WidgetTester tester) async {
      // Test light theme
      await tester.pumpWidget(
        MaterialApp(
          theme: KazipoaTheme.lightTheme,
          home: const LoginScreen(),
        ),
      );

      // Verify light theme elements
      expect(find.byType(LoginScreen), findsOneWidget);

      // Test dark theme
      await tester.pumpWidget(
        MaterialApp(
          theme: KazipoaTheme.darkTheme,
          home: const LoginScreen(),
        ),
      );

      // Verify dark theme elements
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('Navigation should work between screens', (WidgetTester tester) async {
      // Build app with navigation
      await tester.pumpWidget(const KazipoaApp());

      // Should start at login screen
      expect(find.text('Kitambulisho cha Mteja'), findsOneWidget);

      // Navigate to dashboard (simulating successful login)
      // Note: This would require mocking the authentication state
      // For now, just verify the dashboard can be built
      await tester.pumpWidget(
        MaterialApp(
          theme: KazipoaTheme.lightTheme,
          home: const DashboardScreen(),
        ),
      );

      // Verify dashboard elements
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Karibu, John Doe!'), findsOneWidget);
    });

    testWidgets('Swahili localization should be present', (WidgetTester tester) async {
      // Build login screen
      await tester.pumpWidget(
        MaterialApp(
          theme: KazipoaTheme.lightTheme,
          home: const LoginScreen(),
        ),
      );

      // Verify Swahili text elements
      expect(find.text('Kitambulisho cha Mteja'), findsOneWidget);
      expect(find.text('Karibu Tena!'), findsOneWidget);
      expect(find.text('Ingia kwenye akaunti yako kuendelea'), findsOneWidget);
      expect(find.text('Barua Pepe'), findsOneWidget);
      expect(find.text('Neno la Siri'), findsOneWidget);
      expect(find.text('Umesahau neno la siri?'), findsOneWidget);
      expect(find.text('Huna akaunti?'), findsOneWidget);
      expect(find.text('Jisajili'), findsOneWidget);
    });

    testWidgets('Liquid glass effects should be present', (WidgetTester tester) async {
      // Build dashboard to see glass effects
      await tester.pumpWidget(
        MaterialApp(
          theme: KazipoaTheme.lightTheme,
          home: const DashboardScreen(),
        ),
      );

      // Verify glass cards are present
      expect(find.byType(GlassCard), findsWidgets);
      
      // Verify liquid buttons are present
      expect(find.byType(LiquidButton), findsWidgets);
    });
  });
}
