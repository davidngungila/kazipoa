import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';

class MyBookingsEnhanced extends StatefulWidget {
  const MyBookingsEnhanced({super.key});

  @override
  State<MyBookingsEnhanced> createState() => _MyBookingsEnhancedState();
}

class _MyBookingsEnhancedState extends State<MyBookingsEnhanced> {
  String _selectedCategory = 'Zilizokubaliwa';

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Zilizokubaliwa', 'icon': Icons.check_circle, 'color': Colors.green, 'count': 2},
    {'name': 'Zinasubiri', 'icon': Icons.pending, 'color': Colors.orange, 'count': 5},
    {'name': 'Zilizokataliwa', 'icon': Icons.cancel, 'color': Colors.red, 'count': 1},
    {'name': 'Zilizopita', 'icon': Icons.history, 'color': Colors.grey, 'count': 8},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topBar(),
                const SizedBox(height: 20),
                searchBar(),
                const SizedBox(height: 20),
                categories(),
                const SizedBox(height: 20),
                sectionTitle("MIADI ILIYOKUBALIWA", "2 Miadi"),
                bookingCard(
                  name: "Juma Rashid",
                  role: "Fundi Bomba",
                  image:
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuB8D6FHRQoJ6z0gFQ7mxIM5nYlb-DfuxXw391vBHWkv4ECreccz7po0IJ9tWcXH3Md3pY8fNkvOOy66xK4-B4XKo5LzYGYXVL29Rx8Bx2H2epLw9vu4h_xtYoL6AK8fWv52faGsyYb5gTIybatYm1SxvPWCghaXl1Dpumr9_f2adXgOHjd-dcz2e1Rd4wxO9CuPMoI7KJQMjsoYHsC1rTx8MW09gHwSIYhCUaJg-PDiAz5W1tTjtfBuEiVWkBcaM-PQhnG5se7XQ0s",
                  date: "Leo, Okt 24",
                  time: "14:00 Jioni",
                ),
                const SizedBox(height: 20),
                bookingCard(
                  name: "Sarah Mussa",
                  role: "Fundi Umeme",
                  image:
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuA-qP9yQzyJDiZONhRyMNvgLKqL0mAyvCbC4Pt4mAFznEaw0e5les7GHNse6G6y6BrFgrdLE5J9TRW-C7N-q4nHUmXZFWH-nHlZUDxj0Cdr0ealHNVwbW8kF9rsrvdSEU6fUx6-k_ryUarxgSZdkVHn-Y48OgKVeM1LalZSkN9wpT9qO16y7ysW_5DdQir4VzBV43m3mdOAZiPItihB4qfFkePktZEiBgZv0q2jBwnVQj7KW_A94CIxKuF5lO2laTlcGvbdpn7Qn8Y",
                  date: "Oktoba 28",
                  time: "09:00 Alfajiri",
                ),
                const SizedBox(height: 20),
                sectionTitle("ZILIZOPITWA NA WAKATI", ""),
                expiredCard(),
                const SizedBox(height: 20),
                historyCard(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentRoute: '/miadi',
        screenWidth: screenWidth,
      ),
    );
  }

  Widget topBar() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Icon(Icons.menu, color: Colors.blue),
          Text("Miadi Yangu",
              style:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          Icon(Icons.notifications, color: Colors.blue),
        ],
      );

  Widget searchBar() => TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          hintText: "Tafuta miadi yako...",
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      );

  Widget categories() => SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            final isSelected = _selectedCategory == category['name'];
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category['name'];
                });
              },
              child: Container(
                width: 100,
                margin: EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? category['color'].withOpacity(0.2)
                    : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected 
                      ? category['color'].withOpacity(0.5)
                      : Colors.white.withOpacity(0.1),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected 
                          ? category['color'].withOpacity(0.3)
                          : Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        category['icon'],
                        color: isSelected 
                          ? category['color']
                          : Colors.white.withOpacity(0.7),
                        size: 24,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      category['name'],
                      style: TextStyle(
                        color: isSelected 
                          ? category['color']
                          : Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: isSelected 
                          ? FontWeight.bold 
                          : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected 
                          ? category['color'].withOpacity(0.2)
                          : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${category['count']}',
                        style: TextStyle(
                          color: isSelected 
                            ? category['color']
                            : Colors.white.withOpacity(0.7),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

  Widget sectionTitle(String title, String count) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(count, style: const TextStyle(color: Colors.blue)),
        ],
      );

  Widget bookingCard({
    required String name,
    required String role,
    required String image,
    required String date,
    required String time,
  }) =>
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(image), radius: 30),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(role, style: const TextStyle(color: Colors.grey)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date, style: const TextStyle(color: Colors.white)),
                Text(time, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      );

  Widget expiredCard() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          children: [
            Icon(Icons.event_busy, color: Colors.red),
            SizedBox(width: 10),
            Expanded(child: Text("Usafi wa Nyumba - Imeisha")),
          ],
        ),
      );

  Widget historyCard() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text("Fundi AC - Ally (Ilikamilika)"),
      );

  Widget bottomNav() => BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Nyumbani"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Miadi"),
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: "Kazi Live"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Wasifu"),
        ],
      );
}