import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class BookingSetupEnhanced extends StatefulWidget {
  final String? proId; // null for multi-booking, specific pro ID for individual booking
  final String? proName; // for individual booking
  
  const BookingSetupEnhanced({
    super.key,
    this.proId,
    this.proName,
  });

  @override
  _BookingSetupEnhancedState createState() => _BookingSetupEnhancedState();
}

class _BookingSetupEnhancedState extends State<BookingSetupEnhanced> {
  String service = "Fundi Umeme";
  TextEditingController desc = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController budget = TextEditingController();

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
        backgroundColor: Colors.black.withOpacity(0.6),
        elevation: 0,
        title: Text("Weka Maombi ya Kazi"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            /// SERVICE
            glassCard(
              child: DropdownButtonFormField(
                dropdownColor: Colors.black,
                initialValue: service,
                items: [
                  "Fundi Umeme",
                  "Fundi Bomba",
                  "Usafi wa Nyumba",
                  "Useremala"
                ].map((e) => DropdownMenuItem(
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
                style: TextStyle(color: Colors.white),
                decoration: inputDecoration("Maelezo ya kazi"),
              ),
            ),

            /// LOCATION
            glassCard(
              child: TextField(
                controller: location,
                style: TextStyle(color: Colors.white),
                decoration: inputDecoration("Mahali"),
              ),
            ),

            /// DATE + TIME
            glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Lini?", style: labelStyle()),

                  SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: pickDate,
                          child: Text(selectedDate == null
                              ? "Chagua Tarehe"
                              : selectedDate.toString().split(" ")[0]),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: pickTime,
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
                          Icon(Icons.repeat, color: Color(0xFF00D2FF), size: 20),
                          SizedBox(width: 8),
                          Text("Recurring Booking", style: labelStyle()),
                        ],
                      ),
                      Switch(
                        value: isRecurring,
                        activeThumbColor: Color(0xFF00D2FF),
                        onChanged: (val) {
                          setState(() => isRecurring = val);
                        },
                      ),
                    ],
                  ),

                  if (isRecurring) ...[
                    SizedBox(height: 15),

                    /// TYPE SELECTION WITH CARDS
                    Text("Chagua Aina ya Ratiba", style: labelStyle()),
                    SizedBox(height: 10),
                    
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => recurringType = "Daily"),
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: recurringType == "Daily" 
                                    ? Color(0xFF00D2FF).withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: recurringType == "Daily" 
                                      ? Color(0xFF00D2FF)
                                      : Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.today, 
                                       color: recurringType == "Daily" 
                                           ? Color(0xFF00D2FF) 
                                           : Colors.grey,
                                       size: 24),
                                  SizedBox(height: 5),
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
                        SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => recurringType = "Weekly"),
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: recurringType == "Weekly" 
                                    ? Color(0xFF00D2FF).withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: recurringType == "Weekly" 
                                      ? Color(0xFF00D2FF)
                                      : Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.calendar_view_week, 
                                       color: recurringType == "Weekly" 
                                           ? Color(0xFF00D2FF) 
                                           : Colors.grey,
                                       size: 24),
                                  SizedBox(height: 5),
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
                      SizedBox(height: 15),
                      
                      /// DAY SELECTION WITH GRID
                      Text("Chagua Siku", style: labelStyle()),
                      SizedBox(height: 10),
                      
                      SizedBox(
                        height: 120,
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                      ? Color(0xFF00D2FF).withOpacity(0.3)
                                      : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected 
                                        ? Color(0xFF00D2FF)
                                        : Colors.grey.withOpacity(0.3),
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

                    SizedBox(height: 15),

                    /// INFO CARD
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF00D2FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFF00D2FF).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Color(0xFF00D2FF), size: 16),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              recurringType == "Daily"
                                  ? "Maombi yako yatajirudia kila siku saa ${selectedTime?.format(context) ?? '??'}"
                                  : "Maombi yako yatajirudia kila $selectedDay saa ${selectedTime?.format(context) ?? '??'}",
                              style: TextStyle(
                                color: Color(0xFF00D2FF),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10),

                    /// 24-HOUR TIMER INFO
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer, color: Colors.orange, size: 16),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Baada ya kukubaliwa, utakuwa na masaa 24 kukamilisha maombi",
                              style: TextStyle(
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
                style: TextStyle(color: Colors.white),
                decoration: inputDecoration("Bajeti (TZS)"),
              ),
            ),

            SizedBox(height: 20),

            /// SUBMIT
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00D2FF),
                minimumSize: Size(double.infinity, 55),
              ),
              onPressed: submit,
              child: Text("Tuma Maombi",
                  style: TextStyle(color: Colors.black)),
            )
          ],
        ),
      ),
    );
  }

  /// ================= HELPERS =================

  Widget glassCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white10),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF00D2FF)),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  TextStyle labelStyle() {
    return TextStyle(
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

  void submit() {
    HapticFeedback.heavyImpact();
    
    // Validate that date and time are selected
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
        SnackBar(
          content: Text('Miadi inapaswa kuwa angalau masaa 24 mbele'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    print("Service: $service");
    print("Recurring: $isRecurring");
    print("Booking expires in: ${24 - hoursUntilBooking} hours");

    if (isRecurring) {
      print("Type: $recurringType");
      print("Day: $selectedDay");
    }

    print("Time: $selectedTime");
    
    // Determine booking type
    final bookingType = widget.proId == null ? 'recurring' : 'individual';
    
    // Create booking data
    final bookingData = {
      'serviceType': service,
      'description': desc.text,
      'location': location.text,
      'price': double.tryParse(budget.text) ?? 0.0,
      'bookingDate': selectedDate.toString().split(' ')[0],
      'bookingTime': selectedTime!.format(context),
      'bookingType': bookingType,
      'isRecurring': isRecurring,
      'recurringType': recurringType,
      'recurringDay': selectedDay,
      'professionalId': widget.proId,
      'professionalName': widget.proName,
      'notes': isRecurring 
          ? 'Recurring $recurringType${recurringType == 'Weekly' ? ' on $selectedDay' : ''}'
          : desc.text,
    };
    
    // Check if this is multi-booking (no specific pro) or individual booking
    if (widget.proId == null) {
      // Multi-booking: send to 10 pros
      _sendMultiBookingRequest(service, bookingDateTime, bookingData);
    } else {
      // Individual booking: send to specific pro
      _sendIndividualBookingRequest(widget.proId!, widget.proName!, service, bookingDateTime, bookingData);
    }
    
    // Navigate to kazi live client hub after submitting booking request
    // This is where users can track their booking requests and see which pro accepts first
    context.go('/kazi_live_client_hub');
  }
  
  void _sendMultiBookingRequest(String serviceType, DateTime bookingTime, Map<String, dynamic> bookingData) {
    // Simulate sending booking requests to 10 pros based on service criteria
    // In a real app, this would make API calls to find matching pros
    
    print('=== MULTI-BOOKING REQUEST SENT ===');
    print('Service: $serviceType');
    print('Booking Time: $bookingTime');
    print('Sending requests to 10 top priority pros...');
    
    // Simulate finding 10 pros who match the service criteria
    final matchingPros = [
      'Pro 1 - $serviceType Expert',
      'Pro 2 - $serviceType Specialist', 
      'Pro 3 - $serviceType Professional',
      'Pro 4 - $serviceType Technician',
      'Pro 5 - $serviceType Provider',
      'Pro 6 - $serviceType Contractor',
      'Pro 7 - $serviceType Service Provider',
      'Pro 8 - $serviceType Expert',
      'Pro 9 - $serviceType Specialist',
      'Pro 10 - $serviceType Professional',
    ];
    
    for (int i = 0; i < matchingPros.length; i++) {
      print('Request ${i + 1}/10 sent to: ${matchingPros[i]}');
      // In real implementation: API call to send booking request
    }
    
    print('Note: First pro to accept gets the job');
    print('Service costs are ignored in matching criteria');
  }
  
  void _sendIndividualBookingRequest(String proId, String proName, String serviceType, DateTime bookingTime, Map<String, dynamic> bookingData) {
    // Simulate sending booking request to specific pro
    print('=== INDIVIDUAL BOOKING REQUEST SENT ===');
    print('Pro ID: $proId');
    print('Pro Name: $proName');
    print('Service: $serviceType');
    print('Booking Time: $bookingTime');
    print('Request sent directly to: $proName');
    
    // In real implementation: API call to send booking request to specific pro
    print('Individual booking request sent to $proName');
  }
  
  void rescheduleBooking() {
    HapticFeedback.lightImpact();
    // Open date/time picker for rescheduling
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