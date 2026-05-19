import 'package:flutter/material.dart';

class ServiceImageWidget extends StatelessWidget {
  final String imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;

  const ServiceImageWidget({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image that fills the entire container
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              // Fallback UI if image fails to load
              return Container(
                decoration: BoxDecoration(
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
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
                          _getServiceIcon(imagePath),
                          color: Colors.white.withOpacity(0.9),
                          size: 28,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _getServiceNameFromPath(imagePath),
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
                    ],
                  ),
                ),
              );
            },
          ),
          // Subtle overlay for better visual appeal
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getServiceNameFromPath(String imagePath) {
    // Extract service name from image path
    final fileName = imagePath.split('/').last;
    final serviceName = fileName.replaceAll('.jpg', '').replaceAll('_', ' ');
    return serviceName;
  }

  IconData _getServiceIcon(String imagePath) {
    final serviceName = _getServiceNameFromPath(imagePath).toLowerCase();
    
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
    } else if (serviceName.contains('cooking')) {
      return Icons.restaurant;
    } else if (serviceName.contains('dj')) {
      return Icons.music_note;
    } else if (serviceName.contains('gardening')) {
      return Icons.yard;
    } else if (serviceName.contains('carpentry')) {
      return Icons.carpenter;
    } else if (serviceName.contains('plumbing')) {
      return Icons.plumbing;
    } else if (serviceName.contains('security')) {
      return Icons.security;
    } else if (serviceName.contains('pest')) {
      return Icons.pest_control;
    } else {
      return Icons.play_circle_filled;
    }
  }
}
