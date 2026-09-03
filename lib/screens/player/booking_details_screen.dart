import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../state/app_booking_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/insufficient_credits_dialog.dart';
import '../../widgets/primary_button.dart';
import 'booking_confirmation_screen.dart';
import 'credits_screen.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key, required this.bookingData});

  final Map<String, dynamic> bookingData;

  int get _amount {
    final raw = bookingData['amount'];
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    return int.tryParse('$raw') ?? 0;
  }

  int get _creditsRequired {
    final raw = bookingData['credits'] ?? bookingData['creditsRequired'];
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw != null) {
      final parsed = int.tryParse('$raw');
      if (parsed != null) return parsed;
    }
    return _amount ~/ 10;
  }

  void _openCredits(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CreditsScreen(
          credits: AppCreditsState.current,
          onBalanceChanged: (total) => AppCreditsState.current = total,
        ),
      ),
    );
  }

  void _handleUseCredits(
    BuildContext context,
    Map<String, dynamic> venue,
  ) {
    final currentCredits = AppCreditsState.current;
    final creditsRequired = _creditsRequired;

    if (currentCredits < creditsRequired) {
      InsufficientCreditsDialog.show(
        context,
        requiredCredits: creditsRequired,
        availableCredits: currentCredits,
        onBuyCredit: () => _openCredits(context),
      );
      return;
    }

    _showConfirmationDialog(context, venue, creditsRequired, currentCredits);
  }

  void _showConfirmationDialog(
    BuildContext context,
    Map<String, dynamic> venue,
    int creditsRequired,
    int currentCredits,
  ) {
    final remainingCredits = currentCredits - creditsRequired;

    showDialog(
      context: context,
      builder: (dialogCtx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title & Close X
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Confirm Booking',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 22),
                    color: AppColors.navy,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.pop(dialogCtx),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Venue Name
              Text(
                venue['name'] ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 14),

              // Booking Details
              _DialogRow(label: 'Game', value: bookingData['game'] ?? ''),
              if (bookingData['court'] != null) ...[
                const SizedBox(height: 8),
                _DialogRow(label: 'Court', value: bookingData['court'] ?? ''),
              ],
              const SizedBox(height: 8),
              _DialogRow(label: 'Date', value: bookingData['date'] ?? ''),
              const SizedBox(height: 8),
              _DialogRow(
                label: 'Time',
                value:
                    '${bookingData['startTime']} - ${bookingData['endTime']}',
              ),
              const SizedBox(height: 8),
              _DialogRow(
                label: 'Duration',
                value: bookingData['duration'] ?? '',
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(color: AppColors.fieldBorder),
              ),

              // Credit Breakdown
              _DialogRow(
                label: 'Credits Required',
                value: '$creditsRequired',
                isBold: true,
              ),
              const SizedBox(height: 8),
              _DialogRow(
                label: 'Current Credits',
                value: '$currentCredits',
              ),
              const SizedBox(height: 8),
              _DialogRow(
                label: 'Remaining Credits',
                value: '$remainingCredits',
                valueColor: AppColors.primaryDark,
                isBold: true,
              ),
              const SizedBox(height: 24),

              // Confirm Action
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    // 1. Deduct credits
                    AppCreditsState.deduct(creditsRequired);
                    AppBookingState.addLedger(
                      'Booking · ${venue['name']}',
                      -creditsRequired,
                    );
                    AppBookingState.add(
                      VenueBookingRecord(
                        id: 'b_${DateTime.now().millisecondsSinceEpoch}',
                        venueName: venue['name'] as String? ?? 'Venue',
                        location: venue['location'] as String? ?? '',
                        image: venue['image'] as String? ?? '',
                        sport: bookingData['game'] as String? ?? '',
                        court: bookingData['court'] as String? ?? '',
                        date: bookingData['date'] as String? ?? '',
                        startTime: bookingData['startTime'] as String? ?? '',
                        endTime: bookingData['endTime'] as String? ?? '',
                        duration: bookingData['duration'] as String? ?? '',
                        creditsUsed: creditsRequired,
                        status: 'Confirmed',
                        isFullDay: (bookingData['duration'] as String? ?? '')
                            .toLowerCase()
                            .contains('full'),
                      ),
                    );

                    // 2. Close dialog
                    Navigator.pop(dialogCtx);

                    // 3. Navigate to BookingConfirmationScreen
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => BookingConfirmationScreen(
                          bookingData: bookingData,
                          creditsUsed: creditsRequired,
                          remainingCredits: remainingCredits,
                        ),
                      ),
                    );
                  },
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final venue = bookingData['venue'] as Map<String, dynamic>;
    final amount = _amount;
    final creditsRequired = _creditsRequired;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Academy Section
            const Text(
              'Academy',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: AppSurfaces.card(),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      venue['image'],
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 64,
                        height: 64,
                        color: AppColors.fieldBorder,
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
                          venue['name'],
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          venue['location'],
                          style: const TextStyle(
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
            const SizedBox(height: 24),

            // Booking Info
            _InfoRow(
              label: 'Game',
              value: bookingData['game'],
              icon: HugeIcons.strokeRoundedBadminton,
            ),
            if (bookingData['court'] != null) ...[
              const SizedBox(height: 16),
              _InfoRow(
                label: 'Court',
                value: bookingData['court'],
                icon: HugeIcons.strokeRoundedFootballPitch,
              ),
            ],
            const SizedBox(height: 16),
            _InfoRow(
              label: 'Date',
              value: bookingData['date'],
              icon: HugeIcons.strokeRoundedCalendar03,
            ),
            const SizedBox(height: 16),
            _InfoRow(
              label: 'Time',
              value: '${bookingData['startTime']} - ${bookingData['endTime']}',
              icon: HugeIcons.strokeRoundedClock01,
            ),
            const SizedBox(height: 16),
            _InfoRow(
              label: 'Duration',
              value: bookingData['duration'],
              icon: HugeIcons.strokeRoundedTimer01,
            ),
            const SizedBox(height: 32),

            // Payment Summary
            const Text(
              'Payment Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppSurfaces.card(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Booking Amount',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      Text(
                        '₹$amount',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Credits Required',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      Text(
                        '$creditsRequired Credits',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: AppColors.fieldBorder),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Payable',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      Text(
                        '₹$amount / $creditsRequired Credits',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: AppSurfaces.bar,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: PrimaryButton(
              label: 'Use Credits',
              onPressed: () => _handleUseCredits(context, venue),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final List<List<dynamic>> icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppIcon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DialogRow extends StatelessWidget {
  const _DialogRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor ?? AppColors.navy,
          ),
        ),
      ],
    );
  }
}
