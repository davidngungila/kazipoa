import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class JobCard extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobCard({
    Key? key,
    required this.job,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and bookmark
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon and Title
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _getBadgeColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          job['icon'] as IconData,
                          color: _getBadgeColor(),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job['title'] as String,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkGrey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${job['company']} • ${job['location']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.mediumGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Bookmark and Verified Badge
                Column(
                  children: [
                    if (job['verified'] as bool)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            const Text(
                              'Verified',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    IconButton(
                      icon: Icon(
                        Icons.bookmark_border,
                        color: AppTheme.mediumGrey,
                      ),
                      onPressed: () {
                        // Handle bookmark
                      },
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Tags
            Row(
              children: [
                _buildTag(job['type'] as String),
                const SizedBox(width: 8),
                _buildTag(job['experience'] as String),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Salary and Action Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  job['salary'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryPurple,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () {
                      // Handle details
                    },
                    child: Text(
                      'Maelezo',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.lightPurple.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryPurple,
        ),
      ),
    );
  }

  Color _getBadgeColor() {
    final badge = job['badge'] as String;
    switch (badge) {
      case 'Platinum':
        return Colors.grey[600]!;
      case 'Gold':
        return Colors.amber[600]!;
      case 'Silver':
        return Colors.blueGrey[400]!;
      case 'Bronze':
        return Colors.orange[400]!;
      default:
        return AppTheme.primaryPurple;
    }
  }
}
