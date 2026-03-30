import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/liquid_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final _nameController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'john.doe@example.com');
  final _phoneController = TextEditingController(text: '+255 712 345 678');
  final _locationController = TextEditingController(text: 'Dar es Salaam, Tanzania');
  final _bioController = TextEditingController(text: 'Professional service provider with 5+ years of experience');

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
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: Stack(
        children: [
          // Liquid Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF0A0A14),
                          const Color(0xFF1A1A2E),
                        ]
                      : [
                          const Color(0xFFF6F5F8),
                          const Color(0xFFE0E7FF),
                        ],
                ),
              ),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Stack(
                    children: [
                      // Moving blob 1
                      Positioned(
                        top: -100,
                        left: -100,
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 20),
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: KazipoaTheme.primaryColor.withOpacity(0.1),
                            boxShadow: [
                              BoxShadow(
                                color: KazipoaTheme.primaryColor.withOpacity(0.2),
                                blurRadius: 80,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Moving blob 2
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.6,
                        right: -100,
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 25),
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: KazipoaTheme.secondaryColor.withOpacity(0.1),
                            boxShadow: [
                              BoxShadow(
                                color: KazipoaTheme.secondaryColor.withOpacity(0.2),
                                blurRadius: 60,
                                spreadRadius: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          
          // Safe Area Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Top App Bar
                      Row(
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
                            'Wasifu Wangu',
                            style: KazipoaTheme.headlineSmall.copyWith(
                              color: isDark ? Colors.white : KazipoaTheme.onSurface,
                            ),
                          ),
                          const Spacer(flex: 2),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Profile Header
                      LiquidGlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Profile Picture
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        KazipoaTheme.primaryColor,
                                        KazipoaTheme.secondaryColor,
                                      ],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: KazipoaTheme.primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark 
                                          ? KazipoaTheme.darkSurface
                                          : Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Name and Status
                            Text(
                              'John Doe',
                              style: KazipoaTheme.headlineMedium.copyWith(
                                color: isDark ? Colors.white : KazipoaTheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: KazipoaTheme.tertiaryColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Professional Account',
                                  style: KazipoaTheme.bodyMedium.copyWith(
                                    color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Stats
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatItem('48', 'Miadi', isDark),
                                _buildStatItem('4.8', 'Wakati', isDark),
                                _buildStatItem('250K', 'Mapato', isDark),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Profile Information
                      LiquidGlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Maelezo ya Msingi',
                              style: KazipoaTheme.titleLarge.copyWith(
                                color: isDark ? Colors.white : KazipoaTheme.onSurface,
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Name Field
                            _buildProfileField(
                              'Jina Kamili',
                              _nameController,
                              Icons.person_outline,
                              isDark,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Email Field
                            _buildProfileField(
                              'Barua Pepe',
                              _emailController,
                              Icons.email_outlined,
                              isDark,
                              readOnly: true,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Phone Field
                            _buildProfileField(
                              'Namba ya Simu',
                              _phoneController,
                              Icons.phone_outlined,
                              isDark,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Location Field
                            _buildProfileField(
                              'Mahali',
                              _locationController,
                              Icons.location_on_outlined,
                              isDark,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Bio Section
                      LiquidGlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bio',
                              style: KazipoaTheme.titleLarge.copyWith(
                                color: isDark ? Colors.white : KazipoaTheme.onSurface,
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            TextFormField(
                              controller: _bioController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: 'Eleza zaidi kuhusu wewe...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: isDark 
                                        ? Colors.white24
                                        : KazipoaTheme.onSurfaceVariant.withOpacity(0.3),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: isDark 
                                        ? Colors.white24
                                        : KazipoaTheme.onSurfaceVariant.withOpacity(0.3),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: KazipoaTheme.primaryColor,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              style: KazipoaTheme.bodyMedium.copyWith(
                                color: isDark ? Colors.white : KazipoaTheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Skills Section
                      LiquidGlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ujuzi',
                                  style: KazipoaTheme.titleLarge.copyWith(
                                    color: isDark ? Colors.white : KazipoaTheme.onSurface,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _showAddSkillDialog(isDark);
                                  },
                                  child: Text(
                                    '+ Ongeza',
                                    style: KazipoaTheme.labelMedium.copyWith(
                                      color: KazipoaTheme.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildSkillChip('Hair Styling', isDark),
                                _buildSkillChip('Makeup', isDark),
                                _buildSkillChip('Manicure', isDark),
                                _buildSkillChip('Pedicure', isDark),
                                _buildSkillChip('Facial Treatment', isDark),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Settings Section
                      LiquidGlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mipangilio',
                              style: KazipoaTheme.titleLarge.copyWith(
                                color: isDark ? Colors.white : KazipoaTheme.onSurface,
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            _buildSettingItem(
                              'Arusha',
                              'Notifications',
                              Icons.notifications_outlined,
                              true,
                              (value) {},
                              isDark,
                            ),
                            
                            _buildSettingItem(
                              'Giza',
                              'Dark Mode',
                              Icons.dark_mode_outlined,
                              isDark,
                              (value) {
                                // Toggle theme
                              },
                              isDark,
                            ),
                            
                            _buildSettingItem(
                              'English',
                              'Language',
                              Icons.language_outlined,
                              false,
                              (value) {},
                              isDark,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: LiquidButton.elevated(
                          text: 'Hifadhi Mabadiliko',
                          onPressed: () {
                            _saveProfile();
                          },
                          height: 56,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        child: LiquidButton.outlined(
                          text: 'Toka',
                          onPressed: () {
                            _logout();
                          },
                          height: 56,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: KazipoaTheme.headlineMedium.copyWith(
            color: isDark ? Colors.white : KazipoaTheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: KazipoaTheme.bodySmall.copyWith(
            color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileField(
    String label,
    TextEditingController controller,
    IconData icon,
    bool isDark, {
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: KazipoaTheme.labelLarge.copyWith(
            color: isDark ? Colors.white : KazipoaTheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark 
                    ? Colors.white24
                    : KazipoaTheme.onSurfaceVariant.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark 
                    ? Colors.white24
                    : KazipoaTheme.onSurfaceVariant.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: KazipoaTheme.primaryColor,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: KazipoaTheme.bodyMedium.copyWith(
            color: isDark ? Colors.white : KazipoaTheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillChip(String skill, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: KazipoaTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: KazipoaTheme.primaryColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            skill,
            style: KazipoaTheme.labelMedium.copyWith(
              color: KazipoaTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              // Remove skill
            },
            child: Icon(
              Icons.close,
              size: 16,
              color: KazipoaTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String value,
    String label,
    IconData icon,
    bool isEnabled,
    Function(bool) onChanged,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: KazipoaTheme.bodyMedium.copyWith(
                color: isDark ? Colors.white : KazipoaTheme.onSurface,
              ),
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeColor: KazipoaTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  void _showAddSkillDialog(bool isDark) {
    final skillController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? KazipoaTheme.darkSurface : Colors.white,
        title: Text(
          'Ongeza Ujuzi',
          style: KazipoaTheme.titleLarge.copyWith(
            color: isDark ? Colors.white : KazipoaTheme.onSurface,
          ),
        ),
        content: TextFormField(
          controller: skillController,
          decoration: InputDecoration(
            hintText: 'Ingiza ujuzi wako',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ghairi'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Add skill logic
            },
            child: const Text('Ongeza'),
          ),
        ],
      ),
    );
  }

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wasifu umehifadhiwa!'),
        backgroundColor: KazipoaTheme.successColor,
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Toka'),
        content: const Text('Una uhakika unataka kutoka?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ghairi'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text('Toka'),
          ),
        ],
      ),
    );
  }
}
