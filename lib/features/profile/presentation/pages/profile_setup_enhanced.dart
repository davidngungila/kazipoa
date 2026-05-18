import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ProfileSetupEnhanced extends StatefulWidget {
  const ProfileSetupEnhanced({super.key});

  @override
  State<ProfileSetupEnhanced> createState() => _ProfileSetupEnhancedState();
}

class _ProfileSetupEnhancedState extends State<ProfileSetupEnhanced>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _serviceDescriptionController = TextEditingController();
  final _experienceController = TextEditingController();
  final _locationController = TextEditingController();
  final _serviceCostController = TextEditingController();
  
  String _selectedCategory = 'Bomba';
  String _selectedTier = 'Bronze';
  
  final List<String> _categories = [
    'Bomba', 'Umeme', 'Usafi', 'Useremala', 'Mapishi', 'Bustani', 'Doobi', 'Udhibiti wa Wadudu'
  ];
  
  final List<String> _tiers = ['Bronze', 'Silver', 'Gold', 'Platinum'];
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _businessNameController.dispose();
    _serviceDescriptionController.dispose();
    _experienceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive calculations
    final padding = screenWidth * 0.04;
    final titleFontSize = (screenWidth * 0.06).clamp(20.0, 24.0);
    final cardWidth = (screenWidth * 0.9).clamp(320.0, 400.0);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Animated Background
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black,
                      const Color(0xFF00D2FF).withOpacity(0.05 * _fadeAnimation.value),
                      Colors.black,
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(screenWidth),
                
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(padding),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          // Progress Section
                          _buildProgressSection(),
                          
                          const SizedBox(height: 32),
                          
                          // Setup Card
                          _buildSetupCard(cardWidth, titleFontSize),
                          
                          SizedBox(height: screenHeight * 0.25), // Bottom nav space
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Navigation
          _buildBottomNavigation(screenWidth),
        ],
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
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
          Row(
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF00D2FF),
                    size: 24,
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Title
              const Text(
                'Pro Profile Setup',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          
          // Step Indicator
          const Text(
            'STEP 3',
            style: TextStyle(
              color: Color(0xFF00D2FF),
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      children: [
        // Progress Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF00D2FF).withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF00D2FF).withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF00D2FF),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 4),
        
        // Step Text
        Text(
          'HATUA YA 3 KATI YA 3 - MALIZI',
          style: TextStyle(
            color: const Color(0xFF00D2FF).withOpacity(0.8),
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildSetupCard(double cardWidth, double titleFontSize) {
    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D2FF).withOpacity(0.05),
            blurRadius: 40,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Text(
              'Weka Maelezo ya Biashara',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Business Name
            _buildFormField(
              controller: _businessNameController,
              label: 'Jina la Biashara',
              hintText: 'Mf. Juma Tech Solutions',
              icon: Icons.business,
            ),
            
            const SizedBox(height: 24),
            
            // Service Category
            _buildDropdownField(
              label: 'Aina ya Huduma',
              value: _selectedCategory,
              items: _categories,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              icon: Icons.category,
            ),
            
            const SizedBox(height: 24),
            
            // Service Description
            _buildTextAreaField(
              controller: _serviceDescriptionController,
              label: 'Maelezo ya Huduma',
              hintText: 'Eleza huduma unazotoa kwa ufupi...',
              icon: Icons.description,
            ),
            
            const SizedBox(height: 24),
            
            // Experience
            _buildFormField(
              controller: _experienceController,
              label: 'Uzoefu (Miaka)',
              hintText: 'Mf. 5',
              icon: Icons.timeline,
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: 24),
            
            // Location
            _buildFormField(
              controller: _locationController,
              label: 'Eneo la Kazi',
              hintText: 'Mf. Dar es Salaam',
              icon: Icons.location_on,
            ),
            
            const SizedBox(height: 24),
            
            // Service Cost (Hidden from clients)
            _buildFormField(
              controller: _serviceCostController,
              label: 'Bei ya Huduma (TZS/saa) - HAIONEKISHWA KWA WATEJA',
              hintText: 'Mf. 25000',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: 24),
            
            // Tier Selection
            _buildDropdownField(
              label: 'Aina ya Akaunti',
              value: _selectedTier,
              items: _tiers,
              onChanged: (value) {
                setState(() {
                  _selectedTier = value!;
                });
              },
              icon: Icons.star,
            ),
            
            const SizedBox(height: 32),
            
            // Submit Button
            _buildSubmitButton(),
            
            const SizedBox(height: 24),
            
            // Skip Link
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                // Navigate to dashboard without completing profile
                context.go('/dashboard_enhanced');
              },
              child: const Text(
                'Ruka sasa hivi',
                style: TextStyle(
                  color: Color(0xFF00D2FF),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF475569),
              ),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF00D2FF),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF64748B),
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextAreaField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: 3,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF475569),
              ),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF00D2FF),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF64748B),
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: value,
            dropdownColor: Colors.black,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF00D2FF),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF64748B),
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF00D2FF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D2FF).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submitProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Maliza Usajili',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(double screenWidth) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 30,
              spreadRadius: 0,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home
            _buildNavItem(
              icon: Icons.home,
              label: 'Nyumbani',
              isActive: false,
              onTap: () {},
            ),
            
            // Miadi
            _buildNavItem(
              icon: Icons.calendar_today,
              label: 'Miadi',
              isActive: false,
              onTap: () {},
            ),
            
            // Kazi Live (Elevated)
            _buildKaziLiveItem(),
            
            // Malipo
            _buildNavItem(
              icon: Icons.payments,
              label: 'Malipo',
              isActive: false,
              onTap: () {},
            ),
            
            // Wasifu (Active)
            _buildNavItem(
              icon: Icons.person,
              label: 'Wasifu',
              isActive: true,
              onTap: () {},
              hasDot: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    bool hasDot = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF00D2FF) : Colors.grey.shade500,
              size: 24,
              weight: isActive ? 700 : 400,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFF00D2FF) : Colors.grey.shade500,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            if (hasDot) ...[
              const SizedBox(height: 4),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFF00D2FF),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildKaziLiveItem() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF00D2FF),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00D2FF).withOpacity(0.4),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
            border: Border.all(
              color: Colors.black,
              width: 4,
            ),
          ),
          child: const Icon(
            Icons.bolt,
            color: Colors.black,
            size: 24,
            weight: 700,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Kazi Live',
          style: TextStyle(
            color: Color(0xFF00D2FF),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  void _submitProfile() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.heavyImpact();
      
      // Navigate to dashboard after completing profile setup
      context.go('/dashboard_enhanced');
    }
  }
}
