import 'package:flutter/material.dart';
import 'package:kazipoa/core/widgets/custom_bottom_navigation.dart';

/// Test widget to verify responsive bottom navigation behavior
class ResponsiveNavTest extends StatelessWidget {
  const ResponsiveNavTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Navigation Test'),
        backgroundColor: const Color(0xFF0F00E7),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Responsive Navigation Test',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Test the bottom navigation on different screen sizes:\n'
              '• Small phones (320 width)\n'
              '• Medium phones (375 width)\n'
              '• Large phones/tablets (768 width)\n'
              '• Desktop (1024+ width)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'The navigation should adapt its:\n'
              '• Height (12% of screen height)\n'
              '• Icon sizes (6% of screen width)\n'
              '• Font sizes (2.5-3% of screen width)\n'
              '• Border radius (8% of screen width)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentRoute: '/home',
        screenWidth: MediaQuery.of(context).size.width,
      ),
    );
  }
}
