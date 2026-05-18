import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';

class ClientsChatsOverviewEnhanced extends StatefulWidget {
  const ClientsChatsOverviewEnhanced({super.key});

  static const primary = Color(0xFF00D2FF);

  @override
  State<ClientsChatsOverviewEnhanced> createState() => _ClientsChatsOverviewEnhancedState();
}

class _ClientsChatsOverviewEnhancedState extends State<ClientsChatsOverviewEnhanced> {
  final TextEditingController _searchController = TextEditingController();
  
  // Filter states
  bool _showUnreadOnly = false;
  bool _showActiveJobsOnly = false;
  String? _selectedServiceCategory;
  String? _selectedDateFilter;
  
  // Menu states
  bool _showFilterMenu = false;
  bool _showFabMenu = false;
  bool _showSettingsMenu = false;

  // Sample data
  final List<Map<String, dynamic>> _allChats = [
    {
      'name': "Juma Hamisi",
      'message': "Vipi kaka, ile kazi ya plumbing tayari?",
      'time': "10:42 AM",
      'unread': 2,
      'active': true,
      'serviceCategory': 'Plumbing',
      'date': DateTime.now(),
    },
    {
      'name': "Sarah Mpole", 
      'message': "Asante sana kwa huduma nzuri jana!",
      'time': "09:15 AM",
      'unread': 0,
      'active': false,
      'serviceCategory': 'Cleaning',
      'date': DateTime.now().subtract(Duration(hours: 3)),
    },
    {
      'name': "Kikosi Kazi Dar",
      'message': "Beka: Nimefika tayari hapa site.",
      'time': "Jana",
      'unread': 0,
      'active': true,
      'serviceCategory': 'Construction',
      'date': DateTime.now().subtract(Duration(days: 1)),
    },
  ];

  List<Map<String, dynamic>> get _filteredChats {
    var filtered = List<Map<String, dynamic>>.from(_allChats);
    
    if (_showUnreadOnly) {
      filtered = filtered.where((chat) => (chat['unread'] as int) > 0).toList();
    }
    
    if (_showActiveJobsOnly) {
      filtered = filtered.where((chat) => chat['active'] as bool).toList();
    }
    
    if (_selectedServiceCategory != null) {
      filtered = filtered.where((chat) => chat['serviceCategory'] == _selectedServiceCategory).toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _backgroundGlow(),

          SafeArea(
            child: Column(
              children: [
                _topBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _header(),
                      const SizedBox(height: 16),
                      _searchBar(),
                      _filterMenu(),
                      const SizedBox(height: 16),

                      // Display filtered chats or empty state
                      ...(_filteredChats.isEmpty 
                        ? [_emptyState()]
                        : _filteredChats.map((chat) => _chatTile(
                            name: chat['name'],
                            message: chat['message'],
                            time: chat['time'],
                            unread: chat['unread'] ?? 0,
                            active: chat['active'] ?? false,
                          )).toList()
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Navigation
          CustomBottomNavigation(
            currentRoute: '/chat',
            screenWidth: screenWidth,
          ),
          
          // Settings Menu
          _buildSettingsMenu(),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  // ================= TOP BAR =================
  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Official Kazipoa Logo - Navigates to Home
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.go('/home');
                  },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ClientsChatsOverviewEnhanced.primary.withOpacity(0.3),
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/official logo.jpeg',
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to icon if image fails to load
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.work,
                                color: Color(0xFF00D1FF), // Light blue color
                                size: 14,
                                weight: 700,
                              ),
                              SizedBox(height: 1),
                              Text(
                                'KZ',
                                style: TextStyle(
                                  color: Color(0xFFFFD700), // Yellow color
                                  fontSize: 7,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              ),
              const SizedBox(width: 10),
              const Text(
                "KAZIPOA",
                style: TextStyle(
                  color: ClientsChatsOverviewEnhanced.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _showSettingsMenu = !_showSettingsMenu;
                _showFilterMenu = false;
                _showFabMenu = false;
              });
            },
            child: const Icon(Icons.settings, color: ClientsChatsOverviewEnhanced.primary),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Chat",
          style: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w900,
            color: Color(0xFF00D2FF),
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "5 NEW MESSAGES",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: 5,
          decoration: BoxDecoration(
            color: ClientsChatsOverviewEnhanced.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x5500D2FF),
                blurRadius: 10,
              )
            ],
          ),
        ),
      ],
    );
  }

  // ================= SEARCH =================
  Widget _searchBar() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                icon: Icon(Icons.search, color: Colors.white54),
                hintText: "Tafuta mazungumzo...",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {}); // Trigger rebuild for search
              },
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              _showFilterMenu = !_showFilterMenu;
              _showFabMenu = false;
              _showSettingsMenu = false;
            });
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _showFilterMenu ? ClientsChatsOverviewEnhanced.primary.withOpacity(0.2) : Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _showFilterMenu ? ClientsChatsOverviewEnhanced.primary : Colors.white10,
                width: _showFilterMenu ? 2 : 1,
              ),
            ),
            child: Icon(
              Icons.tune, 
              color: _showFilterMenu ? ClientsChatsOverviewEnhanced.primary : ClientsChatsOverviewEnhanced.primary,
            ),
          ),
        ),
      ],
    );
  }

  // ================= FILTER MENU =================
  Widget _filterMenu() {
    if (!_showFilterMenu) return SizedBox.shrink();
    
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chagua Vichungi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          
          // Unread filter
          _filterOption(
            title: 'Mazungumzo Yasiyosomwa',
            icon: Icons.mark_email_unread,
            isSelected: _showUnreadOnly,
            onTap: () {
              setState(() {
                _showUnreadOnly = !_showUnreadOnly;
              });
            },
          ),
          
          // Active jobs filter
          _filterOption(
            title: 'Kazi Zilizoendelea',
            icon: Icons.work,
            isSelected: _showActiveJobsOnly,
            onTap: () {
              setState(() {
                _showActiveJobsOnly = !_showActiveJobsOnly;
              });
            },
          ),
          
          // Service category filter
          _filterOption(
            title: 'Aina ya Huduma',
            icon: Icons.category,
            isSelected: _selectedServiceCategory != null,
            onTap: () => _showServiceCategoryDialog(),
          ),
          
          // Date filter
          _filterOption(
            title: 'Tarehe',
            icon: Icons.calendar_today,
            isSelected: _selectedDateFilter != null,
            onTap: () => _showDateFilterDialog(),
          ),
        ],
      ),
    );
  }

  Widget _filterOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected 
            ? ClientsChatsOverviewEnhanced.primary.withOpacity(0.2)
            : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
              ? ClientsChatsOverviewEnhanced.primary.withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected 
                ? ClientsChatsOverviewEnhanced.primary
                : Colors.white.withOpacity(0.7),
              size: 20,
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: isSelected 
                  ? ClientsChatsOverviewEnhanced.primary
                  : Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Spacer(),
            if (isSelected)
              Icon(
                Icons.check,
                color: ClientsChatsOverviewEnhanced.primary,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  void _showServiceCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Chagua Aina ya Huduma',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Plumbing',
            'Cleaning',
            'Construction',
            'Electrical',
            'Painting',
          ].map((category) => RadioListTile<String>(
            title: Text(category, style: TextStyle(color: Colors.white)),
            value: category,
            groupValue: _selectedServiceCategory,
            onChanged: (value) {
              setState(() {
                _selectedServiceCategory = value;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedServiceCategory = null;
              });
              Navigator.pop(context);
            },
            child: Text('Safisha', style: TextStyle(color: ClientsChatsOverviewEnhanced.primary)),
          ),
        ],
      ),
    );
  }

  void _showDateFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Chagua Tarehe',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Leo',
            'Jana',
            'Wiki Hii',
            'Mwezi Hii',
          ].map((dateFilter) => RadioListTile<String>(
            title: Text(dateFilter, style: TextStyle(color: Colors.white)),
            value: dateFilter,
            groupValue: _selectedDateFilter,
            onChanged: (value) {
              setState(() {
                _selectedDateFilter = value;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedDateFilter = null;
              });
              Navigator.pop(context);
            },
            child: Text('Safisha', style: TextStyle(color: ClientsChatsOverviewEnhanced.primary)),
          ),
        ],
      ),
    );
  }

  // ================= FAB MENU =================
  Widget _buildFab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // FAB Menu Items
        if (_showFabMenu) ...[
          _fabMenuItem(
            icon: Icons.chat,
            label: 'Anza Mazungumzo Mpya',
            onTap: () {
              setState(() {
                _showFabMenu = false;
              });
              // Navigate to new chat screen
              context.go('/chat/new');
            },
          ),
          SizedBox(height: 12),
          _fabMenuItem(
            icon: Icons.work,
            label: 'Tengeneza Ombi la Kazi',
            onTap: () {
              setState(() {
                _showFabMenu = false;
              });
              // Navigate to booking form
              context.go('/booking/new');
            },
          ),
          SizedBox(height: 12),
          _fabMenuItem(
            icon: Icons.upload_file,
            label: 'Pakia Faili/Photo',
            onTap: () {
              setState(() {
                _showFabMenu = false;
              });
              // Open file picker
              _showFilePicker();
            },
          ),
          SizedBox(height: 12),
        ],
        
        // Main FAB Button
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _showFabMenu = !_showFabMenu;
              _showFilterMenu = false;
              _showSettingsMenu = false;
            });
          },
          backgroundColor: _showFabMenu 
            ? ClientsChatsOverviewEnhanced.primary.withOpacity(0.8)
            : ClientsChatsOverviewEnhanced.primary,
          child: Icon(
            _showFabMenu ? Icons.close : Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _fabMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 8),
          SizedBox(
            width: 48,
            height: 48,
            child: FloatingActionButton(
              onPressed: onTap,
              backgroundColor: Colors.white,
              child: Icon(icon, color: ClientsChatsOverviewEnhanced.primary, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilePicker() {
    // Show file picker options
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Chagua Chanzo',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: ClientsChatsOverviewEnhanced.primary),
              title: Text('Piga Picha', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // Open camera
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Kamera itafunguliwa...')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: ClientsChatsOverviewEnhanced.primary),
              title: Text('Chagua kutoka Galari', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // Open gallery
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Galari itafunguliwa...')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_file, color: ClientsChatsOverviewEnhanced.primary),
              title: Text('Chagua Faili', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // Open file picker
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Kiteua faili...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ================= SETTINGS MENU =================
  Widget _buildSettingsMenu() {
    if (!_showSettingsMenu) return SizedBox.shrink();
    
    return Positioned(
      top: 80,
      right: 16,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ClientsChatsOverviewEnhanced.primary.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.settings, color: ClientsChatsOverviewEnhanced.primary),
                  SizedBox(width: 12),
                  Text(
                    'Mipangilio na Mapendeleo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Profile Management
            _settingsSection(
              title: 'Usimamizi wa Wasifu',
              items: [
                _settingsItem(
                  icon: Icons.person,
                  label: 'Hariri Jina, Picha, Mawasiliano',
                  onTap: () => _editProfile(),
                ),
              ],
            ),
            
            // App Settings
            _settingsSection(
              title: 'Mipangilio ya Programu',
              items: [
                _settingsItem(
                  icon: Icons.language,
                  label: 'Lugha',
                  onTap: () => _showLanguageSettings(),
                ),
                _settingsItem(
                  icon: Icons.notifications,
                  label: 'Arifa',
                  onTap: () => _showNotificationSettings(),
                ),
                _settingsItem(
                  icon: Icons.lock,
                  label: 'Faragha',
                  onTap: () => _showPrivacySettings(),
                ),
                _settingsItem(
                  icon: Icons.palette,
                  label: 'Mandharinyuma',
                  onTap: () => _showThemeSettings(),
                ),
              ],
            ),
            
            // Chat Options
            _settingsSection(
              title: 'Chaguo za Mazungumzo',
              items: [
                _settingsItem(
                  icon: Icons.chat,
                  label: 'Mipangilio ya Mazungumzo',
                  onTap: () => _showChatSettings(),
                ),
                _settingsItem(
                  icon: Icons.key,
                  label: 'Ufunguo wa Msaada',
                  onTap: () => _showHelpKey(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _settingsItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white.withOpacity(0.7), size: 20),
      title: Text(
        label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 14,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3), size: 16),
      onTap: () {
        setState(() {
          _showSettingsMenu = false;
        });
        onTap();
      },
    );
  }

  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kufungua ukurasa wa kuhariri wasifu...')),
    );
  }

  void _showLanguageSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Lugha', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('Kiswahili', style: TextStyle(color: Colors.white)),
              value: 'sw',
              groupValue: 'sw',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: Text('English', style: TextStyle(color: Colors.white)),
              value: 'en',
              groupValue: 'sw',
              onChanged: (value) => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kufungua mipangilio ya arifa...')),
    );
  }

  void _showPrivacySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kufungua mipangilio ya faragha...')),
    );
  }

  void _showThemeSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Mandharinyuma', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('Giza', style: TextStyle(color: Colors.white)),
              value: 'dark',
              groupValue: 'dark',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: Text('Mwanga', style: TextStyle(color: Colors.white)),
              value: 'light',
              groupValue: 'dark',
              onChanged: (value) => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showChatSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kufungua mipangilio ya mazungumzo...')),
    );
  }

  void _showHelpKey() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Ufunguo wa Msaada', style: TextStyle(color: Colors.white)),
        content: Text(
          'Hii ni sehemu ya msaada inayotoa maelezo ya jinsi ya kutumia programu ya Kazipoa.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Sawa', style: TextStyle(color: ClientsChatsOverviewEnhanced.primary)),
          ),
        ],
      ),
    );
  }

  // ================= EMPTY STATE =================
  Widget _emptyState() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.chat_bubble_outline,
            color: Colors.white.withOpacity(0.3),
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'Hakuna matata',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Hakuna mazungumzo yanayolingana na vichungi vyako',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ================= CHAT TILE =================
  Widget _chatTile({
    required String name,
    required String message,
    required String time,
    int unread = 0,
    bool active = false,
    bool isGroup = false,
    bool isPlatinum = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey.shade900,
                child: Icon(
                  isGroup ? Icons.groups : Icons.person,
                  color: Colors.white54,
                ),
              ),
              if (active)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (isPlatinum)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: ClientsChatsOverviewEnhanced.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: ClientsChatsOverviewEnhanced.primary.withOpacity(0.3)),
                    ),
                    child: const Text(
                      "PLATINUM",
                      style: TextStyle(
                        color: ClientsChatsOverviewEnhanced.primary,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Column(
            children: [
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 6),
              if (unread > 0)
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: ClientsChatsOverviewEnhanced.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "$unread",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }

  
  // ================= BACKGROUND =================
  Widget _backgroundGlow() {
    return Stack(
      children: [
        Positioned(
          top: 120,
          left: -100,
          child: _glow(),
        ),
        Positioned(
          bottom: 120,
          right: -100,
          child: _glow(),
        ),
      ],
    );
  }

  Widget _glow() {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        color: ClientsChatsOverviewEnhanced.primary.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
    );
  }
}