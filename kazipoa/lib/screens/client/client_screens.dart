import 'package:flutter/material.dart';

class ClientBrowseScreen extends StatelessWidget {
  const ClientBrowseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Professionals'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Browse Professionals - Coming Soon'),
      ),
    );
  }
}

class ClientBookingsScreen extends StatelessWidget {
  const ClientBookingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('My Bookings - Coming Soon'),
      ),
    );
  }
}

class ClientProfileScreen extends StatelessWidget {
  const ClientProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Profile'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Client Profile - Coming Soon'),
      ),
    );
  }
}
