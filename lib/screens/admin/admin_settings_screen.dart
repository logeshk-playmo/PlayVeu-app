import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_icon.dart';
import 'admin_ui.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _notifications = true;
  bool _soundAndHaptics = true;
  bool _autoApprove = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const AdminSectionLabel('Preferences'),
          const SizedBox(height: 10),
          AdminCard(
            child: Column(
              children: [
                Row(
                  children: [
                    const AppIcon(
                      HugeIcons.strokeRoundedNotification01,
                      size: 20,
                      color: AppColors.navy,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Push Notifications',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    Switch.adaptive(
                      value: _notifications,
                      activeTrackColor: AppColors.primary,
                      onChanged: (val) => setState(() => _notifications = val),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Divider(height: 1, color: AppColors.fieldBorder),
                ),
                Row(
                  children: [
                    const AppIcon(
                      HugeIcons.strokeRoundedVolumeHigh,
                      size: 20,
                      color: AppColors.navy,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Sound & Haptics',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    Switch.adaptive(
                      value: _soundAndHaptics,
                      activeTrackColor: AppColors.primary,
                      onChanged: (val) => setState(() => _soundAndHaptics = val),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const AdminSectionLabel('Facility Defaults'),
          const SizedBox(height: 10),
          AdminCard(
            child: Column(
              children: [
                const Row(
                  children: [
                    AppIcon(
                      HugeIcons.strokeRoundedWallet01,
                      size: 20,
                      color: AppColors.navy,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Currency',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    AdminBadge(label: '₹ INR', color: AppColors.primaryDark),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: AppColors.fieldBorder),
                ),
                Row(
                  children: [
                    const AppIcon(
                      HugeIcons.strokeRoundedCheckmarkCircle02,
                      size: 20,
                      color: AppColors.navy,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Auto-approve Bookings',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    Switch.adaptive(
                      value: _autoApprove,
                      activeTrackColor: AppColors.primary,
                      onChanged: (val) => setState(() => _autoApprove = val),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const AdminSectionLabel('About'),
          const SizedBox(height: 10),
          const AdminCard(
            child: Row(
              children: [
                AppIcon(
                  HugeIcons.strokeRoundedInformationCircle,
                  size: 20,
                  color: AppColors.navy,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'App Version',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                Text(
                  '1.0.0 (Build 1)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AdminCard(
            onTap: () => showAdminLogoutDialog(context),
            child: const Row(
              children: [
                AppIcon(
                  HugeIcons.strokeRoundedLogout01,
                  size: 20,
                  color: Color(0xFFE74C3C),
                ),
                SizedBox(width: 12),
                Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE74C3C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
