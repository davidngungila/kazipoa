import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kazipoa/core/services/auth_manager.dart';
import 'package:kazipoa/core/widgets/video_player_widget.dart';

class KazipoaHome extends StatefulWidget {
  const KazipoaHome({super.key});

  @override
  State<KazipoaHome> createState() => _KazipoaHomeState();
}

class _KazipoaHomeState extends State<KazipoaHome> with WidgetsBindingObserver {
  int _videoKey = 0; // Use a simple int key to force rebuild
  final bool _isPageVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Add a small delay to ensure video restarts when page becomes fully visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restartVideo();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && _isPageVisible) {
      // Restart video when app comes to foreground and page is visible
      _restartVideo();
    }
  }

  @override
  void didUpdateWidget(KazipoaHome oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Restart video when widget is updated (navigation back to page)
    _restartVideo();
  }

  void _restartVideo() {
    if (!mounted) return;
    // Force rebuild of the video widget by changing its key
    setState(() {
      _videoKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Stack(
        children: [
          /// 🔥 Background Video
          Positioned.fill(
            child: Opacity(
              opacity: 0.7,
              child: VideoPlayerWidget(
                key: ValueKey('video_$_videoKey'),
                videoPath: 'assets/videos.webm/index_enhanced_new_background.mp4',
                isMuted: true,
                autoPlay: true,
                loop: true,
              ),
            ),
          ),

          /// 🔥 Dark Overlay Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.4),
                    Colors.black.withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          /// 🔥 Main Content
          SafeArea(
            child: Column(
              children: [
                /// 🔝 Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              "https://lh3.googleusercontent.com/aida-public/AB6AXuBT1J9LykOpxqLecYB_F83xh5KrD6CpPuyxhl8mGRs3jz5crhxIVdipTPYJ24xAgpzDgsYmnrKHJYFBtXzUCZ4LlHR0YaHe1zzXiVuXlb2dtqgoIvHizvmD4Iqj9xH618njMTF9KxZCMHwVUmRHQ6EwNzT3UuCvC1GxCzAHWEg63d04TFj9vN1U335LYNR_Xwb7BMBMECnUwfaikqsiKOd7Zv-ubOx74ny2kRarWQp4rgDVQa9zkYDpaVve2UWkKjphDY2dkN7zoQk",
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Kazipoa",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          // GUEST FLOW: Navigate to landing page as guest
                          context.go('/guest');
                        },
                        child: _glassButton("Ruka"),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                /// 🔥 Hero Section
                Column(
                  children: const [
                    Text(
                      "Karibu Kazipoa",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        letterSpacing: 3,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Huduma kiganjani",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                /// 🔥 Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            // CLIENT FLOW: Set role and navigate to client registration
                            AuthManager().switchRole('client');
                            context.go('/register');
                          },
                          child: _roleCard(
                            icon: Icons.search,
                            title: "Kupata Huduma",
                            desc:
                                "Natafuta mtaalamu wa kufanya kazi yangu sasa hivi.",
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            // PRO FLOW: Set role and navigate to pro login
                            final authManager = AuthManager();
                            authManager.switchRole('pro');
                            context.go('/pro_login');
                          },
                          child: _roleCard(
                            icon: Icons.work,
                            title: "Kutoa Huduma",
                            desc:
                                "Mimi ni mtaalamu na nahitaji kuongeza kipato changu.",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔥 CTA Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                        HapticFeedback.heavyImpact();
                        // GUEST FLOW: Navigate to landing page as guest
                        context.go('/guest');
                      },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFE2E8F0),
                            Colors.white,
                            Color(0xFFCBD5E1),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Ruka",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔻 Footer
                const Text(
                  "Tayari una akaunti?",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Glass Button
  Widget _glassButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 🔹 Role Card
  Widget _roleCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            desc,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
