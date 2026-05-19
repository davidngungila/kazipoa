import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../providers/auth_provider.dart';
import '../../../../core/services/auth_manager.dart';

class ProfileSetupEnhanced extends ConsumerStatefulWidget {
  const ProfileSetupEnhanced({super.key});

  @override
  ConsumerState<ProfileSetupEnhanced> createState() => _ProfileSetupEnhancedState();
}

class _ProfileSetupEnhancedState extends ConsumerState<ProfileSetupEnhanced>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _serviceCategoryController = TextEditingController();
  final _rateController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  
  late AnimationController _blobController;
  late Animation<Offset> _blobAnimation;
  
  String? _selectedService;
  final List<String> _serviceCategories = [
    'Plumbing & Pipe Repair',
    'Electrical Engineering',
    'Professional Cleaning',
    'Landscaping & Gardening',
  ];

  @override
  void initState() {
    super.initState();
    
    _blobController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    );

    _blobAnimation = Tween<Offset>(
      begin: const Offset(-0.1, -0.1),
      end: const Offset(0.2, 0.2),
    ).animate(CurvedAnimation(
      parent: _blobController,
      curve: Curves.easeInOut,
    ));

    _blobController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _blobController.dispose();
    _serviceCategoryController.dispose();
    _rateController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSubscriptionSetup() {
    HapticFeedback.lightImpact();
    // Handle subscription logic - 5,000 TSH/month with 2-month trial
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usajili wako umeanzishwa! Mwezi 2 ya majaribio bure.'),
        backgroundColor: Color(0xFF00F0FF),
      ),
    );
    
    // Navigate to dashboard after subscription setup
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/wasifu/pro_dashboard');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive calculations
    final padding = screenWidth * 0.04;
    final titleFontSize = (screenWidth * 0.06).clamp(20.0, 24.0);
    final cardWidth = (screenWidth * 0.95).clamp(320.0, 448.0);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Animated Background with Blobs
          AnimatedBuilder(
            animation: _blobAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  // First Blob
                  Positioned(
                    left: -100,
                    top: -100,
                    child: Transform.translate(
                      offset: Offset(
                        _blobAnimation.value.dx * 200,
                        _blobAnimation.value.dy * 200,
                      ),
                      child: Container(
                        width: 500,
                        height: 500,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF00F0FF).withOpacity(0.15),
                              const Color(0xFF00F0FF).withOpacity(0.05),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  
                  // Second Blob
                  Positioned(
                    right: -100,
                    top: -100,
                    child: Transform.translate(
                      offset: Offset(
                        -_blobAnimation.value.dx * 200,
                        -_blobAnimation.value.dy * 200,
                      ),
                      child: Container(
                        width: 400,
                        height: 400,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00F0FF).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(screenWidth),
                
                // Bottom Navigation
                CustomBottomNavigation(
                  currentRoute: '/profile_setup',
                  screenWidth: screenWidth,
                ),
                
                // Stepper Indicator
                _buildStepperIndicator(),
                
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      children: [
                        // Glass Form Container
                        _buildFormContainer(cardWidth, titleFontSize),
                        
                        SizedBox(height: screenHeight * 0.25), // Bottom nav space
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF00F0FF),
                size: 24,
              ),
            ),
          ),
          
          // Title
          const Expanded(
            child: Text(
              'Usajili wa Akaunti ya Pro',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
          
          const SizedBox(width: 40), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildStepperIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          // Progress Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF00F0FF),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00F0FF).withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 40,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF00F0FF),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00F0FF).withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 40,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF00F0FF),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00F0FF).withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 4),
          
          // Step Text
          const Text(
            'HATUA YA 3 KATI YA 3',
            style: TextStyle(
              color: Color(0xFF00F0FF),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContainer(double cardWidth, double titleFontSize) {
    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F0FF).withOpacity(0.05),
            blurRadius: 40,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderSection(titleFontSize),
            
            const SizedBox(height: 24),
            
            // Service Category
            _buildServiceCategoryField(),
            
            const SizedBox(height: 24),
            
            // Base Hourly Rate
            _buildRateField(),
            
            const SizedBox(height: 24),
            
            // Location
            _buildLocationField(),
            
            const SizedBox(height: 24),
            
            // Work Portfolio
            _buildWorkPortfolio(),
            
            const SizedBox(height: 40),
            
            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(double titleFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Maelezo ya Kitaalamu',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Kamilisha wasifu wako ili kuanza kupokea maombi ya kazi kutoka kwa watumiaji wa Kazipoa nchini Tanzania.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF94A3B8),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'KATEGORIA YA HUDUMA',
          style: TextStyle(
            color: Color(0xFFCBD5E1),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedService,
            decoration: InputDecoration(
              hintText: 'Chagua utaalamu wako',
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
              ),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF00F0FF),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            dropdownColor: Colors.black,
            style: const TextStyle(
              color: Colors.white,
            ),
            items: _serviceCategories.map((String service) {
              return DropdownMenuItem<String>(
                value: service,
                child: Text(service),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedService = newValue;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'GHARAMA za huduma (TZS)',
          style: TextStyle(
            color: Color(0xFFCBD5E1),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: TextFormField(
            controller: _rateController,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: '0.00',
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
              ),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF00F0FF),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(56, 16, 16, 16),
              prefixIcon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  'TZS',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MAHALI PA KAZI',
          style: TextStyle(
            color: Color(0xFFCBD5E1),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: TextFormField(
            controller: _locationController,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'Ingiza jiji au eneo lako kuu',
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
              ),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF00F0FF),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(48, 16, 16, 16),
              prefixIcon: const Icon(
                Icons.location_on,
                color: Color(0xFF00F0FF),
                size: 20,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Phone Number Field
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'Namba ya simu',
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
              ),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF00F0FF),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(48, 16, 16, 16),
              prefixIcon: const Icon(
                Icons.phone,
                color: Color(0xFF00F0FF),
                size: 20,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Subscription Information
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Maelezo ya Usajili (Subscription)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF00F0FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Bei ya Mwezi: TSH 5,000/kwa mwezi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Jaribio la majaribio: Miezi 2 ya majaribio',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Mwezi wa tatu utarekodiwa kama kawaida',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Handle subscription setup
                  _handleSubscriptionSetup();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00F0FF),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Anza Usajili',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Map Preview
        Container(
          height: 128,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Stack(
            children: [
              // Map Placeholder
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.map,
                  color: Color(0xFF94A3B8),
                  size: 40,
                ),
              ),
              
              // Location Marker
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00F0FF).withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF00F0FF),
                      width: 2,
                    ),
                  ),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00F0FF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkPortfolio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'KAZI ULIZOFANYA',
          style: TextStyle(
            color: Color(0xFFCBD5E1),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        
        Text(
          'Pakia picha za kazi zako za awali (Zisizozidi 5)',
          style: TextStyle(
            color: const Color(0xFF94A3B8).withOpacity(0.7),
            fontSize: 10,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Photo Grid
        Row(
          children: [
            // Upload Button
            Expanded(
              child: GestureDetector(
                onTap: _uploadPhoto,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_a_photo,
                          color: Color(0xFF00F0FF),
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'WEKA PICHA',
                          style: TextStyle(
                            color: const Color(0xFF94A3B8),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Placeholder Slots
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: const Icon(
                    Icons.image,
                    color: Color(0xFF64748B),
                    size: 24,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: const Icon(
                    Icons.image,
                    color: Color(0xFF64748B),
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Continue Button
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF00F0FF),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00F0FF).withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Endelea kwenye Vyeti',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        size: 20,
                      ),
                    ],
                  ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Save as Draft Button
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: ElevatedButton(
            onPressed: _saveAsDraft,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: const Color(0xFF94A3B8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Hifadhi kama Rasimu',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _uploadPhoto() {
    HapticFeedback.lightImpact();
    // TODO: Implement photo upload
  }

  void _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.heavyImpact();
      
      final client = Supabase.instance.client;
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tafadhali ingia kwenye akaunti yako kwanza.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
      
      setState(() {
        _isLoading = true;
      });
      
      try {
        final rate = double.tryParse(_rateController.text.trim()) ?? 0.0;
        final location = _locationController.text.trim();
        final phone = _phoneController.text.trim();
        final category = _selectedService ?? 'Unspecified';
        
        // 1. Update profiles table
        await client.from('profiles').update({
          'phone': phone,
          'profile_completed': true,
        }).eq('id', userId);
        
        // 2. Upsert pros table
        await client.from('pros').upsert({
          'id': userId,
          'hourly_rate': rate,
          'category': category,
          'rating': 4.5,
          'verified': false,
        });
        
        // 3. Upsert pro_locations table
        await client.from('pro_locations').upsert({
          'pro_id': userId,
          'address': location,
          'latitude': -6.7924,
          'longitude': 39.2083,
        });
        
        // Update local auth provider state if needed
        ref.read(authProvider.notifier).updateProfile({
          'phone': phone,
          'profile_completed': true,
          'role': 'pro',
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Wasifu wako umekamilika kikamilifu!'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/wasifu/pro_dashboard');
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
  }

  void _saveAsDraft() {
    HapticFeedback.lightImpact();
    // TODO: Save as draft
  }
}
