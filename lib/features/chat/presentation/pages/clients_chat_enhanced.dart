import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientsChatEnhanced extends StatefulWidget {
  final String chatId;
  const ClientsChatEnhanced({super.key, required this.chatId});

  @override
  State<ClientsChatEnhanced> createState() => _ClientsChatEnhancedState();
}

class _ClientsChatEnhancedState extends State<ClientsChatEnhanced> {
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  String _partnerName = 'Mtumiaji';
  String _partnerRole = 'Mtaalamu';
  String? _currentUserId;
  RealtimeChannel? _realtimeSubscription;

  @override
  void initState() {
    super.initState();
    _currentUserId = Supabase.instance.client.auth.currentUser?.id;
    _loadChatDetails();
    _subscribeToMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    if (_realtimeSubscription != null) {
      Supabase.instance.client.removeChannel(_realtimeSubscription!);
    }
    super.dispose();
  }

  Future<void> _loadChatDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final client = Supabase.instance.client;

      // 1. Fetch conversation details to find the partner name & role
      final conv = await client
          .from('conversations')
          .select('*, clients:client_id(name), pros:pro_id(*, profiles:id(name))')
          .eq('id', widget.chatId)
          .single();

      final clientObj = conv['clients'] as Map<dynamic, dynamic>?;
      final proObj = conv['pros'] as Map<dynamic, dynamic>?;
      final proProfile = proObj != null ? proObj['profiles'] as Map<dynamic, dynamic>? : null;

      final isProUser = _currentUserId == conv['pro_id'];

      if (isProUser) {
        _partnerName = clientObj != null ? clientObj['name']?.toString() ?? 'Mteja' : 'Mteja';
        _partnerRole = 'Mteja';
      } else {
        _partnerName = proProfile != null ? proProfile['name']?.toString() ?? 'Mtaalamu' : 'Mtaalamu';
        _partnerRole = proObj != null ? proObj['category']?.toString() ?? 'Mtaalamu' : 'Mtaalamu';
      }

      // 2. Load historical messages
      final msgsResponse = await client
          .from('messages')
          .select()
          .eq('conversation_id', widget.chatId)
          .order('created_at', ascending: true);

      final List<dynamic> rawMsgs = msgsResponse as List<dynamic>;
      _messages = rawMsgs.map((e) => Map<String, dynamic>.from(e)).toList();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      debugPrint('Failed to load chat details: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _subscribeToMessages() {
    final client = Supabase.instance.client;
    
    _realtimeSubscription = client
        .channel('public:messages:conversation_id=eq.${widget.chatId}')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: widget.chatId,
          ),
          callback: (payload) {
            final newRecord = payload.newRecord;
            if (newRecord.isNotEmpty) {
              final parsedMsg = Map<String, dynamic>.from(newRecord);
              if (!_messages.any((m) => m['id'] == parsedMsg['id'])) {
                setState(() {
                  _messages.add(parsedMsg);
                });
                _scrollToBottom();
              }
            }
          },
        )
        .subscribe();
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

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _currentUserId == null) return;

    _messageController.clear();

    try {
      final client = Supabase.instance.client;

      // Optimistically append local message (or let realtime subscription handle it)
      // Writing to table: conversation_id, sender_id, text
      await client.from('messages').insert({
        'conversation_id': widget.chatId,
        'sender_id': _currentUserId,
        'text': text,
      });

      _scrollToBottom();
    } catch (e) {
      debugPrint('Failed to send message: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ujumbe haukutwa: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  String _formatTime(String? createdAtStr) {
    if (createdAtStr == null) return '';
    try {
      final parsed = DateTime.parse(createdAtStr).toLocal();
      final minuteStr = parsed.minute.toString().padLeft(2, '0');
      final hourStr = parsed.hour.toString().padLeft(2, '0');
      return '$hourStr:$minuteStr';
    } catch (e) {
      return '';
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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8)))
                    : _buildChatMessages(screenWidth, screenHeight),
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
        color: Colors.white.withValues(alpha: 0.03),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF7DD3FC).withValues(alpha: 0.12),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Section - User Info
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF7DD3FC),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Avatar
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF7DD3FC).withValues(alpha: 0.2),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    color: Colors.grey.withValues(alpha: 0.3),
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
                  Text(
                    _partnerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xFF7DD3FC),
                    ),
                  ),
                  Text(
                    _partnerRole,
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF7DD3FC).withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Right Section - Call Icons
          Row(
            children: [
              _buildHeaderIcon(Icons.phone),
              const SizedBox(width: 10),
              _buildHeaderIcon(Icons.videocam),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF7DD3FC).withValues(alpha: 0.08),
        border: Border.all(
          color: const Color(0xFF7DD3FC).withValues(alpha: 0.12),
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 18,
          color: const Color(0xFF7DD3FC),
        ),
      ),
    );
  }

  Widget _buildChatMessages(double screenWidth, double screenHeight) {
    if (_messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.forum_outlined, size: 48, color: Colors.white.withValues(alpha: 0.2)),
            const SizedBox(height: 12),
            Text(
              "Hakuna ujumbe bado.\nAnza mazungumzo!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isSent = message['sender_id'] == _currentUserId;
        
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
                      color: const Color(0xFF7DD3FC).withValues(alpha: 0.2),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: Colors.grey.withValues(alpha: 0.3),
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
                      color: isSent ? const Color(0xFF38BDF8) : Colors.white.withValues(alpha: 0.03),
                      border: isSent 
                          ? null
                          : Border.all(
                              color: const Color(0xFF7DD3FC).withValues(alpha: 0.14),
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
                      _formatTime(message['created_at']),
                      style: TextStyle(
                        fontSize: 11,
                        color: const Color(0xFF7DD3FC).withValues(alpha: 0.65),
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

  Widget _buildFooter(double screenWidth) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF7DD3FC).withValues(alpha: 0.12),
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
                    color: const Color(0xFF7DD3FC).withValues(alpha: 0.12),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide(
                    color: const Color(0xFF7DD3FC).withValues(alpha: 0.12),
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
                fillColor: Colors.white.withValues(alpha: 0.04),
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
              child: const Icon(
                Icons.send,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
