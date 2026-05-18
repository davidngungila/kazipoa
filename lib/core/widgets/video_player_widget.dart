import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final bool isMuted;
  final bool autoPlay;
  final bool loop;
  final String? fallbackVideoUrl;

  const VideoPlayerWidget({
    super.key,
    required this.videoPath,
    this.isMuted = true,
    this.autoPlay = true,
    this.loop = true,
    this.fallbackVideoUrl,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  // Add restartVideo method for external access
  void restartVideo() {
    if (_isInitialized && _controller.value.isInitialized) {
      _controller.seekTo(Duration.zero);
      _controller.play();
    } else {
      _initializeVideo();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeVideo();
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && _isInitialized) {
      // Resume playing when app comes to foreground
      _controller.play();
    } else if (state == AppLifecycleState.paused && _isInitialized) {
      // Keep playing even when app is paused (in background)
      _controller.play();
    }
  }

  void _initializeVideo() async {
    try {
      // First try the original MP4 file (for both web and mobile)
      _controller = VideoPlayerController.asset(widget.videoPath);
      
      await _controller.initialize().timeout(
        Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Video initialization timed out');
        },
      );
      
      _setupVideoController();
      
    } catch (e) {
      // Try fallback videos if original fails
      await _tryFallbackVideos();
    }
  }

  Future<void> _tryFallbackVideos() async {
    // Use only proven working video sources
    final workingVideos = [
      'https://www.w3schools.com/html/mov_bbb.mp4',
      'https://sample-videos.com/video321/mp4/240/big_buck_bunny_240p_1mb.mp4',
    ];

    // Try custom fallback URL first if provided
    if (widget.fallbackVideoUrl != null) {
      try {
        _controller = VideoPlayerController.networkUrl(Uri.parse(widget.fallbackVideoUrl!));
        
        await _controller.initialize().timeout(
          Duration(seconds: 5),
          onTimeout: () {
            throw TimeoutException('Custom fallback video timed out');
          },
        );
        
        _setupVideoController();
        return;
        
      } catch (e) {
        await _controller.dispose();
      }
    }

    // Try working videos
    for (final videoUrl in workingVideos) {
      try {
        _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
        
        await _controller.initialize().timeout(
          Duration(seconds: 5),
          onTimeout: () {
            throw TimeoutException('Working video timed out');
          },
        );
        
        _setupVideoController();
        return;
        
      } catch (e) {
        await _controller.dispose();
      }
    }
    
    // Show fallback UI if all videos fail
    setState(() {
      _isInitialized = false;
    });
  }

  void _setupVideoController() {
    _controller.setVolume(0.0);
    if (widget.loop) {
      _controller.setLooping(true);
    }
    
    setState(() {
      _isInitialized = true;
    });
    
    _attemptAutoPlay();
    _controller.addListener(_videoListener);
  }

  void _attemptAutoPlay() {
    if (_controller.value.isInitialized && !_controller.value.isPlaying) {
      try {
        _controller.play();
      } catch (e) {
        // Silent fail for auto-play issues
      }
    }
  }

  void _videoListener() {
    if (!_controller.value.isInitialized) return;
    
    // Restart video if it ends and not looping
    if (_controller.value.position >= _controller.value.duration && !widget.loop) {
      _controller.seekTo(Duration.zero);
      _controller.play();
    }
    
    // Only retry if video is not playing AND not at the end AND not buffering
    if (!_controller.value.isPlaying && 
        _controller.value.isInitialized && 
        _controller.value.position < _controller.value.duration &&
        !_controller.value.isBuffering) {
      Future.delayed(Duration(milliseconds: 2000), () => _attemptAutoPlay());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      // Show enhanced fallback UI while video is loading or if it fails
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF38BDF8).withOpacity(0.3),
              const Color(0xFF1E40AF).withOpacity(0.2),
              Colors.grey.withOpacity(0.4),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: CustomPaint(
                painter: _DottedPatternPainter(),
              ),
            ),
            // Service icon and animation
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder(
                    duration: Duration(milliseconds: 2000),
                    tween: Tween<double>(begin: 0.8, end: 1.2),
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        _getServiceIcon(widget.videoPath),
                        color: Colors.white.withOpacity(0.9),
                        size: 28,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _getServiceNameFromPath(widget.videoPath),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Preview Available',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 7,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: _controller.value.size.width,
        height: _controller.value.size.height,
        child: VideoPlayer(_controller),
      ),
    );
  }


  String _getServiceNameFromPath(String videoPath) {
    // Extract service name from video path
    final fileName = videoPath.split('/').last;
    final serviceName = fileName.replaceAll('.mp4', '').replaceAll('_', ' ');
    return serviceName;
  }

  IconData _getServiceIcon(String videoPath) {
    final serviceName = _getServiceNameFromPath(videoPath).toLowerCase();
    
    if (serviceName.contains('car') || serviceName.contains('wash')) {
      return Icons.local_car_wash;
    } else if (serviceName.contains('laundry')) {
      return Icons.local_laundry_service;
    } else if (serviceName.contains('hair') || serviceName.contains('stylist')) {
      return Icons.content_cut;
    } else if (serviceName.contains('makeup') || serviceName.contains('artist')) {
      return Icons.face;
    } else if (serviceName.contains('fundi') || serviceName.contains('umeme')) {
      return Icons.electrical_services;
    } else if (serviceName.contains('cherehani')) {
      return Icons.design_services;
    } else if (serviceName.contains('tatto')) {
      return Icons.brush;
    } else if (serviceName.contains('house') || serviceName.contains('ndani')) {
      return Icons.home;
    } else if (serviceName.contains('barber')) {
      return Icons.content_cut;
    } else if (serviceName.contains('baby')) {
      return Icons.child_care;
    } else if (serviceName.contains('event')) {
      return Icons.event;
    } else if (serviceName.contains('photo')) {
      return Icons.camera_alt;
    } else {
      return Icons.play_circle_filled;
    }
  }
}

class _DottedPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    const dotSize = 2.0;
    const spacing = 8.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotSize / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
