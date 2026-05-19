import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ProfileSettingsEnhanced extends StatelessWidget {
  const ProfileSettingsEnhanced({super.key});

  Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: child,
    );
  }

  Widget _serviceItem(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          const Icon(Icons.remove_circle_outline, color: Colors.red),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),

      // TOP APP BAR
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.7),
        elevation: 0,
        title: const Text(
          "Kazipoa",
          style: TextStyle(
            color: Color(0xFF38BDF8),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Text(
            '<',
            style: TextStyle(
              color: Color(0xFF38BDF8),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            context.go('/wasifu/pro_dashboard');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF38BDF8)),
            onPressed: () {},
          )
        ],
      ),

      // BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "TAARIFA ZA MSINGI",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            _glassCard(
              child: Row(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61",
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFF38BDF8),
                          child: const Icon(Icons.edit,
                              size: 14, color: Colors.black),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Jina Kamili",
                        labelStyle: TextStyle(color: Color(0xFF38BDF8)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF38BDF8)),
                        ),
                      ),
                      controller: TextEditingController(text: "David Ngugila"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "KATEGORIA YA HUDUMA",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 10),

            _glassCard(
              child: DropdownButtonFormField<String>(
                dropdownColor: Colors.black,
                initialValue: "Programu na Teknolojia",
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(
                      value: "Ujenzi na Ukarabati",
                      child: Text("Ujenzi na Ukarabati")),
                  DropdownMenuItem(
                      value: "Programu na Teknolojia",
                      child: Text("Programu na Teknolojia")),
                  DropdownMenuItem(
                      value: "Usafirishaji",
                      child: Text("Usafirishaji")),
                  DropdownMenuItem(
                      value: "Elimu na Mafunzo",
                      child: Text("Elimu na Mafunzo")),
                ],
                onChanged: (value) {},
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "HUDUMA ZINAZOTOLEWA",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 10),

            _glassCard(
              child: Column(
                children: [
                  _serviceItem("Ukarabati wa Bomba"),
                  _serviceItem("Ufungaji wa Sinki"),
                  _serviceItem("Mifumo ya Maji"),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle,
                        color: Color(0xFF38BDF8)),
                    label: const Text(
                      "ONGEZA HUDUMA",
                      style: TextStyle(color: Color(0xFF38BDF8)),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "GHARAMA",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 10),

            _glassCard(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      keyboardType: TextInputType.number,
                      controller:
                          TextEditingController(text: "45000"),
                      decoration: const InputDecoration(
                        labelText: "Kiwango cha Saa",
                        labelStyle: TextStyle(color: Color(0xFF38BDF8)),
                      ),
                    ),
                  ),
                  const Text(
                    "TZS",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "MAHALI PA KAZI",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 10),

            _glassCard(
              child: Column(
                children: [
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller:
                        TextEditingController(text: "Masaki, Dar es Salaam"),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_on,
                          color: Colors.grey),
                      labelText: "Eneo la Kazi",
                      labelStyle: TextStyle(color: Color(0xFF38BDF8)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 120,
                    color: Colors.grey.shade900,
                    child: const Center(
                      child: Icon(Icons.location_pin,
                          color: Color(0xFF38BDF8), size: 40),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38BDF8),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: () {},
                icon: const Icon(Icons.save),
                label: const Text(
                  "HIFADHI MABADILIKO",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
