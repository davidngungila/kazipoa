import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';

class BookingSuccessEnhanced extends StatelessWidget {
  const BookingSuccessEnhanced({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // ================= BOTTOM NAV (UNIFIED) =================
      bottomNavigationBar: CustomBottomNavigation(
        currentRoute: '/miadi/success',
        screenWidth: MediaQuery.of(context).size.width,
      ),

      // ================= BODY =================
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 120),
            child: Column(
              children: [

                // SUCCESS ICON
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00E5FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        size: 60,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                const Text(
                  "Hongera!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Miadi yako imethibitishwa kwa mafanikio",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                // ================= BOOKING CARD =================
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(
                              "https://lh3.googleusercontent.com/aida-public/AB6AXuAIgMJK-oPqCJmIaW6ab0pItWbT6OqoBZCrmZ_C7R3fl9k7Rnb5f0x-JW23bf4IjEzfmaw3jHBRsb1YBjMBGfkeddFt96W5xwfIaebHiBAvzywZVDeMFQAxNoHcFUO8FiUZiZYpNaSY_rfdeXMAlyr5fGDdjIMTX59HxfRvr9NQnZNoOPLVQ8ajSV5xZnE7G-vUKQWGAgIF_VIZqBfv8oo0RDEllfBS42kwHdmpxjLsLMfT0KjQw9vg5wGrPqTKVSiVJMl3ISSKRxc",
                            ),
                          ),
                          const SizedBox(width: 15),

                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mtoa Huduma",
                                style: TextStyle(
                                  color: Colors.cyan,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Juma Saidi",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Ufundi Bomba & Umeme",
                                style: TextStyle(color: Colors.white60),
                              ),
                            ],
                          )
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Tarehe",
                                  style: TextStyle(color: Colors.white60, fontSize: 10)),
                              SizedBox(height: 5),
                              Text("24 Okt, 2023",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Muda",
                                  style: TextStyle(color: Colors.white60, fontSize: 10)),
                              SizedBox(height: 5),
                              Text("10:00 - 11:30",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.05),
                              Colors.white.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "PLATINUM BOOKING",
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              "#PLT-8821",
                              style: TextStyle(
                                color: Color(0xFF00E5FF),
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ================= BUTTONS =================
                _actionButton("Chat with Pro", Icons.chat, true),
                const SizedBox(height: 12),
                _actionButton("Go to My Bookings", Icons.list_alt, false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================

  
  Widget _actionButton(String text, IconData icon, bool primary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: primary ? const Color(0xFF00E5FF) : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: primary ? Colors.black : Colors.white),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: primary ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}