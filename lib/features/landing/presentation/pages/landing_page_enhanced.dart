import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../core/widgets/service_image_widget.dart';
import '../../../../core/widgets/video_player_widget.dart';


class LandingPageEnhanced extends StatefulWidget {
  final bool isGuest;
  const LandingPageEnhanced({super.key, this.isGuest = false});

  @override
  State<LandingPageEnhanced> createState() => _LandingPageEnhancedState();
}

class _LandingPageEnhancedState extends State<LandingPageEnhanced> 
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchSuggestions = ['Car Wash', 'Laundry', 'Fundi Umeme'];
  int _currentSuggestionIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  String _currentPlaceholder = '';

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
    
    // Check for selected service query parameter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForSelectedService();
    });
    
    _startTypingAnimation();
  }

  void _checkForSelectedService() {
    final uri = Uri.base;
    final selectedService = uri.queryParameters['selected_service'];
    if (selectedService != null && selectedService.isNotEmpty) {
      setState(() {
        _searchController.text = selectedService;
        _currentPlaceholder = selectedService;
      });
      // Stop the typing animation when service is pre-selected
      _fadeController.stop();
      _slideController.stop();
      _fadeController.forward();
      _slideController.forward();
    }
  }

  void _startTypingAnimation() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _typeText();
    });
  }

  void _typeText() async {
    final currentWord = _searchSuggestions[_currentSuggestionIndex];
    
    if (_isDeleting) {
      if (_charIndex > 0) {
        setState(() {
          _currentPlaceholder = currentWord.substring(0, _charIndex - 1);
          _charIndex--;
        });
        await Future.delayed(const Duration(milliseconds: 50));
        _typeText();
      } else {
        _isDeleting = false;
        _currentSuggestionIndex = (_currentSuggestionIndex + 1) % _searchSuggestions.length;
        await Future.delayed(const Duration(milliseconds: 500));
        _typeText();
      }
    } else {
      if (_charIndex < currentWord.length) {
        setState(() {
          _currentPlaceholder = currentWord.substring(0, _charIndex + 1);
          _charIndex++;
        });
        await Future.delayed(const Duration(milliseconds: 100));
        _typeText();
      } else {
        _isDeleting = true;
        await Future.delayed(const Duration(milliseconds: 1500));
        _typeText();
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive calculations
    final padding = screenWidth * 0.04;
    final titleFontSize = (screenWidth * 0.08).clamp(24.0, 32.0);
    final subtitleFontSize = (screenWidth * 0.04).clamp(14.0, 18.0);
    final sectionTitleFontSize = (screenWidth * 0.05).clamp(18.0, 22.0);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(screenWidth),
                
                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search Bar
                        _buildSearchBar(screenWidth),
                        
                        SizedBox(height: screenHeight * 0.015),
                        
                        // Hero Section
                        _buildHeroSection(titleFontSize, subtitleFontSize),
                        
                        SizedBox(height: screenHeight * 0.015),
                        
                        // Booking CTA
                        _buildBookingCTA(screenWidth),
                        
                        SizedBox(height: screenHeight * 0.015),
                        
                        // Ona Zaidi Section
                        _buildOnaZaidiSection(),
                        
                        SizedBox(height: screenHeight * 0.015),
                        
                        // Service Categories
                        _buildServiceCategories(sectionTitleFontSize, screenWidth),
                        
                        SizedBox(height: screenHeight * 0.015),
                        
                        // Featured Professionals
                        _buildFeaturedProfessionals(sectionTitleFontSize, screenWidth),
                        
                        SizedBox(height: screenHeight * 0.2), // Bottom nav space
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Navigation
          CustomBottomNavigation(
            currentRoute: '/home',
            screenWidth: screenWidth,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      height: context.h(56),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF38BDF8).withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Kazipoa',
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Notifications
              Container(
                width: screenWidth * 0.08,
                height: screenWidth * 0.08,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: screenWidth * 0.04,
                      ),
                    ),
                    Positioned(
                      top: screenWidth * 0.01,
                      right: screenWidth * 0.01,
                      child: Container(
                        width: screenWidth * 0.02,
                        height: screenWidth * 0.02,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00F0FF),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              
              // Profile
              Container(
                width: screenWidth * 0.08,
                height: screenWidth * 0.08,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: screenWidth * 0.04,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(double screenWidth) {
    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.04),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          color: const Color(0xFF38BDF8),
          fontSize: context.fs(14),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: _currentPlaceholder.isEmpty ? 'Tafuta huduma...' : _currentPlaceholder,
          hintStyle: TextStyle(
            color: const Color(0xFF38BDF8).withOpacity(0.4),
            fontSize: context.fs(14),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFF38BDF8),
            size: context.icon(24),
          ),
          filled: true,
          fillColor: const Color(0xFF38BDF8).withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.br(16)),
            borderSide: BorderSide(
              color: const Color(0xFF38BDF8).withOpacity(0.2),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.br(16)),
            borderSide: BorderSide(
              color: const Color(0xFF38BDF8).withOpacity(0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.br(16)),
            borderSide: BorderSide(
              color: const Color(0xFF38BDF8).withOpacity(0.4),
              width: context.br(2),
            ),
          ),
          contentPadding: context.p(h: 16, v: 16),
        ),
      ),
    );
  }

  Widget _buildHeroSection(double titleFontSize, double subtitleFontSize) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Habari! ',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            SizedBox(height: context.sp(4)),
            Text(
              'Je, unahitaji huduma gani leo?',
              style: TextStyle(
                fontSize: subtitleFontSize,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFBAE6FD),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCTA(double screenWidth) {
    return GestureDetector(
      onTap: () {
        // Haptic feedback removed for web compatibility
        _handleBookingAction(isMultipleBooking: true);
      },
      child: Container(
        width: double.infinity,
        padding: context.p(all: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF38BDF8),
          borderRadius: BorderRadius.circular(context.br(24)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF38BDF8).withOpacity(0.2),
              blurRadius: context.br(20),
              spreadRadius: 0,
            ),
          ],
        ),
      child: Stack(
        children: [
          // Background Icon
          Positioned(
            top: 0,
            right: 0,
            child: Transform.rotate(
              angle: 0.2,
              child: Icon(
                Icons.bolt,
                color: Colors.white.withOpacity(0.3),
                size: context.icon(60),
              ),
            ),
          ),
          
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: context.p(h: 10, v: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(context.br(12)),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
                child: Text(
                  'Haraka & Rahisi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: context.fs(8),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              SizedBox(height: context.sp(8)),
              Text(
                'Fanya booking ya huduma',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: context.fs(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: context.sp(4)),
              SizedBox(
                width: context.w(200),
                child: Text(
                  'Tuma ombi kwa wataalamu wote karibu nawe kwa mbofyo mmoja.',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: context.fs(10),
                  ),
                ),
              ),
            ],
          ),
          
          // Arrow Button
          Positioned(
            bottom: context.h(16),
            right: context.w(16),
            child: Container(
              width: context.w(32),
              height: context.h(32),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(context.br(20)),
                border: Border.all(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.black,
                size: context.icon(16),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildOnaZaidiSection() {
    return GestureDetector(
      onTap: () {
        // Haptic feedback removed for web compatibility
        context.go('/home/services');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF38BDF8).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF38BDF8).withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ona zaidi>',
              style: TextStyle(
                color: const Color(0xFF38BDF8),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward,
              color: Color(0xFF38BDF8),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCategories(double fontSize, double screenWidth) {
    final categories = [
      {
        'name': 'Kazi za Ndani', 
        'count': '200+', 
        'image': 'assets/service category images/kazi za ndani.jpg'
      },
      {
        'name': 'Car Wash', 
        'count': '150+', 
        'image': 'assets/service category images/carwash.jpg'
      },
      {
        'name': 'Laundry', 
        'count': '250+', 
        'image': 'assets/service category images/laundry.jpg'
      },
      {
        'name': 'Fundi Umeme', 
        'count': '120+', 
        'image': 'assets/service category images/fundiumeme.jpg'
      },
      {
        'name': 'Makeup Artist', 
        'count': '90+', 
        'image': 'assets/service category images/makeup artist.jpg'
      },
      {
        'name': 'Fundi Cherehani', 
        'count': '75+', 
        'image': 'assets/service category images/fundi chereani.jpg'
      },
      {
        'name': 'Tattoo Artist', 
        'count': '60+', 
        'image': 'assets/service category images/tattoo artist.jpg'
      },
      {
        'name': 'Hair Stylist', 
        'count': '110+', 
        'image': 'assets/service category images/hair stylist.jpg'
      },
      {
        'name': 'Barber', 
        'count': '85+', 
        'image': 'assets/service category images/barber.jpg'
      },
      {
        'name': 'Babysitting', 
        'count': '95+', 
        'image': 'assets/service category images/babysitting.jpg'
      },
      {
        'name': 'Event Planning', 
        'count': '45+', 
        'image': 'assets/service category images/event planning.jpg'
      },
      {
        'name': 'Photography', 
        'count': '65+', 
        'image': 'assets/service category images/photography.jpg'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Huduma Maarufu',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () {
                // Haptic feedback removed for web compatibility
                context.go('/home/services');
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ona Zote',
                    style: TextStyle(
                      color: Color(0xFF38BDF8),
                      fontSize: context.fs(11),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF38BDF8),
                    size: context.icon(14),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: context.sp(16)),
        
        // Horizontal Scroll
        SizedBox(
          height: context.h(160),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return InkWell(
                onTap: () {
                  // Haptic feedback removed for web compatibility
                  final categoryName = category['name'] as String;
                  setState(() {
                    _searchController.text = categoryName;
                    _currentPlaceholder = categoryName;
                  });
                  // Stop the typing animation when category is selected
                  _fadeController.stop();
                  _slideController.stop();
                  _fadeController.forward();
                  _slideController.forward();
                },
                borderRadius: BorderRadius.circular(context.br(24)),
                child: Container(
                  width: context.w(180),
                  height: context.h(200),
                  margin: EdgeInsets.only(right: context.sp(12)),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(context.br(24)),
                    border: Border.all(
                      color: const Color(0xFF38BDF8).withOpacity(0.2),
                    ),
                  ),
                  child: Padding(
                    padding: context.p(all: 8),
                    child: Column(
                      children: [
                        // Video Container
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(context.br(16)),
                              color: Colors.grey.withOpacity(0.3),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(context.br(16)),
                              child: ServiceImageWidget(
                                imagePath: category['image'] as String,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: context.sp(12)),
                        
                        // Category Info
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text(
                                  category['name'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${category['count']} Wataalamu',
                                  style: TextStyle(
                                    color: const Color(0xFF38BDF8).withOpacity(0.7),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                ],
                            ),
                          ),
                ],
                      ),
                ),
              ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedProfessionals(double fontSize, double screenWidth) {
    final professionals = [
      {
        'id': 'pro_001',
        'name': 'Bakari Said',
        'service': 'Mtaalamu wa Mabomba',
        'location': 'Mikocheni',
        'rating': 4.9,
        'reviewCount': 127,
        'isVerified': true,
        'tier': 'Platinum',
        'tierColor': const Color(0xFF38BDF8),
        'tags': ['Muda Mfupi', 'Vifaa Vipo'],
        'serviceCost': '15000',
        'phone': '+255 712 3456',
        'reviews': [
          {'rating': 5, 'comment': 'Mtaalamu mzuri sana! Alifanya kazi kwa ufasaha.', 'date': '2024-01-15'},
          {'rating': 5, 'comment': 'Ninampenda Bakari, anajua kazi yake.', 'date': '2024-01-10'},
          {'rating': 4, 'comment': 'Kazi nzuri, ila alichelewa kidogo.', 'date': '2024-01-05'},
        ],
      },
      {
        'id': 'pro_002',
        'name': 'Anna Komba',
        'service': 'Usafi wa Ndani',
        'location': 'Masaki',
        'rating': 2.8,
        'reviewCount': 23,
        'isVerified': false,
        'tier': 'Bronze',
        'tierColor': const Color(0xFFFB923C),
        'tags': ['Maalum', 'Zana Zipo'],
        'serviceCost': '12000',
        'phone': '+255 789 0123',
        'reviews': [
          {'rating': 3, 'comment': 'Kazi ya kawaida, haina kitu cha kipekee.', 'date': '2024-01-12'},
          {'rating': 2, 'comment': 'Alifanya kazi vibaya, nililazimika kumwambia afanye tena.', 'date': '2024-01-08'},
          {'rating': 3, 'comment': 'Bei ni nzuri lakini quality siyo ya juu.', 'date': '2024-01-03'},
        ],
      },
      {
        'id': 'pro_003',
        'name': 'John Mwangi',
        'service': 'Umeme na Viyoyozi',
        'location': 'Kinondoni',
        'rating': 4.5,
        'reviewCount': 45,
        'isVerified': false,
        'tier': 'Gold',
        'tierColor': const Color(0xFFF59E0B),
        'tags': ['Muda Mfupi', 'Zana Zipo'],
        'serviceCost': '18000',
        'phone': '+255 754 3210',
        'reviews': [
          {'rating': 5, 'comment': 'Anajua umeme sana, alisuluhisha tatizo langu.', 'date': '2024-01-14'},
          {'rating': 4, 'comment': 'Kazi nzima, bei ni sawa.', 'date': '2024-01-09'},
          {'rating': 4, 'comment': 'Mtaalamu, anapenda kazi yake.', 'date': '2024-01-04'},
        ],
      },
      {
        'id': 'pro_004',
        'name': 'Grace Kimono',
        'service': 'Upishi na Sherehe',
        'location': 'Msasani',
        'rating': 3.2,
        'reviewCount': 8,
        'isVerified': false,
        'tier': 'Silver',
        'tierColor': const Color(0xFF94A3B8),
        'tags': ['Muda Mfupi'],
        'serviceCost': '10000',
        'phone': '+255 765 4321',
        'reviews': [
          {'rating': 3, 'comment': 'Mpya lakini ana uwezo.', 'date': '2024-01-11'},
          {'rating': 3, 'comment': 'Kazi nzuri kwa muanza.', 'date': '2024-01-07'},
        ],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Wataalamu Wetu',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF38BDF8),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0C4A6E),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0C4A6E),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Professional Cards
        ...professionals.map((pro) => _buildProfessionalCard(pro, screenWidth)),
      ],
    );
  }

  Widget _buildProfessionalCard(Map<String, dynamic> pro, double screenWidth) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF38BDF8).withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Profile Image
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.withOpacity(0.3),
                        border: Border.all(
                          color: const Color(0xFF38BDF8).withOpacity(0.2),
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Info
                    Expanded(
  child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tier Badge with Verification
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: (pro['tierColor'] as Color).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: (pro['tierColor'] as Color).withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              pro['tier'] as String,
                              style: TextStyle(
                                color: pro['tierColor'] as Color,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (pro['isVerified'] as bool) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              color: Color(0xFF00F0FF),
                              size: 12,
                            ),
                ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      
                      // Name
                      Text(
                        pro['name'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      
                      // Service & Location
                      Text(
                        '${pro['service']} \u2022 ${pro['location']}',
                        style: TextStyle(
                          color: const Color(0xFFBAE6FD),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      
                      // Rating & Reviews
                      GestureDetector(
                        onTap: () => _showReviewsDialog(pro),
                        child: Row(
                          children: [
                            // Star Rating
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(5, (index) {
                                final rating = pro['rating'] as double;
                                final starValue = index + 1;
                                if (starValue <= rating) {
                                  return const Icon(
                                    Icons.star,
                                    color: Color(0xFFF59E0B),
                                    size: 12,
                                  );
                                } else if (starValue - 0.5 <= rating) {
                                  return const Icon(
                                    Icons.star_half,
                                    color: Color(0xFFF59E0B),
                                    size: 12,
                                  );
                                } else {
                                  return const Icon(
                                    Icons.star_border,
                                    color: Color(0xFF94A3B8),
                                    size: 12,
                                  );
                                }
                              }),
                            ),
                            const SizedBox(width: 4),
                            // Rating Number and Review Count
                            Text(
                              '${(pro['rating'] as double).toStringAsFixed(1)} (${pro['reviewCount']} ukaguzi)',
                              style: TextStyle(
                                color: const Color(0xFF94A3B8),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xFF94A3B8),
                              size: 8,
                            ),
                ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      
                      // Service Cost
                      Text(
                        'Bei: TSH ${pro['serviceCost'] ?? '0'}/kazi',
                        style: TextStyle(
                          color: const Color(0xFF38BDF8),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      
                      // Phone Number - Hidden for guest users
                      if (!widget.isGuest)
                        Text(
                          'Simu: ${pro['phone'] ?? '+255 000 000'}',
                          style: TextStyle(
                            color: const Color(0xFF38BDF8).withOpacity(0.7),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      else
                        Text(
                          'Simu: Jisajili kuona',
                          style: TextStyle(
                            color: const Color(0xFF94A3B8),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      const SizedBox(height: 2),
                      
                      // Bookmark
                      Icon(
                        Icons.bookmark,
                        color: const Color(0xFF38BDF8).withOpacity(0.5),
                        size: 16,
                      ),
                ],
                  ),
                ),
                ],
              ),
            ),
          ],
          ),
          const SizedBox(height: 16),
          
          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (pro['tags'] as List<String>).map((tag) {
              final isPrimary = tag == 'Muda Mfupi' || tag == 'Maalum';
              return Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
                decoration: BoxDecoration(
                  color: isPrimary 
                      ? const Color(0xFF38BDF8).withOpacity(0.1)
                      : const Color(0xFF0C4A6E).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: isPrimary ? const Color(0xFF38BDF8) : const Color(0xFF7DD3FC),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 16),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if (widget.isGuest) {
                      // Navigate to sign-up for guest users
                      _showGuestSignUpDialog();
                    } else {
                      // Make phone call to pro
                      _makePhoneCall(pro['phone'] as String?);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF38BDF8)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Wasiliana',
                    style: TextStyle(
                      color: Color(0xFF38BDF8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.isGuest) {
                      // Navigate to sign-up for guest users
                      _showGuestSignUpDialog();
                    } else {
                      // Haptic feedback removed for web compatibility
                      _handleBookingAction(proId: pro['id']); // Pass actual proId from pro card data
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38BDF8),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shadowColor: const Color(0xFF38BDF8).withOpacity(0.2),
                  ),
                  child: const Text(
                    'Fanya booking',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showGuestSignUpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Tahadhari',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Ili kuwasiliana na mtaalamu, unahitaji kuwa na akaunti. Je, ungependa kusajili au kuingia?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/register');
              },
              child: const Text('Sajili', style: TextStyle(color: Color(0xFF38BDF8))),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/login');
              },
              child: const Text('Ingia', style: TextStyle(color: Color(0xFF38BDF8))),
            ),
          ],
        );
      },
    );
  }

  void _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Namba ya simu haipatikani'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Haiwezi kupiga simu. Tafadhali jaribu tena.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hitilafu wakati wa kupiga simu.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showReviewsDialog(Map<String, dynamic> pro) {
    final reviews = pro['reviews'] as List<Map<String, dynamic>>;
    final rating = pro['rating'] as double;
    final reviewCount = pro['reviewCount'] as int;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Row(
            children: [
              Text(
                'Ukaguzi wa ${pro['name']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overall Rating
                Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        final starValue = index + 1;
                        if (starValue <= rating) {
                          return const Icon(
                            Icons.star,
                            color: Color(0xFFF59E0B),
                            size: 20,
                          );
                        } else if (starValue - 0.5 <= rating) {
                          return const Icon(
                            Icons.star_half,
                            color: Color(0xFFF59E0B),
                            size: 20,
                          );
                        } else {
                          return const Icon(
                            Icons.star_border,
                            color: Color(0xFF94A3B8),
                            size: 20,
                          );
                        }
                      }),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '($reviewCount ukaguzi)',
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                      ),
                    ),
                ],
                ),
                const SizedBox(height: 16),
                
                // Reviews List
                Expanded(
                  child: ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Rating and Date
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: List.generate(5, (starIndex) {
                                    final reviewRating = review['rating'] as int;
                                    return Icon(
                                      starIndex < reviewRating ? Icons.star : Icons.star_border,
                                      color: const Color(0xFFF59E0B),
                                      size: 12,
                                    );
                                  }),
                                ),
                                Text(
                                  review['date'] as String,
                                  style: const TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 10,
                                  ),
                                ),
                ],
                            ),
                            const SizedBox(height: 4),
                            // Comment
                            Text(
                              review['comment'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Funga',
                style: TextStyle(color: Color(0xFF38BDF8)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleBookingAction({String? proId, bool isMultipleBooking = false}) {
    // Check if user is in guest mode
    final isGuestMode = widget.isGuest;
    
    if (isGuestMode) {
      // Show dialog asking user to register or login
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: const Text(
              'Tahadhari',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Ili kufanya booking, unahitaji kuwa na akaunti. Je, ungependa kusajili au kuingia?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/register');
                },
                child: const Text('Sajili', style: TextStyle(color: Color(0xFF38BDF8))),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/login');
                },
                child: const Text('Ingia', style: TextStyle(color: Color(0xFF38BDF8))),
              ),
            ],
          );
        },
      );
    } else {
      // User is logged in, proceed to booking
      if (isMultipleBooking) {
        // Multiple booking request - send to top 10 pros (ignore service cost)
        context.go('/miadi/setup');
      } else if (proId != null) {
        // Individual booking request to specific pro
        context.go('/miadi/setup?proId=$proId');
      } else {
        // General booking setup
        context.go('/miadi/setup');
      }
    }
  }
}
























































































































