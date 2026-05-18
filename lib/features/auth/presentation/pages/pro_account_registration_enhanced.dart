import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ProAccountRegistrationEnhanced extends StatefulWidget {
  const ProAccountRegistrationEnhanced({super.key});

  @override
  State<ProAccountRegistrationEnhanced> createState() => _ProAccountRegistrationEnhancedState();
}

class _ProAccountRegistrationEnhancedState extends State<ProAccountRegistrationEnhanced>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  late AnimationController _blobController;
  late Animation<Offset> _blobAnimation;

  @override
  void initState() {
    super.initState();
    _blobController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );

    _blobAnimation = Tween<Offset>(
      begin: const Offset(-0.1, -0.1),
      end: const Offset(0.1, 0.1),
    ).animate(CurvedAnimation(
      parent: _blobController,
      curve: Curves.easeInOut,
    ));

    _blobController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _blobController.dispose();
    _fullNameController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                        width: 600,
                        height: 600,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF00D4FF).withOpacity(0.12),
                              const Color(0xFF00D4FF).withOpacity(0.0),
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
                        width: 600,
                        height: 600,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF00D4FF).withOpacity(0.08),
                              const Color(0xFF00D4FF).withOpacity(0.0),
                            ],
                          ),
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
                
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      children: [
                        // Progress Section
                        _buildProgressSection(),
                        
                        const SizedBox(height: 32),
                        
                        // Registration Card
                        _buildRegistrationCard(cardWidth, titleFontSize),
                        
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
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
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
                    color: Color(0xFF00D4FF),
                    size: 24,
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Title
              const Text(
                'Pro Registration',
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
            'LP.',
            style: TextStyle(
              color: Color(0xFF00D4FF),
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
                color: const Color(0xFF00D4FF),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 4),
        
        // Step Text
        Text(
          'HATUA YA 1 KATI YA 3',
          style: TextStyle(
            color: const Color(0xFF00D4FF).withOpacity(0.8),
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationCard(double cardWidth, double titleFontSize) {
    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D4FF).withOpacity(0.05),
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
              'Jisajili kama Mtaalamu',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Full Name Field
            _buildFormField(
              controller: _fullNameController,
              label: 'Jina Kamili',
              hintText: 'Mf. Juma Haruna',
              icon: Icons.person,
            ),
            
            const SizedBox(height: 24),
            
            // Email/Phone Field
            _buildFormField(
              controller: _contactController,
              label: 'Barua Pepe au Simu',
              hintText: 'barua@pepe.com au 07...',
              icon: Icons.contact_mail,
            ),
            
            const SizedBox(height: 24),
            
            // Password Field
            _buildFormField(
              controller: _passwordController,
              label: 'Nenosiri',
              hintText: '********',
              icon: Icons.lock,
              obscureText: true,
            ),
            
            const SizedBox(height: 24),
            
            // Confirm Password Field
            _buildFormField(
              controller: _confirmPasswordController,
              label: 'Thibitisha Nenosiri',
              hintText: '********',
              icon: Icons.shield,
              obscureText: true,
            ),
            
            const SizedBox(height: 32),
            
            // Submit Button
            _buildSubmitButton(),
            
            const SizedBox(height: 24),
            
            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tayari una akaunti? ',
                  style: TextStyle(
                    color: const Color(0xFF94A3B8),
                    fontSize: 12,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.go('/pro_login');
                  },
                  child: const Text(
                    'Ingia hapa',
                    style: TextStyle(
                      color: Color(0xFF00D4FF),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
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
    bool obscureText = false,
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
            obscureText: obscureText,
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
                  color: Color(0xFF00D4FF),
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
        color: const Color(0xFF00D4FF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D4FF).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submitRegistration,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Endelea',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }

  void _submitRegistration() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.heavyImpact();
      
      // Determine if contact is email or phone number
      final contact = _contactController.text.trim();
      if (contact.contains('@')) {
        // Email - go to email verification
        context.go('/pro_registration/email');
      } else {
        // Phone number - go to OTP verification
        context.go('/pro_registration/phone');
      }
    }
  }
}
