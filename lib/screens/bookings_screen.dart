import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/liquid_button.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Confirmed', 'Pending', 'Completed', 'Cancelled'];

  // Sample booking data
  final List<Map<String, dynamic>> _bookings = [
    {
      'id': 'BKG_001',
      'service': 'Hair Styling',
      'client': 'Maria Baraza',
      'date': '2024-04-10',
      'time': '10:00 AM',
      'status': 'Confirmed',
      'amount': 'TZS 15,000',
      'location': 'Dar es Salaam',
      'image': 'https://via.placeholder.com/60',
    },
    {
      'id': 'BKG_002',
      'service': 'Home Cleaning',
      'client': 'James Kipchoge',
      'date': '2024-04-08',
      'time': '2:00 PM',
      'status': 'Completed',
      'amount': 'TZS 25,000',
      'location': 'Kinondoni',
      'image': 'https://via.placeholder.com/60',
    },
    {
      'id': 'BKG_003',
      'service': 'Plumbing',
      'client': 'Peter Nyambati',
      'date': '2024-04-15',
      'time': '9:00 AM',
      'status': 'Pending',
      'amount': 'TZS 30,000',
      'location': 'Ubungo',
      'image': 'https://via.placeholder.com/60',
    },
    {
      'id': 'BKG_004',
      'service': 'Electrical Work',
      'client': 'Grace Mwangi',
      'date': '2024-04-12',
      'time': '3:00 PM',
      'status': 'Confirmed',
      'amount': 'TZS 20,000',
      'location': 'Mikocheni',
      'image': 'https://via.placeholder.com/60',
    },
    {
      'id': 'BKG_005',
      'service': 'Gardening',
      'client': 'John Smith',
      'date': '2024-04-05',
      'time': '11:00 AM',
      'status': 'Cancelled',
      'amount': 'TZS 18,000',
      'location': 'Masaki',
      'image': 'https://via.placeholder.com/60',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredBookings {
    if (_selectedFilter == 'All') {
      return _bookings;
    }
    return _bookings.where((booking) => booking['status'] == _selectedFilter).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return KazipoaTheme.successColor;
      case 'Pending':
        return KazipoaTheme.warningColor;
      case 'Completed':
        return KazipoaTheme.infoColor;
      case 'Cancelled':
        return KazipoaTheme.errorColor;
      default:
        return KazipoaTheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF0F172A),
                          const Color(0xFF1E293B),
                        ]
                      : [
                          const Color(0xFFF8FAFC),
                          const Color(0xFFF1F5F9),
                        ],
                ),
              ),
            ),
          ),
          
          // Main Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Top App Bar
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back),
                          style: IconButton.styleFrom(
                            backgroundColor: isDark 
                                ? Colors.white.withOpacity(0.1)
                                : Colors.white.withOpacity(0.7),
                            foregroundColor: isDark 
                                ? Colors.white
                                : KazipoaTheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Miadi Yangu',
                          style: KazipoaTheme.headlineSmall.copyWith(
                            color: isDark ? Colors.white : KazipoaTheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/booking');
                          },
                          icon: const Icon(Icons.add),
                          style: IconButton.styleFrom(
                            backgroundColor: KazipoaTheme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Filter Chips
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      itemBuilder: (context, index) {
                        final filter = _filters[index];
                        final isSelected = filter == _selectedFilter;
                        
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() => _selectedFilter = filter);
                            },
                            backgroundColor: isDark 
                                ? KazipoaTheme.darkSurfaceVariant
                                : KazipoaTheme.surfaceContainerHighest,
                            selectedColor: KazipoaTheme.primaryColor.withValues(alpha: 0.2),
                            labelStyle: KazipoaTheme.labelMedium.copyWith(
                              color: isSelected 
                                  ? KazipoaTheme.primaryColor
                                  : (isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant),
                            ),
                            checkmarkColor: KazipoaTheme.primaryColor,
                            side: BorderSide(
                              color: isSelected 
                                  ? KazipoaTheme.primaryColor
                                  : (isDark ? Colors.white24 : KazipoaTheme.onSurfaceVariant),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Bookings List
                  Expanded(
                    child: _filteredBookings.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 64,
                                  color: isDark ? Colors.white30 : KazipoaTheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Hakuna miada za $_selectedFilter',
                                  style: KazipoaTheme.titleMedium.copyWith(
                                    color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Unda miadi mpya ili kuona hapa',
                                  style: KazipoaTheme.bodyMedium.copyWith(
                                    color: isDark ? Colors.white54 : KazipoaTheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredBookings.length,
                            itemBuilder: (context, index) {
                              final booking = _filteredBookings[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildBookingCard(booking, isDark),
                              );
                            },
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

  Widget _buildBookingCard(Map<String, dynamic> booking, bool isDark) {
    final statusColor = _getStatusColor(booking['status']);
    
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      KazipoaTheme.primaryColor.withOpacity(0.8),
                      KazipoaTheme.secondaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.work_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking['service'],
                      style: KazipoaTheme.titleMedium.copyWith(
                        color: isDark ? Colors.white : KazipoaTheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'ID: ${booking['id']}',
                      style: KazipoaTheme.bodySmall.copyWith(
                        color: isDark ? Colors.white54 : KazipoaTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  booking['status'],
                  style: KazipoaTheme.labelSmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Client Info
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 20,
                color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                booking['client'],
                style: KazipoaTheme.bodyMedium.copyWith(
                  color: isDark ? Colors.white : KazipoaTheme.onSurface,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Date and Time
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 20,
                color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                '${booking['date']} at ${booking['time']}',
                style: KazipoaTheme.bodyMedium.copyWith(
                  color: isDark ? Colors.white : KazipoaTheme.onSurface,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Location
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20,
                color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                booking['location'],
                style: KazipoaTheme.bodyMedium.copyWith(
                  color: isDark ? Colors.white : KazipoaTheme.onSurface,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Amount
          Row(
            children: [
              Icon(
                Icons.attach_money,
                size: 20,
                color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                booking['amount'],
                style: KazipoaTheme.bodyMedium.copyWith(
                  color: KazipoaTheme.successColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: LiquidButton.outlined(
                  text: 'Ona Maelezo',
                  onPressed: () {
                    _showBookingDetails(booking, isDark);
                  },
                  height: 40,
                ),
              ),
              const SizedBox(width: 12),
              if (booking['status'] == 'Pending')
                Expanded(
                  child: LiquidButton.elevated(
                    text: 'Thibitisha',
                    onPressed: () {
                      _confirmBooking(booking['id']);
                    },
                    height: 40,
                  ),
                )
              else if (booking['status'] == 'Confirmed')
                Expanded(
                  child: LiquidButton.outlined(
                    text: 'Anza Kazi',
                    onPressed: () {
                      _startBooking(booking['id']);
                    },
                    height: 40,
                  ),
                )
              else
                Expanded(
                  child: LiquidButton.outlined(
                    text: 'Pitia Upya',
                    onPressed: () {
                      _reviewBooking(booking['id']);
                    },
                    height: 40,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBookingDetails(Map<String, dynamic> booking, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: isDark ? KazipoaTheme.darkSurface : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : KazipoaTheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Maelezo ya Miadi',
                      style: KazipoaTheme.headlineSmall.copyWith(
                        color: isDark ? Colors.white : KazipoaTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    _buildDetailRow('Huduma', booking['service'], isDark),
                    _buildDetailRow('Mteja', booking['client'], isDark),
                    _buildDetailRow('Tarehe', booking['date'], isDark),
                    _buildDetailRow('Muda', booking['time'], isDark),
                    _buildDetailRow('Mahali', booking['location'], isDark),
                    _buildDetailRow('Kiasi', booking['amount'], isDark),
                    _buildDetailRow('Hali', booking['status'], isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: KazipoaTheme.bodyMedium.copyWith(
                color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: KazipoaTheme.bodyMedium.copyWith(
                color: isDark ? Colors.white : KazipoaTheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmBooking(String bookingId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Miadi imethibitishwa!'),
        backgroundColor: KazipoaTheme.successColor,
      ),
    );
  }

  void _startBooking(String bookingId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kazi imesanliwa!'),
        backgroundColor: KazipoaTheme.infoColor,
      ),
    );
  }

  void _reviewBooking(String bookingId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kupitia upya kazi...'),
        backgroundColor: KazipoaTheme.primaryColor,
      ),
    );
  }
}
