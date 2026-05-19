import 'package:flutter/material.dart';

class JobRoomScreen extends StatelessWidget {
  const JobRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ================= MAP BACKGROUND =================
          Positioned.fill(
            child: Image.network(
              "https://lh3.googleusercontent.com/aida-public/AB6AXuBLCB4LrCtpEFNM5s96i1ryV81q3xikfg1YEmMI0jbGfl50sqojKeuRQhZHsFeaIMGpZx2xZQxmzK3muD-a76S9CWdMF6kWbs3q3AWc5FA41wfjSGNSz3u0XIkudWL19xzv0ldGW5teFJpcU_c4joNZzSxuwDHBnrUMBW20dNdp0P4DTFZZbzc_wS86cLqh30h8EUsWXaWf8wpTcPY8CY8nZalJpfJKOWcfA8Va6kMuqGkPmUkHFjEZ24ExUj5OCQ-7GSclaIHdY1s",
              fit: BoxFit.cover,
            ),
          ),

          // dark overlay
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.4)),
          ),

          // ================= PRO MARKER =================
          const Positioned(
            top: 250,
            left: 180,
            child: _ProMarker(),
          ),

          // ================= TOP BAR =================
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: _TopBar(),
          ),

          // ================= MAIN CONTENT =================
          Positioned(
            bottom: 100,
            left: 16,
            right: 16,
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  _StatusCard(),
                  SizedBox(height: 16),
                  _ChatCard(),
                  SizedBox(height: 16),
                  _PaymentCard(),
                  SizedBox(height: 16),
                  _FeedbackCard(),
                ],
              ),
            ),
          ),

          // ================= BOTTOM NAV =================
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomNav(),
          ),
        ],
      ),
    );
  }
}

// ================= TOP BAR =================
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Icon(Icons.arrow_back, color: Colors.cyan),
        Text(
          "Job Room",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Icon(Icons.more_vert, color: Colors.grey),
      ],
    );
  }
}

// ================= PRO MARKER =================
class _ProMarker extends StatelessWidget {
  const _ProMarker();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyan.withValues(alpha: 0.2),
              ),
            ),
            Container(
              width: 45,
              height: 45,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(Icons.person, color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text("Pro", style: TextStyle(color: Colors.white)),
      ],
    );
  }
}

// ================= STATUS CARD =================
class _StatusCard extends StatelessWidget {
  const _StatusCard();

  @override
  Widget build(BuildContext context) {
    return _glass(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Hali ya Kazi",
              style: TextStyle(color: Colors.cyan, fontSize: 12)),
          SizedBox(height: 4),
          Text("Uko Njiani",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          SizedBox(height: 8),
          Text("Dakika 8",
              style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ================= CHAT =================
class _ChatCard extends StatelessWidget {
  const _ChatCard();

  @override
  Widget build(BuildContext context) {
    return _glass(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Mazungumzo ya Moja kwa Moja",
              style: TextStyle(color: Colors.cyan, fontSize: 12)),
          SizedBox(height: 10),
          Text("Pro: Nimefika naanza kazi sasa",
              style: TextStyle(color: Colors.white)),
          SizedBox(height: 6),
          Text("Mteja: Sawa, asante",
              style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

// ================= PAYMENT =================
class _PaymentCard extends StatelessWidget {
  const _PaymentCard();

  @override
  Widget build(BuildContext context) {
    return _glass(
      child: Column(
        children: const [
          Text("Muhtasari wa Malipo",
              style: TextStyle(color: Colors.cyan)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Gharama", style: TextStyle(color: Colors.white)),
              Text("45,000 TZS", style: TextStyle(color: Colors.white)),
            ],
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Kamisheni", style: TextStyle(color: Colors.white70)),
              Text("-4,500 TZS", style: TextStyle(color: Colors.red)),
            ],
          ),
          SizedBox(height: 10),
          Divider(color: Colors.white24),
          SizedBox(height: 6),
          Text("Mapato Halisi: 40,500 TZS",
              style: TextStyle(
                  color: Colors.cyan, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ================= FEEDBACK =================
class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard();

  @override
  Widget build(BuildContext context) {
    return _glass(
      child: Column(
        children: const [
          Text("Toa Maoni", style: TextStyle(color: Colors.white)),
          SizedBox(height: 8),
          Icon(Icons.star, color: Colors.amber),
        ],
      ),
    );
  }
}

// ================= BOTTOM NAV =================
class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.home, color: Colors.grey),
          Icon(Icons.calendar_today, color: Colors.grey),
          Icon(Icons.flash_on, color: Colors.cyan),
          Icon(Icons.chat, color: Colors.grey),
          Icon(Icons.person, color: Colors.grey),
        ],
      ),
    );
  }
}

// ================= GLASS EFFECT WRAPPER =================
Widget _glass({required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white12),
    ),
    child: child,
  );
}