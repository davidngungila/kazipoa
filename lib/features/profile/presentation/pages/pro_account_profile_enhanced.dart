import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProProfileScreen extends StatelessWidget {
  final String? proId;
  
  const ProProfileScreen({super.key, this.proId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  _header(context),
                  _hero(),
                  _stats(),
                  _services(),
                  _schedule(),
                  _portfolio(),
                  _reviews(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔝 HEADER
  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => GoRouter.of(context).pop(),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Wasifu wa Mtaalamu",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 40)
        ],
      ),
    );
  }

  /// 👤 HERO
  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
              "https://lh3.googleusercontent.com/aida-public/AB6AXuCjMwIhzU7aiNXQ6XoNwF6MlS25cKrl6bSSOTMDQu7SWYOcFHHnM3CDjDVIvAocXCnuC--KzGbU1_x995Jm8vIj0QCjaX0OtDIKlVmQpjRX0KAPCPYnajnCEtQipxJffdNkR_wvNuTVhFZ98tPtAan3ESF6iQxcU_rAPDRB7qr5m55WNJJ_2eriUzc33llW7HGrvx_ZYAU7Oxgh6A_A0E-6WwNlW1g-30B2EeXf0yVSNgXtWDTDoPDSz1GNvML5lSxfBuXVjsgYGzE",
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Professional ID: ${proId ?? 'Unknown'}",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          const Text(
            "Fundi Umeme • Dar es Salaam",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 15),

          /// Button - Only show "fanya booking" for clients
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to booking setup
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text("fanya booking"),
            ),
          )
        ],
      ),
    );
  }

  /// 📊 STATS
  Widget _stats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _statBox("4.9", "DARAJA")),
          const SizedBox(width: 10),
          Expanded(child: _statBox("128", "KAZI")),
          const SizedBox(width: 10),
          Expanded(child: _statBox("8 yrs", "UZOEFU")),
        ],
      ),
    );
  }

  /// 🧩 SERVICES
  Widget _services() {
    final services = [
      "Umeme Nyumbani",
      "Solar",
      "Viwanda",
      "Marekebisho"
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("HUDUMA",
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: services.length,
              itemBuilder: (context, i) {
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: _glass(),
                  child: Center(
                    child: Text(
                      services[i],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  /// 📅 SCHEDULE
  Widget _schedule() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Align(
              alignment: Alignment.centerLeft,
              child: Text("RATIBA",
                  style: TextStyle(color: Colors.white70))),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _timeBox("09:00", true),
              _timeBox("11:30", false),
              _timeBox("14:00", true),
              _timeBox("16:30", true),
            ],
          )
        ],
      ),
    );
  }

  /// 🖼️ PORTFOLIO
  Widget _portfolio() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Align(
              alignment: Alignment.centerLeft,
              child: Text("KAZI ZANGU",
                  style: TextStyle(color: Colors.white70))),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              2,
              (index) => Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage(
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuBj6S8iFRqo3lT2VHtZ9t2EJyDo7Ss6xd5-Q2_xjCczhR4GPznzTA4W4wQE6HPvTNyxzDJGSOT-2O_xIvYAtRDc9h4Id6Macf18eIqoA2Ck6FVLxRhVf2JZXx3Ys149Wp3ubkmJ7ZNWw_yD_bN2YzTfIwdSeJVLAPRgIPoRd8zy7_xSz1hNYS4a6Z1U9SmlIKAewcxDZkYzdXHCLSpDDiKtFSSxzAPUs2DsQJvakTNSHX3CLAPSx_Hck2uEQDa8AazwmfIfNNpGGeo"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 💬 REVIEWS
  Widget _reviews() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: const [
          Align(
              alignment: Alignment.centerLeft,
              child: Text("MAONI",
                  style: TextStyle(color: Colors.white70))),
          SizedBox(height: 10),
          Text(
            "“Kazi nzuri sana!”",
            style: TextStyle(color: Colors.white54),
          )
        ],
      ),
    );
  }

  
  /// 🔹 SMALL COMPONENTS
  static Widget _statBox(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _glass(),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(
                  color: Colors.white54, fontSize: 10)),
        ],
      ),
    );
  }

  static Widget _timeBox(String time, bool available) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: available ? Colors.green.withValues(alpha: 0.2) : Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(time,
          style: const TextStyle(color: Colors.white)),
    );
  }

  static BoxDecoration _glass() {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
    );
  }
}