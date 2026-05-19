import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class BookingSetupEnhanced extends ConsumerStatefulWidget {
  final String? proId; // null for multi-booking, specific pro ID for individual booking
  final String? proName; // for individual booking
  
  const BookingSetupEnhanced({
    super.key,
    this.proId,
    this.proName,
  });

  @override
  ConsumerState<BookingSetupEnhanced> createState() => _BookingSetupEnhancedState();
}

class _BookingSetupEnhancedState extends ConsumerState<BookingSetupEnhanced> {
  String service = "Fundi Umeme";
  TextEditingController desc = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController budget = TextEditingController();
  bool _isLoading = false;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool isRecurring = false;
  String recurringType = "Weekly"; // Daily / Weekly
  String selectedDay = "Sunday";

  final days = [
    "Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.6),
        elevation: 0,
        title: const Text("Weka Maombi ya Kazi"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00D2FF),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// SERVICE
                  glassCard(
                    child: DropdownButtonFormField<String>(
                      dropdownColor: Colors.black,
                      initialValue: service,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      items: [
                        "Fundi Umeme",
                        "Fundi Bomba",
                        "Usafi wa Nyumba",
                        "Useremala"
                      ].map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          )).toList(),
                      onChanged: (val) => setState(() => service = val!),
                      decoration: inputDecoration("Chagua Huduma"),
                    ),
                  ),

                  /// DESCRIPTION
                  glassCard(
                    child: TextField(
                      controller: desc,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputDecoration("Maelezo ya kazi"),
                    ),
                  ),

                  /// LOCATION
                  glassCard(
                    child: TextField(
                      controller: location,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputDecoration("Mahali"),
                    ),
                  ),

                  /// DATE + TIME
                  glassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Lini?", style: labelStyle()),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: pickDate,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E293B),
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(selectedDate == null
                                    ? "Chagua Tarehe"
                                    : selectedDate.toString().split(" ")[0]),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: pickTime,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E293B),
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(selectedTime == null
                                    ? "Chagua Saa"
                                    : selectedTime!.format(context)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// 🔥 ENHANCED RECURRING SECTION
                  glassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.repeat, color: Color(0xFF00D2FF), size: 20),
                                const SizedBox(width: 8),
                                Text("Recurring Booking", style: labelStyle()),
                              ],
                            ),
                            Switch(
                              value: isRecurring,
                              activeThumbColor: const Color(0xFF00D2FF),
                              onChanged: (val) {
                                setState(() => isRecurring = val);
                              },
                            ),
                          ],
                        ),

                        if (isRecurring) ...[
                          const SizedBox(height: 15),

                          /// TYPE SELECTION WITH CARDS
                          Text("Chagua Aina ya Ratiba", style: labelStyle()),
                          const SizedBox(height: 10),
                          
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => recurringType = "Daily"),
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: recurringType == "Daily" 
                                          ? const Color(0xFF00D2FF).withValues(alpha: 0.2)
                                          : Colors.grey.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: recurringType == "Daily" 
                                            ? const Color(0xFF00D2FF)
                                            : Colors.grey.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(Icons.today, 
                                             color: recurringType == "Daily" 
                                                 ? const Color(0xFF00D2FF) 
                                                 : Colors.grey,
                                             size: 24),
                                        const SizedBox(height: 5),
                                        Text("Kila Siku",
                                             style: TextStyle(
                                               color: recurringType == "Daily" 
                                                   ? Colors.white 
                                                   : Colors.grey,
                                               fontWeight: recurringType == "Daily" 
                                                   ? FontWeight.bold 
                                                   : FontWeight.normal,
                                             )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => recurringType = "Weekly"),
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: recurringType == "Weekly" 
                                          ? const Color(0xFF00D2FF).withValues(alpha: 0.2)
                                          : Colors.grey.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: recurringType == "Weekly" 
                                            ? const Color(0xFF00D2FF)
                                            : Colors.grey.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(Icons.calendar_view_week, 
                                             color: recurringType == "Weekly" 
                                                 ? const Color(0xFF00D2FF) 
                                                 : Colors.grey,
                                             size: 24),
                                        const SizedBox(height: 5),
                                        Text("Kila Wiki",
                                             style: TextStyle(
                                               color: recurringType == "Weekly" 
                                                   ? Colors.white 
                                                   : Colors.grey,
                                               fontWeight: recurringType == "Weekly" 
                                                   ? FontWeight.bold 
                                                   : FontWeight.normal,
                                             )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          if (recurringType == "Weekly") ...[
                            const SizedBox(height: 15),
                            
                            /// DAY SELECTION WITH GRID
                            Text("Chagua Siku", style: labelStyle()),
                            const SizedBox(height: 10),
                            
                            SizedBox(
                              height: 120,
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 1.2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: days.length,
                                itemBuilder: (context, index) {
                                  final day = days[index];
                                  final isSelected = selectedDay == day;
                                  
                                  return GestureDetector(
                                    onTap: () => setState(() => selectedDay = day),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isSelected 
                                            ? const Color(0xFF00D2FF).withValues(alpha: 0.3)
                                            : Colors.grey.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isSelected 
                                              ? const Color(0xFF00D2FF)
                                              : Colors.grey.withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          day.substring(0, 3), // Show first 3 letters
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : Colors.grey,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],

                          const SizedBox(height: 15),

                          /// INFO CARD
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00D2FF).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF00D2FF).withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, color: Color(0xFF00D2FF), size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    recurringType == "Daily"
                                        ? "Maombi yako yatajirudia kila siku saa ${selectedTime?.format(context) ?? '??'}"
                                        : "Maombi yako yatajirudia kila $selectedDay saa ${selectedTime?.format(context) ?? '??'}",
                                    style: const TextStyle(
                                      color: Color(0xFF00D2FF),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// 24-HOUR TIMER INFO
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.timer, color: Colors.orange, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Baada ya kukubaliwa, utakuwa na masaa 24 kukamilisha maombi",
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),

                  /// BUDGET
                  glassCard(
                    child: TextField(
                      controller: budget,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputDecoration("Bajeti (TZS)"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// SUBMIT
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D2FF),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: submit,
                    child: const Text("Tuma Maombi",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                  )
                ],
              ),
            ),
    );
  }

  /// ================= HELPERS =================

  Widget glassCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white10),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF00D2FF)),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  TextStyle labelStyle() {
    return const TextStyle(
        color: Color(0xFF00D2FF),
        fontWeight: FontWeight.bold,
        fontSize: 12);
  }

  /// ================= ACTIONS =================

  void pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void pickTime() async {
    TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  void submit() async {
    HapticFeedback.heavyImpact();
    
    // Validate that date and time are selected
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tafadhali chagua tarehe na saa'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Check if booking is within 24 hours
    final now = DateTime.now();
    final bookingDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
    
    final hoursUntilBooking = bookingDateTime.difference(now).inHours;
    
    if (hoursUntilBooking < 24) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Miadi inapaswa kuwa angalau masaa 24 mbele'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final client = Supabase.instance.client;
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User is not authenticated');
      }

      // 1. Create a row in the `bookings` table
      final bookingResponse = await client.from('bookings').insert({
        'client_id': userId,
        'pro_id': widget.proId,
        'service_type': service,
        'description': desc.text.trim(),
        'location': location.text.trim(),
        'budget': double.tryParse(budget.text.trim()) ?? 0.0,
        'booking_date': selectedDate.toString().split(' ')[0],
        'booking_time': selectedTime!.format(context),
        'status': 'pending',
      }).select().single();

      final bookingId = bookingResponse['id'] as String;

      // 2. If isRecurring is true, write to recurring_bookings
      if (isRecurring) {
        await client.from('recurring_bookings').insert({
          'booking_id': bookingId,
          'frequency': recurringType,
          'day_of_week': recurringType == 'Weekly' ? selectedDay : null,
        });
      }

      // 3. Match pros: Route booking request to pro(s)
      if (widget.proId != null) {
        // Individual booking: Send directly to specific pro
        await client.from('booking_requests').insert({
          'booking_id': bookingId,
          'pro_id': widget.proId,
          'status': 'pending',
        });
      } else {
        // Multi-booking matching criteria: Get top 10 matched pros and send booking requests
        final pros = await client.from('pros').select('id').eq('category', service).limit(10);
        if (pros.isNotEmpty) {
          final List<Map<String, dynamic>> requests = [];
          for (final pro in pros) {
            requests.add({
              'booking_id': bookingId,
              'pro_id': pro['id'] as String,
              'status': 'pending',
            });
          }
          await client.from('booking_requests').insert(requests);
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Maombi yako yametumwa kikamilifu!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to kazi live client hub after submitting booking request
        context.go('/kazi_live_client_hub');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kosa: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
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
  
  void rescheduleBooking() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Reschedule Booking',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Select new date and time for your booking. The new request will be sent to the pro.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                pickDate(); // Open date picker for rescheduling
              },
              child: const Text('Reschedule'),
            ),
          ],
        );
      },
    );
  }
}