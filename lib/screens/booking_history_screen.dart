import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../state/app_booking_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';

export '../state/app_booking_state.dart' show VenueBookingRecord;

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key, this.initialBookings});

  final List<VenueBookingRecord>? initialBookings;

  static List<VenueBookingRecord> get defaultBookings =>
      List<VenueBookingRecord>.from(AppBookingState.bookings.value);

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  late List<VenueBookingRecord> _bookings;

  @override
  void initState() {
    super.initState();
    if (widget.initialBookings != null) {
      _bookings = widget.initialBookings!;
    } else {
      _bookings = List<VenueBookingRecord>.from(AppBookingState.bookings.value);
      AppBookingState.bookings.addListener(_onBookingsChanged);
    }
  }

  @override
  void dispose() {
    if (widget.initialBookings == null) {
      AppBookingState.bookings.removeListener(_onBookingsChanged);
    }
    super.dispose();
  }

  void _onBookingsChanged() {
    if (mounted) {
      setState(() {
        _bookings = List<VenueBookingRecord>.from(AppBookingState.bookings.value);
      });
    }
  }

  @override
  void didUpdateWidget(covariant BookingHistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialBookings != oldWidget.initialBookings) {
      _bookings = widget.initialBookings ??
          List<VenueBookingRecord>.from(AppBookingState.bookings.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      appBar: AppBar(
        title: const Text('Booking History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _bookings.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primarySoft.withValues(alpha: 0.2),
                      ),
                      child: const Center(
                        child: AppIcon(
                          HugeIcons.strokeRoundedCalendar03,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No Bookings Yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You haven\'t made any venue bookings yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Explore Venues',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              itemCount: _bookings.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final booking = _bookings[index];
                return _BookingHistoryCard(booking: booking);
              },
            ),
    );
  }
}

class _BookingHistoryCard extends StatelessWidget {
  const _BookingHistoryCard({required this.booking});

  final VenueBookingRecord booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppSurfaces.card(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Venue Image + Name + Location
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  booking.image,
                  width: 68,
                  height: 68,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 68,
                    height: 68,
                    color: AppColors.fieldBorder,
                    alignment: Alignment.center,
                    child: const AppIcon(
                      HugeIcons.strokeRoundedImageNotFound01,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.venueName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            booking.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.fieldBorder),
          ),

          // Sport & Court
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoRow(
                icon: HugeIcons.strokeRoundedPlaySquare,
                label: 'Sport',
                value: booking.sport,
              ),
              _InfoRow(
                icon: HugeIcons.strokeRoundedFootballPitch,
                label: 'Court',
                value: booking.court,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Date & Time
          _InfoRow(
            icon: HugeIcons.strokeRoundedCalendar03,
            label: 'Date',
            value: booking.date,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: HugeIcons.strokeRoundedClock01,
            label: 'Time',
            value: '${booking.startTime} - ${booking.endTime}',
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: HugeIcons.strokeRoundedTimer01,
            label: 'Duration',
            value: booking.duration,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.fieldBorder),
          ),

          // Footer: Credits Used & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Credits Used',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${booking.creditsUsed} Credits',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
              _BookingStatusBadge(status: booking.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final List<List<dynamic>> icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIcon(
          icon,
          size: 15,
          color: AppColors.primary,
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}

class _BookingStatusBadge extends StatelessWidget {
  const _BookingStatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color textCol;
    List<List<dynamic>> icon;

    switch (status) {
      case 'Confirmed':
        bg = AppColors.accent.withValues(alpha: 0.15);
        border = AppColors.accent.withValues(alpha: 0.45);
        textCol = const Color(0xFF1E824C);
        icon = HugeIcons.strokeRoundedCheckmarkCircle02;
        break;
      case 'Completed':
        bg = AppColors.primarySoft.withValues(alpha: 0.18);
        border = AppColors.primarySoft.withValues(alpha: 0.55);
        textCol = AppColors.primaryDark;
        icon = HugeIcons.strokeRoundedTick02;
        break;
      case 'Cancelled':
      default:
        bg = const Color(0xFFFFECEC);
        border = const Color(0xFFFFB4B4);
        textCol = const Color(0xFFD32F2F);
        icon = HugeIcons.strokeRoundedCancel01;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(
            icon,
            size: 14,
            color: textCol,
          ),
          const SizedBox(width: 5),
          Text(
            'Status: $status',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: textCol,
            ),
          ),
        ],
      ),
    );
  }
}
