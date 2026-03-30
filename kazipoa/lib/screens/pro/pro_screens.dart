import 'package:flutter/material.dart';

class ProHomeScreen extends StatelessWidget {
  const ProHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pro Dashboard'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Pro Dashboard - Coming Soon'),
      ),
    );
  }
}

class ProBookingsScreen extends StatelessWidget {
  const ProBookingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pro Bookings'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Pro Bookings - Coming Soon'),
      ),
    );
  }
}

class ProWasifuScreen extends StatelessWidget {
  const ProWasifuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wasifu (Profile)'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Wasifu Profile - Coming Soon'),
      ),
    );
  }
}

class ProSettingsScreen extends StatelessWidget {
  const ProSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pro Settings'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Pro Settings - Coming Soon'),
      ),
    );
  }
}
