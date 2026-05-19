import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class MyOfficeEnhanced extends StatefulWidget {
  const MyOfficeEnhanced({super.key});

  @override
  State<MyOfficeEnhanced> createState() => _MyOfficeEnhancedState();
}

class _MyOfficeEnhancedState extends State<MyOfficeEnhanced> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background glow
          Positioned(
            top: -100,
            right: -100,
            child: _glow(),
          ),
          Positioned(
            bottom: -120,
            left: -80,
            child: _glow(),
          ),

          SafeArea(
            child: Column(
              children: [
                _topBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _subscriptionCard(),
                        const SizedBox(height: 16),
                        _sectionTitle("Mifumo ya Malipo"),
                        const SizedBox(height: 10),
                        _paymentGrid(),
                        const SizedBox(height: 16),
                        _sectionTitle("Malengo yangu"),
                        const SizedBox(height: 10),
                        _goalCard("Kufikia wateja wapya 20 mwezi huu", true),
                        _goalCard("Kununua vifaa vipya vya ofisi", false),
                        const SizedBox(height: 16),
                        _sectionTitle("Ratiba yangu"),
                        const SizedBox(height: 10),
                        _scheduleCard(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
          );
  }

  // ---------------- TOP BAR ----------------
  Widget _topBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.black54,
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button to Dashboard
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              context.go('/wasifu/pro_dashboard');
            },
            child: const Text(
              '<',
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            "Kazipoa",
            style: TextStyle(
              color: Colors.cyan,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              "https://lh3.googleusercontent.com/aida-public/AB6AXuA_hbBiw___7FnfXaRoPKQtZHe1lBnIi7Ne7m-djyx4SIOs8NDUtIns7pLNHcboOR3uYYulM1afhc7AjYzsxPgPL-KvOWTAQ_n7ZfijkgUTmBbWbkZopi_Qy-Vlib7wv-ek6AXo_NLQxOvsVAVE4P4NCq6gDTexMg7mKC5AnKery4QPtQS_hL7Aj6OidOBI_t-4ayJ8zSyocEEQ_BhDy-w1MQ2Ztv5ANrVHuHqzi6VU8DIdR2dQ51BbSUlXOvK18c_F2x_JiCxx6bc",
            ),
          )
        ],
      ),
    );
  }

  // ---------------- SUBSCRIPTION ----------------
  Widget _subscriptionCard() {
    return _glass(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Usajili wa Mwezi",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text("TSH 45,000 / mwezi",
              style: TextStyle(color: Colors.cyan, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.75,
            backgroundColor: Colors.white10,
            valueColor: const AlwaysStoppedAnimation(Colors.cyan),
          ),
          const SizedBox(height: 6),
          const Text("Bado siku 8 kabla ya usajili kuisha",
              style: TextStyle(color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }

  // ---------------- PAYMENT GRID ----------------
  Widget _paymentGrid() {
    return Row(
      children: [
        Expanded(
          child: _glass(
            child: Column(
              children: const [
                Icon(Icons.payments, color: Colors.cyan, size: 32),
                SizedBox(height: 10),
                Text("Lipa Namba", style: TextStyle(color: Colors.white54, fontSize: 10)),
                SizedBox(height: 4),
                Text("556677",
                    style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _glass(
            child: Column(
              children: const [
                Icon(Icons.qr_code_scanner, color: Colors.black),
                SizedBox(height: 10),
                Text("Skani Barcode", style: TextStyle(color: Colors.white54, fontSize: 10)),
                SizedBox(height: 4),
                Text("Pokea Malipo",
                    style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- GOALS ----------------
  Widget _goalCard(String text, bool done) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _glassDecoration(),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.cyan),
              color: done ? Colors.cyan : Colors.transparent,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                decoration: done ? null : TextDecoration.lineThrough,
              ),
            ),
          )
        ],
      ),
    );
  }

  // ---------------- SCHEDULE ----------------
  Widget _scheduleCard() {
    return _glass(
      child: Column(
        children: const [
          ListTile(
            title: Text("Ukarabati wa AC", style: TextStyle(color: Colors.white)),
            subtitle: Text("Amina Juma", style: TextStyle(color: Colors.white54)),
            trailing: Text("10:00 AM", style: TextStyle(color: Colors.cyan)),
          ),
          Divider(color: Colors.white10),
          ListTile(
            title: Text("Ukaguzi wa Umeme", style: TextStyle(color: Colors.white)),
            subtitle: Text("NHC Office", style: TextStyle(color: Colors.white54)),
            trailing: Text("02:30 PM", style: TextStyle(color: Colors.cyan)),
          ),
        ],
      ),
    );
  }

  
  // ---------------- GLASS WIDGET ----------------
  Widget _glass({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: _glassDecoration(),
          child: child,
        ),
      ),
    );
  }

  BoxDecoration _glassDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.06),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.1)),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.cyan,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _glow() {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.cyan.withOpacity(0.25),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}