import 'package:flutter/material.dart';

class KazipoaHome extends StatelessWidget {
  const KazipoaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Stack(
        children: [
          /// 🔥 Background Image
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Image.network(
                "https://lh3.googleusercontent.com/aida-public/AB6AXuAMUK-cTg5FrbJX9SkACIuuueFIf99ImWrd1qiILpsa3dUXJW7dAirfSWwV1gj0_RPP4SC402Fg4uqy0spKMLKydK2mae8wEIloUxaHfTINcau3A3HEdQgXi_ILsD5sSuhsZZBCcyO3WWWBIO3p2bJk7-csSPa9KlESy3NCNU0_R1f0VayWB71RxBYmlVX4QW9E-A1swTiXR3SF5U1Qz2aFWYlTBbYi4KC96K_XRtf7Tti9cEm4jL-5fairq-zM1dYjg10dJBaY8tY",
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// 🔥 Dark Overlay Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.4),
                    Colors.black.withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          /// 🔥 Main Content
          SafeArea(
            child: Column(
              children: [
                /// 🔝 Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              "https://lh3.googleusercontent.com/aida-public/AB6AXuBT1J9LykOpxqLecYB_F83xh5KrD6CpPuyxhl8mGRs3jz5crhxIVdipTPYJ24xAgpzDgsYmnrKHJYFBtXzUCZ4LlHR0YaHe1zzXiVuXlb2dtqgoIvHizvmD4Iqj9xH618njMTF9KxZCMHwVUmRHQ6EwNzT3UuCvC1GxCzAHWEg63d04TFj9vN1U335LYNR_Xwb7BMBMECnUwfaikqsiKOd7Zv-ubOx74ny2kRarWQp4rgDVQa9zkYDpaVve2UWkKjphDY2dkN7zoQk",
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Kaz!poa",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      _glassButton("Ruka"),
                    ],
                  ),
                ),

                const Spacer(),

                /// 🔥 Hero Section
                Column(
                  children: const [
                    Text(
                      "Karibu Kaz!poa",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        letterSpacing: 3,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Huduma kiganjani",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                /// 🔥 Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _roleCard(
                          icon: Icons.search,
                          title: "Kupata Huduma",
                          desc:
                              "Natafuta mtaalamu wa kufanya kazi yangu sasa hivi.",
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _roleCard(
                          icon: Icons.work,
                          title: "Kutoa Huduma",
                          desc:
                              "Mimi ni mtaalamu na nahitaji kuongeza kipato changu.",
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔥 CTA Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFE2E8F0),
                            Colors.white,
                            Color(0xFFCBD5E1),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Ruka",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔻 Footer
                const Text(
                  "Tayari una akaunti?",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Glass Button
  Widget _glassButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 🔹 Role Card
  Widget _roleCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            desc,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}