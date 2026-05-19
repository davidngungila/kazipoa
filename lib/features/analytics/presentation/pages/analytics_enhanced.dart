import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AnalyticsEnhanced extends StatelessWidget {
  const AnalyticsEnhanced({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 20),
                    _earningsCard(),
                    const SizedBox(height: 16),
                    _statsRow(),
                    const SizedBox(height: 16),
                    _jobStatsCard(),
                    const SizedBox(height: 16),
                    _insightCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
          );
  }

  // ---------------- TOP BAR ----------------
  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            "Kazipoa",
            style: TextStyle(
              color: Color(0xFF00D1FF),
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const CircleAvatar(
            backgroundColor: Colors.white10,
            child: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _header() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Uchambuzi wa Utendaji",
          style: TextStyle(
            color: Color(0xFF00D1FF),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 6),
        Text(
          "Ripoti ya Uchambuzi",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  // ---------------- EARNINGS ----------------
  Widget _earningsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Mapato ya Mwezi",
            style: TextStyle(color: Colors.white54, fontSize: 10),
          ),
          SizedBox(height: 10),
          Text(
            "1,250,000 TZS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "+12.5% tangu mwezi uliopita",
            style: TextStyle(
              color: Color(0xFF00D1FF),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- STATS ----------------
  Widget _statsRow() {
    return Row(
      children: [
        Expanded(child: _miniStat("4.9", "Rating")),
        const SizedBox(width: 10),
        Expanded(child: _miniStat("124", "Kazi")),
        const SizedBox(width: 10),
        Expanded(child: _miniStat("98%", "Imekamilika")),
      ],
    );
  }

  Widget _miniStat(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- JOB STATS ----------------
  Widget _jobStatsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _jobRow("Kazi Zote", "124"),
          _jobRow("Zilizokubaliwa", "118"),
          _jobRow("Zilizofutwa", "4", danger: true),
          _jobRow("Zinasubiri", "2", highlight: true),
        ],
      ),
    );
  }

  Widget _jobRow(String title, String value,
      {bool danger = false, bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Text(
            value,
            style: TextStyle(
              color: danger
                  ? Colors.redAccent
                  : highlight
                      ? const Color(0xFF00D1FF)
                      : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- INSIGHTS ----------------
  Widget _insightCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ushauri wa Kitaalamu",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _insight(
          "Ongeza mapato yako",
          "Wateja wengi hutafuta huduma mwisho wa wiki.",
        ),
        const SizedBox(height: 10),
        _insight(
          "Boresha Wasifu",
          "Picha bora huongeza maombi mara 3 zaidi.",
        ),
      ],
    );
  }

  Widget _insight(String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(desc,
              style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  }