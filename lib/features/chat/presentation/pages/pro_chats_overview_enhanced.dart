import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ProChatsOverviewEnhanced extends StatefulWidget {
  const ProChatsOverviewEnhanced({super.key});

  @override
  State<ProChatsOverviewEnhanced> createState() => _ProChatsOverviewEnhancedState();
}

class _ProChatsOverviewEnhancedState extends State<ProChatsOverviewEnhanced>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive calculations
    final padding = screenWidth * 0.04;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [
              Color(0x1400F0FF),
              Colors.transparent,
            ],
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.5,
              colors: [
                Color(0x0D6366F1),
                Colors.transparent,
              ],
            ),
          ),
          child: SafeArea(
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
                        // Search Bar
                        _buildSearchBar(),
                        
                        const SizedBox(height: 24),
                        
                        // Chat Items
                        _buildChatItems(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
          );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF334155).withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Back Button to Dashboard
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.go('/wasifu/pro_dashboard');
                },
                child: const Text(
                  '<',
                  style: TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Title and Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kazipoa',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  
                  const SizedBox(height: 2),
                  
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00F0FF),
                          shape: BoxShape.circle,
                        ),
                      ),
                      
                      const SizedBox(width: 4),
                      
                      const Text(
                        'Platinum Network',
                        style: TextStyle(
                          color: Color(0xFF00F0FF),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          
          // Action Icons
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  // TODO: Search
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  // TODO: More options
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 16),
      child: TextField(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Search conversations...',
          hintStyle: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF94A3B8),
            size: 24,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: const Color(0xFF334155),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: const Color(0xFF334155),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF00F0FF),
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildChatItems() {
    final chatItems = [
      {
        'name': 'Alex Rivers',
        'message': 'The frosted glass effect looks amazing! Check the new build.',
        'time': 'JUST NOW',
        'badge': '2',
        'isActive': true,
        'hasPlatinumBadge': false,
      },
      {
        'name': 'Design Team',
        'message': 'Meeting at 3 PM today. Don\'t forget the assets.',
        'time': '15m ago',
        'badge': null,
        'isActive': false,
        'hasPlatinumBadge': false,
      },
      {
        'name': 'Marcus Sterling',
        'message': 'The quarterly report looks solid. Ready for signoff.',
        'time': '2h ago',
        'badge': null,
        'isActive': false,
        'hasPlatinumBadge': true,
      },
      {
        'name': 'Sarah Chen',
        'message': 'Sent you the latest prototypes for the mobile app.',
        'time': 'Yesterday',
        'badge': null,
        'isActive': false,
        'hasPlatinumBadge': false,
      },
    ];

    return Column(
      children: chatItems.map((chat) {
        return _buildChatItem(chat);
      }).toList(),
    );
  }

  Widget _buildChatItem(Map<String, dynamic> chat) {
    final isActive = chat['isActive'] as bool;
    final hasPlatinumBadge = chat['hasPlatinumBadge'] as bool;
    final badge = chat['badge'] as String?;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 24,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF334155),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    color: Colors.grey.withOpacity(0.3),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
              
              // Online Indicator (for active chat)
              if (isActive)
                Positioned(
                  bottom: -4,
                  right: -4,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00F0FF),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(width: 16),
          
          // Chat Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      chat['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    
                    Text(
                      chat['time'] as String,
                      style: TextStyle(
                        color: isActive 
                            ? const Color(0xFF00F0FF)
                            : const Color(0xFF94A3B8),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                // Message
                Text(
                  chat['message'] as String,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Badge or Platinum Badge
          if (badge != null)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFF00F0FF),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          else if (hasPlatinumBadge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE2E8F0), Colors.white, Color(0xFF94A3B8)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Platinum',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            )
          else
            const SizedBox(width: 20),
        ],
      ),
    );
  }

  }
