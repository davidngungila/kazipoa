import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/service_category.dart';
import '../../../../core/widgets/service_image_widget.dart';

class ServiceListingsEnhanced extends StatefulWidget {
  final String categoryId;
  final ServiceCategory? category;

  const ServiceListingsEnhanced({
    super.key,
    required this.categoryId,
    this.category,
  });

  @override
  State<ServiceListingsEnhanced> createState() => _ServiceListingsEnhancedState();
}

class _ServiceListingsEnhancedState extends State<ServiceListingsEnhanced>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
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
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    _buildSearchBar(screenWidth),
                    
                    SizedBox(height: screenWidth * 0.04),
                    
                    // Section Title
                    _buildSectionTitle(screenWidth),
                    
                    SizedBox(height: screenWidth * 0.04),
                    
                    // Services List
                    _buildServicesList(screenWidth, screenHeight),
                    
                    SizedBox(height: screenHeight * 0.05), // Reduced bottom space
                  ],
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
      height: screenWidth * 0.12,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.02),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
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
                onTap: () => context.go('/home'),
                child: Container(
                  width: screenWidth * 0.08,
                  height: screenWidth * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: screenWidth * 0.05,
                  ),
                ),
              ),
              
              SizedBox(width: screenWidth * 0.04),
              
              // Logo and Title
              Row(
                children: [
                  // Official Kazipoa Logo
                  Container(
                    width: screenWidth * 0.08,
                    height: screenWidth * 0.08,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: screenWidth * 0.02,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/official logo.jpeg',
                        width: screenWidth * 0.08,
                        height: screenWidth * 0.08,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback to text if image fails to load
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF38BDF8).withOpacity(0.3),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'K',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  SizedBox(width: screenWidth * 0.03),
                  
                  Text(
                    'Huduma Zaidi',
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF38BDF8),
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Profile Icon
          Container(
            width: screenWidth * 0.1,
            height: screenWidth * 0.1,
            decoration: BoxDecoration(
              color: const Color(0xFF334155),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            child: Icon(
              Icons.person,
              color: Color(0xFF94A3B8),
              size: screenWidth * 0.05,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(double screenWidth) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: screenWidth * 0.04,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Color(0xFF38BDF8),
            size: screenWidth * 0.04,
          ),
          SizedBox(width: screenWidth * 0.03),
          Text(
            'Tafuta huduma unayohitaji...',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: screenWidth * 0.025,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'KAZIPOA ECOSYSTEM',
          style: TextStyle(
            color: Color(0xFF38BDF8),
            fontSize: screenWidth * 0.02,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: screenWidth * 0.01),
        Text(
          'Chagua Jamii ya Huduma',
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildServicesList(double screenWidth, double screenHeight) {
    final services = [
      {
        'title': 'Kazi za Ndani',
        'subtitle': 'Usafi na Mpangilio wa Nyumba',
        'icon': Icons.cleaning_services,
        'color': const Color(0xFF38BDF8),
        'image': 'assets/service category images/kazi za ndani.jpg',
      },
      {
        'title': 'Babysitting',
        'subtitle': 'Malezi Salama na ya Upendo',
        'icon': Icons.child_care,
        'color': const Color(0xFF38BDF8),
        'image': 'assets/service category images/babysitting.jpg',
      },
      {
        'title': 'Gardening',
        'subtitle': 'Upandaji na Matengenezo wa Bustani',
        'icon': Icons.park,
        'color': const Color(0xFF38BDF8),
        'image': 'assets/service category images/gardening.jpg',
      },
      {
        'title': 'Pest Control',
        'subtitle': 'Udhibiti wa Wadudu Waharibifu',
        'icon': Icons.pest_control,
        'color': const Color(0xFF38BDF8),
        'image': 'assets/service category images/pest control.jpg',
      },
      {
        'title': 'Fundi Bomba',
        'subtitle': 'Maji na Mifumo ya Mabomba',
        'icon': Icons.plumbing,
        'color': const Color(0xFF38BDF8),
        'image': 'assets/service category images/plumbing.jpg',
      },
      {
        'title': 'Carpentry',
        'subtitle': 'Samani na Ufundi wa Mbao',
        'icon': Icons.carpenter,
        'color': const Color(0xFF38BDF8),
        'image': 'assets/service category images/carpentry.jpg',
      },
      {
        'title': 'Cooking',
        'subtitle': 'Mapishi na Upishi',
        'icon': Icons.restaurant,
        'color': const Color(0xFF38BDF8),
        'image': 'assets/service category images/cooking.jpg',
      },
      {
        'title': 'Security',
        'subtitle': 'Ulinzi na Usalama',
        'icon': Icons.security,
        'color': const Color(0xFF38BDF8),
        'image': 'assets/service category images/security.jpg',
      },
      {
        'title': 'Hair Stylist',
        'subtitle': 'Mitindo ya Nywele na Salon',
        'icon': Icons.content_cut,
        'color': const Color(0xFF38BDF8),
        'image': 'assets/service category images/hair stylist.jpg',
      },
      {
        'title': 'Photography',
        'subtitle': 'Picha na Matukio Maalum',
        'icon': Icons.camera_alt,
        'color': const Color(0xFF38BDF8),
        'image': 'assets/service category images/photography.jpg',
      },
      {
        'title': 'DJ Services',
        'subtitle': 'Muziki na Matukio',
        'icon': Icons.music_note,
        'color': const Color(0xFF38BDF8),
        'image': 'assets/service category images/dj services.jpg',
      },
      {
        'title': 'Event Planning',
        'subtitle': 'Mpangilio wa Matukio',
        'icon': Icons.event,
        'color': const Color(0xFF38BDF8),
        'image': 'assets/service category images/event planning.jpg',
      },
    ];

    return Column(
      children: services.map((service) {
        return Container(
          margin: EdgeInsets.only(bottom: screenWidth * 0.03),
          height: screenWidth * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: screenWidth * 0.06,
                spreadRadius: 0,
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              // Navigate back to landing page with selected service as first category
              final serviceName = service['title'] as String;
              context.go('/home?selected_service=$serviceName');
            },
            child: Stack(
              children: [
                // Background Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                  child: ServiceImageWidget(
                    imagePath: service['image'] as String,
                    fit: BoxFit.cover,
                  ),
                ),
                
                // Gradient Overlay
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.06),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.9),
                      ],
                      stops: const [0.0, 0.3, 0.7, 1.0],
                    ),
                  ),
                ),
                
                // Content
                Positioned(
                  bottom: screenWidth * 0.06,
                  left: screenWidth * 0.06,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['title'] as String,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.01),
                      Text(
                        service['subtitle'] as String,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: screenWidth * 0.02,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Icon Badge
                Positioned(
                  top: screenWidth * 0.06,
                  right: screenWidth * 0.06,
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    decoration: BoxDecoration(
                      color: (service['color'] as Color).withOpacity(0.2),
                      border: Border.all(
                        color: (service['color'] as Color).withOpacity(0.3),
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      service['icon'] as IconData,
                      color: service['color'] as Color,
                      size: screenWidth * 0.05,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

}
