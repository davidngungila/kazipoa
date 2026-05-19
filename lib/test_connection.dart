import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TestConnection extends StatelessWidget {
  const TestConnection({super.key});

  // List of tables to test
  final List<String> _tables = const [
    'profiles',
    'pros',
    'services',
    'bookings',
    'conversations',
    'messages',
    // add more table names as needed
  ];

  Future<void> _testAll(BuildContext context) async {
    for (final table in _tables) {
      try {
        final data = await Supabase.instance.client.from(table).select();
        debugPrint('Data from $table: $data');
      } catch (e) {
        debugPrint('Error fetching from $table: $e');
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Supabase query completed - check console')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supabase Test')), 
      body: Center(
        child: ElevatedButton(
          onPressed: () => _testAll(context),
          child: const Text('Test All Tables'),
        ),
      ),
    );
  }
}
