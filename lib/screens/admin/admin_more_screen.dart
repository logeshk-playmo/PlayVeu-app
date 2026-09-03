import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_icon.dart';
import 'admin_notification_screen.dart';
import 'admin_settings_screen.dart';

class AdminMoreScreen extends StatelessWidget {
  const AdminMoreScreen({
    super.key,
    this.name = 'PlayVue Admin',
    this.email = 'admin@playveuw.com',
    this.location = 'Bengaluru, Karnataka',
    this.onOpenNotifications,
    this.onOpenSettings,
  });

  final String name;
  final String email;
  final String location;
  final VoidCallback? onOpenNotifications;
  final VoidCallback? onOpenSettings;

  void _openNotifications(BuildContext context) {
    if (onOpenNotifications != null) {
      onOpenNotifications!();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const AdminNotificationScreen(),
        ),
      );
    }
  }

  void _openSettings(BuildContext context) {
    if (onOpenSettings != null) {
      onOpenSettings!();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const AdminSettingsScreen(),
        ),
      );
    }
  }

  void _showProfileInfoDialog(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.fieldBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Admin Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 16),
                _InfoRow(label: 'Name', value: name),
                const Divider(height: 16, color: AppColors.fieldBorder),
                _InfoRow(label: 'Email', value: email),
                const Divider(height: 16, color: AppColors.fieldBorder),
                const _InfoRow(label: 'Role', value: 'Administrator'),
                const Divider(height: 16, color: AppColors.fieldBorder),
                _InfoRow(label: 'Location', value: location),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIndependent = ModalRoute.of(context)?.canPop == true;

    Widget content = SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          // 1. Profile Header
          const Center(child: _AvatarMark(letter: 'A', radius: 40)),
          const SizedBox(height: 16),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 6),
          const Center(child: _RoleBadge(label: 'Admin')),
          const SizedBox(height: 10),
          Text(
            '$email  ·  $location',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // 2. Summary Stats Card
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: AppSurfaces.card(),
            child: const Row(
              children: [
                _StatCell(value: '8', label: 'Facilities'),
                _StatDivider(),
                _StatCell(value: '42', label: 'Bookings'),
                _StatDivider(),
                _StatCell(value: '128', label: 'Players'),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // 3. Admin Account Section
          const _SectionLabel('Account'),
          const SizedBox(height: 10),
          _ActionGroup(
            children: [
              _ProfileAction(
                icon: HugeIcons.strokeRoundedUser,
                label: 'Profile Information',
                value: 'Manage profile',
                showDivider: false,
                onTap: () => _showProfileInfoDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // 4. Preferences Section
          const _SectionLabel('Preferences'),
          const SizedBox(height: 10),
          _ActionGroup(
            children: [
              _ProfileAction(
                icon: HugeIcons.strokeRoundedNotification01,
                label: 'Notifications',
                value: 'View alerts',
                onTap: () => _openNotifications(context),
              ),
              _ProfileAction(
                icon: HugeIcons.strokeRoundedSettings01,
                label: 'Settings',
                value: 'App settings',
                showDivider: false,
                onTap: () => _openSettings(context),
              ),
            ],
          ),
        ],
      ),
    );

    if (isIndependent) {
      return Scaffold(
        backgroundColor: AppColors.backgroundBottom,
        appBar: AppBar(title: const Text('Profile')),
        body: content,
      );
    }

    return content;
  }
}

class _AvatarMark extends StatelessWidget {
  const _AvatarMark({required this.letter, required this.radius});

  final String letter;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.primary,
        child: Text(
          letter,
          style: TextStyle(
            color: Colors.white,
            fontSize: radius * 0.8,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: AppColors.fieldBorder);
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _ActionGroup extends StatelessWidget {
  const _ActionGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppSurfaces.card(),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.value,
    this.showDivider = true,
  });

  final List<List<dynamic>> icon;
  final String label;
  final String? value;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                AppIcon(icon, size: 20, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                if (value != null)
                  Text(
                    value!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                const SizedBox(width: 6),
                const AppIcon(
                  HugeIcons.strokeRoundedArrowRight01,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 46, color: AppColors.fieldBorder),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}
