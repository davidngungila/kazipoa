import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/job_card.dart';
import '../services/auth_service.dart';
import 'auth/login_screen.dart';
import 'profile/profile_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Zote';

  final List<String> _categories = [
    'Zote',
    'Ujenzi',
    'Hotelini',
    'Tehama',
  ];

  final List<Map<String, dynamic>> _featuredJobs = [
    {
      'title': 'Mhasibu Msaidizi',
      'company': 'Peak Financials',
      'location': 'Dar es Salaam',
      'type': 'MUDA KAMILI',
      'experience': 'MIAKA 2+ EXP',
      'salary': 'TZS 850,000/mwezi',
      'badge': 'Platinum',
      'verified': true,
      'icon': Icons.account_balance,
    },
    {
      'title': 'Dereva wa Bodaboda',
      'company': 'Bolt Tanzania',
      'location': 'Arusha',
      'type': 'KAZI MAALUM',
      'experience': 'LESENI DARAJA C',
      'salary': 'TZS 25,000/siku',
      'badge': 'Gold',
      'verified': true,
      'icon': Icons.motorcycle,
    },
    {
      'title': 'Fundi Umeme',
      'company': 'Nyumbani Services',
      'location': 'Mwanza',
      'type': 'MUDA MFUPI',
      'experience': 'VETA CERTIFIED',
      'salary': 'TZS 15,000',
      'badge': 'Silver',
      'verified': false,
      'icon': Icons.electrical_services,
    },
    {
      'title': 'Usafi wa Nyumbani',
      'company': 'EcoClean',
      'location': 'Dodoma',
      'type': 'MUDA MFUPI',
      'experience': 'CERTIFIED',
      'salary': 'TZS 20,000',
      'badge': 'Bronze',
      'verified': false,
      'icon': Icons.cleaning_services,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lavenderBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Hero Section
            _buildHeroSection(),
            
            // Categories
            _buildCategories(),
            
            // Featured Jobs Section
            _buildFeaturedJobs(),
            
            const Spacer(),
            
            // Bottom Navigation
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Kazipoa',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const Spacer(),
          
          // Notifications
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: AppTheme.darkGrey,
                  size: 24,
                ),
                onPressed: () {
                  // Handle notifications
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 8),
          
          // Profile Picture
          Consumer<AuthService>(
            builder: (context, authService, child) {
              return GestureDetector(
                onTap: () {
                  if (authService.isAuthenticated) {
                    // Navigate to profile if logged in
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  } else {
                    // Navigate to login if not logged in
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.lightPurple,
                    image: DecorationImage(
                      image: authService.currentUser != null
                          ? const NetworkImage('https://via.placeholder.com/40')
                          : const AssetImage('assets/images/default_profile.png') as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: authService.currentUser == null
                      ? Icon(
                          Icons.person,
                          color: AppTheme.primaryPurple,
                          size: 24,
                        )
                      : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryPurple,
            AppTheme.lightPurple,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pata Kazi ya Ndoto Yako',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Zaidi ya nafasi 1,200 mpya leo',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          
          // Search Bar
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tafuta fundi, dereva, au mwalimu...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppTheme.mediumGrey,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle search
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    'Tafuta',
                    style: TextStyle(
                      color: AppTheme.primaryPurple,
                      fontWeight: FontWeight.w600,
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

  Widget _buildCategories() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryPurple : Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.mediumGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedJobs() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Zilizopendekezwa',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGrey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // View all
                  },
                  child: Text(
                    'Zote',
                    style: TextStyle(
                      color: AppTheme.primaryPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Jobs List
            Expanded(
              child: ListView.builder(
                itemCount: _featuredJobs.length,
                itemBuilder: (context, index) {
                  final job = _featuredJobs[index];
                  return JobCard(job: job);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryPurple,
        unselectedItemColor: AppTheme.lightGrey,
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: AppTheme.primaryPurple),
            label: 'Nyumbani',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore, color: AppTheme.lightGrey),
            label: 'Gundua',
          ),
          // Central Post Job Button
          BottomNavigationBarItem(
            icon: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryPurple, AppTheme.lightPurple],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryPurple.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 28,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark, color: AppTheme.lightGrey),
            label: 'Zilizohifadhiwa',
          ),
          BottomNavigationBarItem(
            icon: Consumer<AuthService>(
              builder: (context, authService, child) {
                return GestureDetector(
                  onTap: () {
                    if (authService.isAuthenticated) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                  child: Icon(
                    Icons.person,
                    color: authService.isAuthenticated 
                        ? AppTheme.primaryPurple 
                        : AppTheme.lightGrey,
                  ),
                );
              },
            ),
            label: 'Wasifu',
          ),
        ],
      ),
    );
  }
}
