import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class OtpClientEnhanced extends StatefulWidget {
  const OtpClientEnhanced({super.key});

  @override
  State<OtpClientEnhanced> createState() => _OtpClientEnhancedState();
}

class _OtpClientEnhancedState extends State<OtpClientEnhanced>
    with TickerProviderStateMixin {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  
  @override
  void initState() {
    super.initState();
    // Pre-fill first two digits as shown in HTML
    _otpControllers[0].text = '5';
    _otpControllers[1].text = '2';
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive calculations
    final padding = screenWidth * 0.04;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(screenWidth),
            
            // Main Content
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(padding),
                  child: _buildLiquidGlassCard(screenWidth),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
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
              // Official Logo
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/official logo.jpeg',
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to text if image fails to load
                      return const Center(
                        child: Text(
                          'K',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              const Text(
                'Kazipoa',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
          
          // More Options
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO: Show more options
            },
            child: Icon(
              Icons.more_vert,
              color: Colors.grey.shade400,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiquidGlassCard(double screenWidth) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: screenWidth * 0.9,
      ),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 64,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative Bloom
          Positioned(
            top: -96,
            right: -96,
            child: Container(
              width: 192,
              height: 192,
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon Shell
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                child: const Icon(
                  Icons.smartphone,
                  color: Color(0xFF3B82F6),
                  size: 48,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Title and Description
              Column(
                children: [
                  const Text(
                    'Uhakiki wa OTP',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Tumekutumia kodi ya siri kwenye namba yako ',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: '+255 700 000 000',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '.',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // OTP Inputs
              _buildOtpInputs(),
              
              const SizedBox(height: 24),
              
              // Primary Action Button
              _buildPrimaryActionButton(),
              
              const SizedBox(height: 16),
              
              // Secondary Links
              _buildSecondaryLinks(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOtpInputs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 48,
          height: 56,
          child: TextField(
            controller: _otpControllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            maxLength: 1,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF3B82F6),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              }
            },
          ),
        );
      }),
    );
  }

  Widget _buildPrimaryActionButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.2),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.heavyImpact();
          // Navigate to landing page after successful OTP verification
          context.go('/home');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Endelea',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryLinks() {
    return Column(
      children: [
        // Resend Button
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            // TODO: Resend OTP
          },
          child: const Text(
            'Tuma Tena',
            style: TextStyle(
              color: Color(0xFF3B82F6),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Divider
        Container(
          width: 48,
          height: 1,
          color: Colors.white.withOpacity(0.1),
        ),
        
        const SizedBox(height: 16),
        
        // Change Number Button
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            // TODO: Change phone number
          },
          child: const Text(
            'Badili Namba',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
