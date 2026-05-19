import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';

class MyBookingsEnhanced extends StatefulWidget {
  const MyBookingsEnhanced({super.key});

  @override
  State<MyBookingsEnhanced> createState() => _MyBookingsEnhancedState();
}

class _MyBookingsEnhancedState extends State<MyBookingsEnhanced> {
  String _selectedCategory = 'Zilizokubaliwa';
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = true;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Zilizokubaliwa', 'icon': Icons.check_circle, 'color': Colors.green, 'count': 0},
    {'name': 'Zinasubiri', 'icon': Icons.pending, 'color': Colors.orange, 'count': 0},
    {'name': 'Zilizokataliwa', 'icon': Icons.cancel, 'color': Colors.red, 'count': 0},
    {'name': 'Zilizopita', 'icon': Icons.history, 'color': Colors.grey, 'count': 0},
  ];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final client = Supabase.instance.client;
      final userId = client.auth.currentUser?.id;
      if (userId == null) return;

      // Query bookings with professional and profile nested details
      final response = await client
          .from('bookings')
          .select('*, pros:pro_id(*, profiles:id(*))')
          .eq('client_id', userId)
          .order('booking_date', ascending: false);

      final List<dynamic> rawList = response as List<dynamic>;
      _bookings = rawList.map((e) => Map<String, dynamic>.from(e)).toList();

      // Recalculate category counts dynamically
      _updateCounts();
    } catch (e) {
      debugPrint('Failed to load bookings: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updateCounts() {
    int accepted = 0;
    int pending = 0;
    int rejected = 0;
    int past = 0;

    for (final b in _bookings) {
      final status = b['status']?.toString().toLowerCase() ?? 'pending';
      if (status == 'accepted') {
        accepted++;
      } else if (status == 'pending') {
        pending++;
      } else if (status == 'rejected' || status == 'cancelled') {
        rejected++;
      } else if (status == 'completed') {
        past++;
      }
    }

    setState(() {
      _categories[0]['count'] = accepted;
      _categories[1]['count'] = pending;
      _categories[2]['count'] = rejected;
      _categories[3]['count'] = past;
    });
  }

  List<Map<String, dynamic>> get _filteredBookings {
    final statusFilter = _selectedCategory.toLowerCase();
    
    return _bookings.where((b) {
      final status = b['status']?.toString().toLowerCase() ?? 'pending';
      
      // Filter by category selection
      bool matchesCategory = false;
      if (_selectedCategory == 'Zilizokubaliwa') {
        matchesCategory = status == 'accepted';
      } else if (_selectedCategory == 'Zinasubiri') {
        matchesCategory = status == 'pending';
      } else if (_selectedCategory == 'Zilizokataliwa') {
        matchesCategory = status == 'rejected' || status == 'cancelled';
      } else if (_selectedCategory == 'Zilizopita') {
        matchesCategory = status == 'completed';
      }

      // Filter by search query (description or service type or pro name)
      if (!matchesCategory) return false;

      if (_searchQuery.isEmpty) return true;

      final desc = b['description']?.toString().toLowerCase() ?? '';
      final service = b['service_type']?.toString().toLowerCase() ?? '';
      
      final proMap = b['pros'] as Map<dynamic, dynamic>?;
      final profileMap = proMap != null ? proMap['profiles'] as Map<dynamic, dynamic>? : null;
      final name = profileMap != null ? profileMap['name']?.toString().toLowerCase() ?? '' : '';

      return desc.contains(_searchQuery.toLowerCase()) ||
          service.contains(_searchQuery.toLowerCase()) ||
          name.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final filtered = _filteredBookings;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadBookings,
          color: Colors.blueAccent,
          backgroundColor: Colors.black87,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                  const SizedBox(height: 24),
                  sectionTitle(_selectedCategory.toUpperCase(), "${filtered.length} Miadi"),
                  const SizedBox(height: 16),
                  
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(color: Colors.blueAccent),
                      ),
                    )
                  else if (filtered.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        child: Column(
                          children: [
                            Icon(Icons.event_note, size: 64, color: Colors.white.withOpacity(0.3)),
                            const SizedBox(height: 16),
                            Text(
                              "Hakuna miadi katika kundi hili",
                              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final b = filtered[index];
                        final proMap = b['pros'] as Map<dynamic, dynamic>?;
                        final profileMap = proMap != null ? proMap['profiles'] as Map<dynamic, dynamic>? : null;
                        final name = profileMap != null ? profileMap['name']?.toString() ?? 'Mtaalamu' : 'Mtaalamu';
                        final role = proMap != null ? proMap['category']?.toString() ?? b['service_type'] : b['service_type'];
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: bookingCard(
                            name: name,
                            role: role,
                            desc: b['description'] ?? '',
                            budget: b['budget']?.toString() ?? '0',
                            image: "https://lh3.googleusercontent.com/aida-public/AB6AXuB8D6FHRQoJ6z0gFQ7mxIM5nYlb-DfuxXw391vBHWkv4ECreccz7po0IJ9tWcXH3Md3pY8fNkvOOy66xK4-B4XKo5LzYGYXVL29Rx8Bx2H2epLw9vu4h_xtYoL6AK8fWv52faGsyYb5gTIybatYm1SxvPWCghaXl1Dpumr9_f2adXgOHjd-dcz2e1Rd4wxO9CuPMoI7KJQMjsoYHsC1rTx8MW09gHwSIYhCUaJg-PDiAz5W1tTjtfBuEiVWkBcaM-PQhnG5se7XQ0s",
                            date: b['booking_date'] ?? '',
                            time: b['booking_time'] ?? '',
                          ),
                        );
                      },
                    ),
                ],
              ),
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
          Icon(Icons.menu, color: Colors.blueAccent),
          Text(
            "Miadi Yangu",
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Icon(Icons.notifications, color: Colors.blueAccent),
        ],
      );

  Widget searchBar() => TextField(
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          hintText: "Tafuta miadi yako...",
          hintStyle: const TextStyle(color: Colors.grey),
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
                HapticFeedback.lightImpact();
                setState(() {
                  _selectedCategory = category['name'];
                });
              },
              child: Container(
                width: 100,
                margin: const EdgeInsets.only(right: 12),
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
                      padding: const EdgeInsets.all(12),
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
                    const SizedBox(height: 8),
                    Text(
                      category['name'],
                      style: TextStyle(
                        color: isSelected 
                          ? category['color']
                          : Colors.white.withOpacity(0.9),
                        fontSize: 10,
                        fontWeight: isSelected 
                          ? FontWeight.bold 
                          : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 1.2)),
          Text(count, style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
        ],
      );

  Widget bookingCard({
    required String name,
    required String role,
    required String desc,
    required String budget,
    required String image,
    required String date,
    required String time,
  }) =>
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(image), radius: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                      const SizedBox(height: 2),
                      Text(role, style: TextStyle(color: Colors.blueAccent.withOpacity(0.8), fontSize: 13)),
                    ],
                  ),
                )
              ],
            ),
            if (desc.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                desc,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.grey, size: 14),
                    const SizedBox(width: 6),
                    Text(date, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.grey, size: 14),
                    const SizedBox(width: 6),
                    Text(time, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.white10),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Bajeti:", style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  "TZS ${double.tryParse(budget)?.toStringAsFixed(0) ?? budget}",
                  style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      );
}