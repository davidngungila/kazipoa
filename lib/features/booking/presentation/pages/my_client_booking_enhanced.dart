import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OfisiYanguScreen extends StatefulWidget {
  const OfisiYanguScreen({super.key});

  @override
  State<OfisiYanguScreen> createState() => _OfisiYanguScreenState();
}

class _OfisiYanguScreenState extends State<OfisiYanguScreen> {
  String _selectedTab = 'Maombi Mapya';
  List<Map<String, dynamic>> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final client = Supabase.instance.client;
      final userId = client.auth.currentUser?.id;
      if (userId == null) return;

      // Query booking requests assigned to this professional, along with nested bookings and client profile details
      final response = await client
          .from('booking_requests')
          .select('*, bookings:booking_id(*, profiles:client_id(*))')
          .eq('pro_id', userId)
          .order('created_at', ascending: false);

      final List<dynamic> rawList = response as List<dynamic>;
      _requests = rawList.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      debugPrint('Failed to load requests: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _acceptRequest(String requestId, String bookingId) async {
    HapticFeedback.heavyImpact();
    setState(() {
      _isLoading = true;
    });
    try {
      final client = Supabase.instance.client;
      final userId = client.auth.currentUser?.id;
      if (userId == null) return;

      // 1. Update this booking request to accepted
      await client
          .from('booking_requests')
          .update({'status': 'accepted'})
          .eq('id', requestId);

      // 2. Update the booking status to accepted and set pro_id
      await client
          .from('bookings')
          .update({
            'status': 'accepted',
            'pro_id': userId,
          })
          .eq('id', bookingId);

      // 3. Reject other requests for this booking
      await client
          .from('booking_requests')
          .update({'status': 'rejected'})
          .eq('booking_id', bookingId)
          .neq('id', requestId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Umekubali ombi hili kikamilifu!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      await _loadRequests();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kosa: ${e.toString()}'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _rejectRequest(String requestId) async {
    HapticFeedback.mediumImpact();
    setState(() {
      _isLoading = true;
    });
    try {
      final client = Supabase.instance.client;

      // Update booking request to rejected
      await client
          .from('booking_requests')
          .update({'status': 'rejected'})
          .eq('id', requestId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Umekataa ombi hili.'),
            backgroundColor: Colors.orange,
          ),
        );
      }

      await _loadRequests();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kosa: ${e.toString()}'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> get _filteredRequests {
    return _requests.where((req) {
      final status = req['status']?.toString().toLowerCase() ?? 'pending';
      if (_selectedTab == 'Maombi Mapya') {
        return status == 'pending';
      } else if (_selectedTab == 'Zilizokubaliwa') {
        return status == 'accepted';
      } else {
        return status == 'rejected' || status == 'cancelled';
      }
    }).toList();
  }

  int _getCount(String tabName) {
    return _requests.where((req) {
      final status = req['status']?.toString().toLowerCase() ?? 'pending';
      if (tabName == 'Maombi Mapya') {
        return status == 'pending';
      } else if (tabName == 'Zilizokubaliwa') {
        return status == 'accepted';
      } else {
        return status == 'rejected' || status == 'cancelled';
      }
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredRequests;

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
            child: RefreshIndicator(
              onRefresh: _loadRequests,
              color: Colors.lightBlueAccent,
              backgroundColor: Colors.black87,
              child: Column(
                children: [
                  _topAppBar(context),
                  const SizedBox(height: 16),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _titleSection(),
                          const SizedBox(height: 24),
                          _tabBar(),
                          const SizedBox(height: 24),
                          _sectionHeader(filtered.length),
                          const SizedBox(height: 16),

                          if (_isLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: CircularProgressIndicator(color: Colors.lightBlueAccent),
                              ),
                            )
                          else if (filtered.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 60),
                                child: Column(
                                  children: [
                                    Icon(Icons.assignment_turned_in, size: 64, color: Colors.white.withOpacity(0.3)),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Hakuna maombi katika kundi hili",
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
                                final req = filtered[index];
                                final bookingMap = req['bookings'] as Map<dynamic, dynamic>?;
                                final clientMap = bookingMap != null ? bookingMap['profiles'] as Map<dynamic, dynamic>? : null;
                                final clientName = clientMap != null ? clientMap['name']?.toString() ?? 'Mteja' : 'Mteja';
                                final service = bookingMap != null ? bookingMap['service_type']?.toString() ?? '' : '';
                                final price = bookingMap != null ? 'TZS ${double.tryParse(bookingMap['budget']?.toString() ?? '0')?.toStringAsFixed(0) ?? bookingMap['budget']}' : 'TZS 0';
                                final date = bookingMap != null ? bookingMap['booking_date']?.toString() ?? '' : '';
                                final time = bookingMap != null ? bookingMap['booking_time']?.toString() ?? '' : '';
                                final idStr = '#SP-${req['id'].toString().substring(0, 4).toUpperCase()}';
                                final desc = bookingMap != null ? bookingMap['description']?.toString() ?? '' : '';

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _bookingCard(
                                    name: clientName,
                                    service: service,
                                    desc: desc,
                                    price: price,
                                    date: date,
                                    time: time,
                                    id: idStr,
                                    requestId: req['id'] as String,
                                    bookingId: req['booking_id'] as String,
                                    status: req['status']?.toString().toLowerCase() ?? 'pending',
                                  ),
                                );
                              },
                            ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
              context.go('/wasifu/pro_dashboard');
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.lightBlueAccent,
              size: 20,
            ),
          ),
          const Text(
            "Kazipoa Pro",
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
          "WASIFU WA MTAALAMU",
          style: TextStyle(
            color: Colors.lightBlueAccent,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 6),
        Text(
          "Ofisi Yangu",
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Simamia maombi na ratiba zako za kazi leo.",
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
          _tab("Maombi Mapya"),
          _tab("Zilizokubaliwa"),
          _tab("Zilizokataliwa"),
        ],
      ),
    );
  }

  Widget _tab(String title) {
    final active = _selectedTab == title;
    final count = _getCount(title);
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() {
            _selectedTab = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? Colors.lightBlueAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: active ? Colors.black : Colors.white70,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: active ? Colors.black.withOpacity(0.1) : Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: active ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ---------- SECTION HEADER ----------
  Widget _sectionHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$_selectedTab ($count)",
          style: const TextStyle(
            color: Colors.lightBlueAccent,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "LATEST",
          style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1),
        ),
      ],
    );
  }

  // ---------- BOOKING CARD ----------
  Widget _bookingCard({
    required String name,
    required String service,
    required String desc,
    required String price,
    required String date,
    required String time,
    required String id,
    required String requestId,
    required String bookingId,
    required String status,
  }) {
    final isPending = status == 'pending';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
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
                  Text(service,
                      style: const TextStyle(color: Colors.lightBlueAccent)),
                  const SizedBox(height: 2),
                  Text(price,
                      style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                ],
              ),
              Text(id,
                  style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
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

          if (isPending) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _acceptRequest(requestId, bookingId),
                    child: const Text("Kubali", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _rejectRequest(requestId),
                    child: const Text("Kataa", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: status == 'accepted' 
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  status == 'accepted' ? 'Ulikubali ombi hili' : 'Ulilikataa au lilighairiwa',
                  style: TextStyle(
                    color: status == 'accepted' ? Colors.greenAccent : Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ],
      ),
    );
  }
}