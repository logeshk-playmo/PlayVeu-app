import 'package:flutter/material.dart';

import '../../state/app_session.dart';
import '../../theme/app_theme.dart';
import '../../widgets/filter_pill.dart';
import '../login_screen.dart';

class AdminSectionLabel extends StatelessWidget {
  const AdminSectionLabel(this.text, {super.key});

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

class AdminBadge extends StatelessWidget {
  const AdminBadge({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class AdminPill extends FilterPill {
  const AdminPill({
    super.key,
    required super.label,
    required super.selected,
    required super.onTap,
  });
}

class AdminCard extends StatelessWidget {
  const AdminCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(padding: padding, child: child);
    if (onTap != null) {
      content = InkWell(onTap: onTap, child: content);
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSurfaces.radius),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: AppSurfaces.card(),
        child: content,
      ),
    );
  }
}

class AdminSaveBar extends StatelessWidget {
  const AdminSaveBar({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppSurfaces.bar,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: onPressed, child: Text(label)),
          ),
        ),
      ),
    );
  }
}

Color adminStatusColor(String status) {
  switch (status) {
    case 'Published':
    case 'Open':
    case 'Live':
    case 'Confirmed':
    case 'Completed':
    case 'Returned':
    case 'Active':
      return const Color(0xFF2ECC71);
    case 'Rented':
      return AppColors.primaryDark;
    case 'Draft':
    case 'Maintenance':
    case 'Requested':
    case 'Overdue':
      return const Color(0xFFE67E22);
    case 'Closed':
    case 'Cancelled':
    case 'No-show':
    case 'Hidden':
    case 'Damaged':
      return const Color(0xFFE74C3C);
    default:
      return AppColors.primaryDark;
  }
}

Future<void> showAdminLogoutDialog(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'Logout?',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.navy,
        ),
      ),
      content: const Text(
        'Are you sure you want to logout?',
        style: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFE74C3C),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text('Logout'),
        ),
      ],
    ),
  );

  if (confirmed == true && context.mounted) {
    AppSession.reset();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}
