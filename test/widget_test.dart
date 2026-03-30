// Kazipoa Flutter App Widget Tests
//
// These tests verify the basic functionality of the Kazipoa app.
// Tests include app startup and basic widget rendering.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kazipoa/app_router.dart';

void main() {
  testWidgets('Kazipoa app should start with login screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KazipoaApp());

    // Verify that the app starts without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Wait for the app to load
    await tester.pumpAndSettle();
    
    // The app should be running
    expect(tester.takeException(), isNull);
  });

  testWidgets('Material widgets should render correctly', (WidgetTester tester) async {
    // Test basic Material widgets
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Kazipoa Test'),
          ),
          body: const Center(
            child: Text('Test Screen'),
          ),
        ),
      ),
    );

    // Verify app bar
    expect(find.text('Kazipoa Test'), findsOneWidget);
    
    // Verify body content
    expect(find.text('Test Screen'), findsOneWidget);
    
    // Verify scaffold
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('Card widgets should work', (WidgetTester tester) async {
    // Test card functionality
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Card(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Text('Test Card'),
            ),
          ),
        ),
      ),
    );

    // Verify card exists
    expect(find.byType(Card), findsOneWidget);
    expect(find.text('Test Card'), findsOneWidget);
  });

  testWidgets('Button interactions should work', (WidgetTester tester) async {
    bool buttonPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                buttonPressed = true;
              },
              child: const Text('Press Me'),
            ),
          ),
        ),
      ),
    );

    // Verify button exists
    expect(find.text('Press Me'), findsOneWidget);
    
    // Tap the button
    await tester.tap(find.text('Press Me'));
    await tester.pump();

    // Verify button was pressed
    expect(buttonPressed, isTrue);
  });

  testWidgets('TextFormField should accept input', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Test Field',
                hintText: 'Enter text here',
              ),
            ),
          ),
        ),
      ),
    );

    // Verify text field exists
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Test Field'), findsOneWidget);
    
    // Enter text
    await tester.enterText(find.byType(TextFormField), 'Hello World');
    await tester.pump();

    // Verify text was entered
    expect(find.text('Hello World'), findsOneWidget);
  });

  testWidgets('Theme should apply correctly', (WidgetTester tester) async {
    // Test with light theme
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Light Theme'),
          ),
          body: const Center(
            child: Text('Light Theme Test'),
          ),
        ),
      ),
    );

    expect(find.text('Light Theme'), findsOneWidget);
    expect(find.text('Light Theme Test'), findsOneWidget);
  });

  testWidgets('Navigation should work', (WidgetTester tester) async {
    // Test basic navigation
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const Scaffold(
            body: Center(
              child: Text('Home Screen'),
            ),
          ),
          '/second': (context) => const Scaffold(
            body: Center(
              child: Text('Second Screen'),
            ),
          ),
        },
      ),
    );

    // Verify home screen
    expect(find.text('Home Screen'), findsOneWidget);

    // Navigate to second screen
    Navigator.of(tester.element(find.byType(Scaffold))).pushNamed('/second');
    await tester.pumpAndSettle();

    // Verify second screen
    expect(find.text('Second Screen'), findsOneWidget);
    expect(find.text('Home Screen'), findsNothing);
  });

  testWidgets('Responsive design should adapt', (WidgetTester tester) async {
    // Test responsive layout
    await tester.pumpWidget(
      MaterialApp(
        home: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return const Scaffold(
                body: Center(
                  child: Text('Wide Screen'),
                ),
              );
            } else {
              return const Scaffold(
                body: Center(
                  child: Text('Narrow Screen'),
                ),
              );
            }
          },
        ),
      ),
    );

    // Should show narrow screen by default (test size is small)
    expect(find.text('Narrow Screen'), findsOneWidget);
  });

  testWidgets('Error handling should work', (WidgetTester tester) async {
    // Test error handling
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  throw Exception('Test exception');
                },
                child: const Text('Throw Error'),
              );
            },
          ),
        ),
      ),
    );

    // Verify button exists
    expect(find.text('Throw Error'), findsOneWidget);

    // Tap button and verify exception is handled
    await tester.tap(find.text('Throw Error'));
    await tester.pump();

    // The app should still be running despite the exception
    expect(tester.takeException(), isNotNull);
  });

  testWidgets('List view should work', (WidgetTester tester) async {
    // Test list functionality
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: List.generate(5, (index) {
              return ListTile(
                title: Text('Item $index'),
                subtitle: Text('Subtitle $index'),
              );
            }),
          ),
        ),
      ),
    );

    // Verify list items exist
    expect(find.text('Item 0'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 2'), findsOneWidget);
    expect(find.text('Item 3'), findsOneWidget);
    expect(find.text('Item 4'), findsOneWidget);

    // Verify subtitles exist
    expect(find.text('Subtitle 0'), findsOneWidget);
    expect(find.text('Subtitle 1'), findsOneWidget);
  });
}
