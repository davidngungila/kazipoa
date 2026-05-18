import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class OfisiYanguScreen extends StatelessWidget {
  const OfisiYanguScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background glow (liquid feel)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.5,
                  colors: [
                    Color.fromRGBO(56, 189, 248, 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                _topAppBar(context),
                const SizedBox(height: 16),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _titleSection(),
                        const SizedBox(height: 16),
                        _tabBar(),
                        const SizedBox(height: 20),
                        _sectionHeader(),
                        const SizedBox(height: 10),

                        _bookingCard(
                          name: "Amani Msemaji",
                          price: "TZS 75,000",
                          date: "Okt 24, 2023",
                          time: "10:00 AM",
                          id: "#SP-8821",
                          expired: false,
                        ),

                        const SizedBox(height: 12),

                        _bookingCard(
                          name: "Zuwena Nassor",
                          price: "TZS 50,000",
                          date: "Okt 25, 2023",
                          time: "02:30 PM",
                          id: "#SP-8910",
                          expired: false,
                        ),

                        const SizedBox(height: 12),

                        _bookingCard(
                          name: "Baraka Juma",
                          price: "TZS 35,000",
                          date: "Okt 20, 2023",
                          time: "09:00 AM",
                          id: "#SP-8742",
                          expired: true,
                        ),
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

  // ---------- TOP BAR ----------
  Widget _topAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              GoRouter.of(context).go('/wasifu/pro_dashboard');
            },
            child: const Text(
              '<',
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            "Kazipoa",
            style: TextStyle(
              color: Colors.lightBlueAccent,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white12,
            child: Icon(Icons.person, color: Colors.white),
          )
        ],
      ),
    );
  }

  // ---------- TITLE ----------
  Widget _titleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "PLATINUM PRO",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        Text(
          "Miadi Yako",
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Simamia maombi na ratiba zako leo.",
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  // ---------- TAB BAR ----------
  Widget _tabBar() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _tab("Maombi Mapya", true),
          _tab("Zilizokubaliwa", false),
          _tab("Zilizokataliwa", false),
        ],
      ),
    );
  }

  Widget _tab(String title, bool active) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.lightBlueAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: active ? Colors.black : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  // ---------- SECTION HEADER ----------
  Widget _sectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Maombi Mapya (2)",
          style: TextStyle(
            color: Colors.lightBlueAccent,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "LEO",
          style: TextStyle(color: Colors.white54, fontSize: 10),
        ),
      ],
    );
  }

  // ---------- BOOKING CARD ----------
  Widget _bookingCard({
    required String name,
    required String price,
    required String date,
    required String time,
    required String id,
    required bool expired,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  const SizedBox(height: 4),
                  Text("Ushauri wa Biashara",
                      style: const TextStyle(color: Colors.lightBlueAccent)),
                  Text(price,
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
              Text(id,
                  style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text(time,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {},
                  child: const Text("Kubali"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text("Kataa"),
                ),
              ),
            ],
          ),

          if (expired) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Maombi haya yameisha muda wake",
                  style: TextStyle(color: Colors.redAccent, fontSize: 10),
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}