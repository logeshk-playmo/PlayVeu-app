import 'package:flutter/material.dart';

import '../../state/app_booking_state.dart';
import '../../theme/app_theme.dart';
import 'admin_ui.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen> {
  static const _statuses = [
    'Confirmed',
    'Completed',
    'Cancelled',
    'No-show',
  ];

  @override
  void initState() {
    super.initState();
    AppBookingState.bookings.addListener(_onChanged);
  }

  @override
  void dispose() {
    AppBookingState.bookings.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _override(VenueBookingRecord booking) async {
    final next = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
                  'Update status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  booking.venueName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                for (final status in _statuses)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      status,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                    trailing: booking.status == status
                        ? const Icon(
                            Icons.check_rounded,
                            color: AppColors.primary,
                          )
                        : null,
                    onTap: () => Navigator.pop(ctx, status),
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (next != null && next != booking.status) {
      AppBookingState.overrideStatus(booking.id, next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookings = AppBookingState.bookings.value;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      itemCount: bookings.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return AdminCard(
          onTap: () => _override(booking),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      booking.venueName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  AdminBadge(
                    label: booking.status,
                    color: adminStatusColor(booking.status),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${booking.sport}  ·  ${booking.court}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${booking.date}  ·  ${booking.startTime}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${booking.playerName}  ·  ${booking.creditsUsed} credits',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
