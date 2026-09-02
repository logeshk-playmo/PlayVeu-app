import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../state/app_booking_state.dart';
import '../../state/app_session.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icon.dart';
import '../login_screen.dart';
import 'admin_ui.dart';

class AdminMoreScreen extends StatelessWidget {
  const AdminMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        AdminCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: const CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PlayVue Admin',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    SizedBox(height: 4),
                    AdminBadge(label: 'Admin', color: AppColors.primaryDark),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const AdminSectionLabel('Players'),
        const SizedBox(height: 10),
        AdminCard(
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Logesh',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Bengaluru',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              AdminBadge(label: 'Active', color: adminStatusColor('Active')),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const AdminSectionLabel('Credits'),
        const SizedBox(height: 10),
        ValueListenableBuilder(
          valueListenable: AppBookingState.ledger,
          builder: (context, entries, _) {
            if (entries.isEmpty) {
              return AdminCard(
                child: const Text(
                  'No credit activity yet.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }
            return AdminCard(
              child: Column(
                children: [
                  for (var i = 0; i < entries.take(6).length; i++) ...[
                    if (i > 0)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(height: 1, color: AppColors.fieldBorder),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entries[i].reason,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                        Text(
                          '${entries[i].amount > 0 ? '+' : ''}${entries[i].amount}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: entries[i].amount >= 0
                                ? const Color(0xFF2ECC71)
                                : const Color(0xFFE74C3C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        AdminCard(
          onTap: () {
            AppSession.reset();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          },
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
    );
  }
}
