import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_icon.dart';

enum AdminDrawerItem {
  home,
  plans,
  players,
  revenue,
}

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({
    super.key,
    required this.selectedItem,
    required this.onSelectItem,
    required this.onLogout,
  });

  final AdminDrawerItem selectedItem;
  final ValueChanged<AdminDrawerItem> onSelectItem;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        'A',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'PlayVue Admin',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'admin@example.com',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.fieldBorder),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _AdminDrawerTile(
                    icon: HugeIcons.strokeRoundedHome01,
                    label: 'Home',
                    selected: selectedItem == AdminDrawerItem.home,
                    onTap: () => onSelectItem(AdminDrawerItem.home),
                  ),
                  _AdminDrawerTile(
                    icon: HugeIcons.strokeRoundedWallet01,
                    label: 'Plans',
                    selected: selectedItem == AdminDrawerItem.plans,
                    onTap: () => onSelectItem(AdminDrawerItem.plans),
                  ),
                  _AdminDrawerTile(
                    icon: HugeIcons.strokeRoundedUserGroup,
                    label: 'Players',
                    selected: selectedItem == AdminDrawerItem.players,
                    onTap: () => onSelectItem(AdminDrawerItem.players),
                  ),
                  _AdminDrawerTile(
                    icon: HugeIcons.strokeRoundedCoins01,
                    label: 'Revenue',
                    selected: selectedItem == AdminDrawerItem.revenue,
                    onTap: () => onSelectItem(AdminDrawerItem.revenue),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.fieldBorder),
            _AdminDrawerTile(
              icon: HugeIcons.strokeRoundedLogout01,
              label: 'Logout',
              isDestructive: true,
              onTap: onLogout,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _AdminDrawerTile extends StatelessWidget {
  const _AdminDrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.isDestructive = false,
  });

  final List<List<dynamic>> icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final Color textColor;
    final Color iconColor;
    final Color? tileColor;

    if (isDestructive) {
      textColor = const Color(0xFFE74C3C);
      iconColor = const Color(0xFFE74C3C);
      tileColor = null;
    } else if (selected) {
      textColor = AppColors.primary;
      iconColor = AppColors.primary;
      tileColor = AppColors.primary.withValues(alpha: 0.08);
    } else {
      textColor = AppColors.navy;
      iconColor = AppColors.textSecondary;
      tileColor = null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: tileColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                AppIcon(
                  icon,
                  size: 20,
                  color: iconColor,
                  strokeWidth: selected ? 2.4 : 1.8,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: textColor,
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
}
