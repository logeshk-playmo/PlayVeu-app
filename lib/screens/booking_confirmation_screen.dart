import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';
import '../widgets/low_credit_dialog.dart';
import '../widgets/primary_button.dart';
import 'credits_screen.dart';

class BookingConfirmationScreen extends StatefulWidget {
  const BookingConfirmationScreen({
    super.key,
    required this.bookingData,
    required this.creditsUsed,
    required this.remainingCredits,
  });

  final Map<String, dynamic> bookingData;
  final int creditsUsed;
  final int remainingCredits;

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLowCredits());
  }

  void _checkLowCredits() {
    if (!mounted) return;
    LowCreditDialog.checkAndShow(
      context,
      onBuyCredit: _openCredits,
    );
  }

  void _openCredits() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CreditsScreen(
          credits: AppCreditsState.current,
          onBalanceChanged: (total) => AppCreditsState.current = total,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final venue = widget.bookingData['venue'] as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (constraints.maxHeight - 44)
                      .clamp(0.0, double.infinity),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const Spacer(flex: 1),

                      // Success Checkmark Badge
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.12),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            width: 1.5,
                          ),
                        ),
                        child: const Center(
                          child: AppIcon(
                            HugeIcons.strokeRoundedCheckmarkCircle02,
                            size: 48,
                            color: AppColors.primary,
                            strokeWidth: 2.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title
                      const Text(
                        'Booking Confirmed!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Your slot has been reserved successfully.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Booking Summary Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: AppSurfaces.card(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Venue Header
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    venue['image'],
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 52,
                                      height: 52,
                                      color: AppColors.fieldBorder,
                                      child: const AppIcon(
                                        HugeIcons.strokeRoundedImageNotFound01,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        venue['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.navy,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        venue['location'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(color: AppColors.fieldBorder),
                            ),

                            // Booking Info Rows
                            _DetailRow(
                              label: 'Game',
                              value: widget.bookingData['game'] ?? '',
                              icon: HugeIcons.strokeRoundedBadminton,
                            ),
                            if (widget.bookingData['court'] != null) ...[
                              const SizedBox(height: 10),
                              _DetailRow(
                                label: 'Court',
                                value: widget.bookingData['court'] ?? '',
                                icon: HugeIcons.strokeRoundedFootballPitch,
                              ),
                            ],
                            const SizedBox(height: 10),
                            _DetailRow(
                              label: 'Date',
                              value: widget.bookingData['date'] ?? '',
                              icon: HugeIcons.strokeRoundedCalendar03,
                            ),
                            const SizedBox(height: 10),
                            _DetailRow(
                              label: 'Time',
                              value:
                                  '${widget.bookingData['startTime']} - ${widget.bookingData['endTime']}',
                              icon: HugeIcons.strokeRoundedClock01,
                            ),
                            const SizedBox(height: 10),
                            _DetailRow(
                              label: 'Duration',
                              value: widget.bookingData['duration'] ?? '',
                              icon: HugeIcons.strokeRoundedTimer01,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(color: AppColors.fieldBorder),
                            ),

                            // Credits Info
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Credits Used',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${widget.creditsUsed} Credits',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.navy,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Remaining Credits',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.navy,
                                  ),
                                ),
                                Text(
                                  '${widget.remainingCredits} Credits',
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

                      const Spacer(flex: 2),

                      // Done Button
                      PrimaryButton(
                        label: 'DONE',
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
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
        AppIcon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
        ),
      ],
    );
  }
}
