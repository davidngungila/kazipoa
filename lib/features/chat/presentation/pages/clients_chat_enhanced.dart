import 'package:flutter/material.dart';

class ClientsChatEnhanced extends StatefulWidget {
  const ClientsChatEnhanced({super.key});

  @override
  State<ClientsChatEnhanced> createState() => _ClientsChatEnhancedState();
}

class _ClientsChatEnhancedState extends State<ClientsChatEnhanced> {
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'text': 'Habari! Nimepokea ombi lako la kazi ya mabomba. Nina uhakika nitakufanikisha.',
      'time': '10:30 AM',
      'isSent': false,
      'sender': 'Bakari Said',
    },
    {
      'id': '2',
      'text': 'Asante Bakari! Nina tatizo la bomba la maji jikoni. Unaweza kuja leo?',
      'time': '10:35 AM',
      'isSent': true,
      'sender': 'Me',
    },
    {
      'id': '3',
      'text': 'Ndiyo, niko tayari kuanza kazi yako. Nitafika kwa dakika 15. Eneo lako wapi?',
      'time': '10:40 AM',
      'isSent': false,
      'sender': 'Bakari Said',
    },
    {
      'id': '4',
      'text': 'Niko Masaki karibu na shule ya primary.',
      'time': '10:42 AM',
      'isSent': true,
      'sender': 'Me',
    },
    {
      'id': '5',
      'text': 'Sawa nimepata eneo. Bei ni TZS 25,000 kwa ukarabati.',
      'time': '10:45 AM',
      'isSent': false,
      'sender': 'Bakari Said',
    },
    {
      'id': '6',
      'text': 'Sawa, bei ni sawa. Tuonane kazi.',
      'time': '10:46 AM',
      'isSent': true,
      'sender': 'Me',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Scroll to bottom when messages are added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'id': (_messages.length + 1).toString(),
          'text': _messageController.text.trim(),
          'time': '10:48 AM',
          'isSent': true,
          'sender': 'Me',
        });
      });
      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Animated Background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.2, 0.2),
                radius: 1.5,
                colors: [
                  Color(0x2E38BDF8),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.8, 0.4),
                radius: 1.5,
                colors: [
                  Color(0x1F0EA5E9),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.5, 0.8),
                radius: 1.5,
                colors: [
                  Color(0x147DD3FC),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          
          // Main Content
          Column(
            children: [
              // Header
              _buildHeader(screenWidth),
              
              // Chat Messages
              Expanded(
                child: _buildChatMessages(screenWidth, screenHeight),
              ),
              
              // Footer with Input
              _buildFooter(screenWidth),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF7DD3FC).withOpacity(0.12),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Section - User Info
          Row(
            children: [
              // Avatar
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF7DD3FC).withOpacity(0.2),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    color: Colors.grey.withOpacity(0.3),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF7DD3FC),
                      size: 24,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 14),
              
              // Name and Role
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bakari Said',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xFF7DD3FC),
                    ),
                  ),
                  Text(
                    'Mtaalamu wa Mabomba',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF7DD3FC).withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Right Section - Icons
          Row(
            children: [
              _buildHeaderIcon('Phone'),
              const SizedBox(width: 10),
              _buildHeaderIcon('Video'),
              const SizedBox(width: 10),
              _buildHeaderIcon('Info'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(String iconType) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF7DD3FC).withOpacity(0.08),
        border: Border.all(
          color: const Color(0xFF7DD3FC).withOpacity(0.12),
        ),
      ),
      child: Center(
        child: Text(
          iconType == 'Phone' ? 'Phone' : 
          iconType == 'Video' ? 'Video' : 'Info',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF7DD3FC),
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessages(double screenWidth, double screenHeight) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      itemCount: _messages.length + 1, // +1 for day divider
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildDayDivider();
        }
        
        final messageIndex = index - 1;
        final message = _messages[messageIndex];
        final isSent = message['isSent'] as bool;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isSent) ...[
                // Avatar for received messages
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF7DD3FC).withOpacity(0.2),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: Colors.grey.withOpacity(0.3),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFF7DD3FC),
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
              
              // Message Column
              Column(
                crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Message Bubble
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth * 0.72,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSent ? const Color(0xFF38BDF8) : Colors.white.withOpacity(0.03),
                      border: isSent 
                          ? null
                          : Border.all(
                              color: const Color(0xFF7DD3FC).withOpacity(0.14),
                            ),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(22),
                        topRight: const Radius.circular(22),
                        bottomLeft: isSent ? const Radius.circular(22) : const Radius.circular(6),
                        bottomRight: isSent ? const Radius.circular(6) : const Radius.circular(22),
                      ),
                    ),
                    child: Text(
                      message['text'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: isSent ? Colors.black : const Color(0xFFBAE6FD),
                        fontWeight: isSent ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ),
                  
                  // Time
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    child: Text(
                      message['time'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: const Color(0xFF7DD3FC).withOpacity(0.65),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDayDivider() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        'Leo',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: const Color(0xFF7DD3FC).withOpacity(0.75),
        ),
      ),
    );
  }

  Widget _buildFooter(double screenWidth) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF7DD3FC).withOpacity(0.12),
          ),
        ),
      ),
      child: Row(
        children: [
          // Input Field
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(
                color: Color(0xFF7DD3FC),
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Andika ujumbe...',
                hintStyle: const TextStyle(
                  color: Color(0xFF38BDF8),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide(
                    color: const Color(0xFF7DD3FC).withOpacity(0.12),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide(
                    color: const Color(0xFF7DD3FC).withOpacity(0.12),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: const BorderSide(
                    color: Color(0xFF7DD3FC),
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.04),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Send Button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: Color(0xFF38BDF8),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'Send',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
