import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_icon.dart';
import 'admin_ui.dart';

class AdminNotificationItem {
  const AdminNotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    this.isUnread = false,
  });

  final String id;
  final String title;
  final String description;
  final String time;
  final List<List<dynamic>> icon;
  final bool isUnread;
}

class AdminNotificationScreen extends StatefulWidget {
  const AdminNotificationScreen({super.key});

  @override
  State<AdminNotificationScreen> createState() =>
      _AdminNotificationScreenState();
}

class _AdminNotificationScreenState extends State<AdminNotificationScreen> {
  final List<AdminNotificationItem> _notifications = const [
    AdminNotificationItem(
      id: 'n1',
      title: 'New Booking',
      description: 'A new venue booking was created for Smash Arena.',
      time: 'Today, 10:30 AM',
      icon: HugeIcons.strokeRoundedCalendar03,
      isUnread: true,
    ),
    AdminNotificationItem(
      id: 'n2',
      title: 'New User',
      description: 'A new user registered: Logesh (+91 99999 99999).',
      time: 'Today, 09:45 AM',
      icon: HugeIcons.strokeRoundedUser,
      isUnread: true,
    ),
    AdminNotificationItem(
      id: 'n3',
      title: 'Payment Received',
      description: 'Payment received for booking #1 (50 credits).',
      time: 'Yesterday, 06:20 PM',
      icon: HugeIcons.strokeRoundedWallet01,
      isUnread: false,
    ),
    AdminNotificationItem(
      id: 'n4',
      title: 'Equipment Rented',
      description: 'Yonex Astrox Racket was rented out.',
      time: 'Yesterday, 02:15 PM',
      icon: HugeIcons.strokeRoundedDumbbell02,
      isUnread: false,
    ),
    AdminNotificationItem(
      id: 'n5',
      title: 'Facility Status Updated',
      description: 'PlayVue Sports Academy status changed to Open.',
      time: '02 Sep, 11:00 AM',
      icon: HugeIcons.strokeRoundedFootballPitch,
      isUnread: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: _notifications.isEmpty
          ? const Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _notifications[index];
                return AdminCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: item.isUnread
                              ? AppColors.primary.withValues(alpha: 0.12)
                              : AppColors.fieldBorder.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: AppIcon(
                          item.icon,
                          size: 20,
                          color: item.isUnread
                              ? AppColors.primary
                              : AppColors.navy,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: item.isUnread
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                ),
                                if (item.isUnread)
                                  const AdminBadge(
                                    label: 'New',
                                    color: AppColors.primary,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.time,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
