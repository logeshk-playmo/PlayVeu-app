import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'admin_ui.dart';

class MonthlyRevenue {
  const MonthlyRevenue({
    required this.monthYear,
    required this.venueRevenue,
    required this.membershipRevenue,
    required this.rentalRevenue,
    required this.totalRevenue,
    required this.growthText,
  });

  final String monthYear;
  final int venueRevenue;
  final int membershipRevenue;
  final int rentalRevenue;
  final int totalRevenue;
  final String growthText;

  String get venueFormatted => '₹${_format(venueRevenue)}';
  String get membershipFormatted => '₹${_format(membershipRevenue)}';
  String get rentalFormatted => '₹${_format(rentalRevenue)}';
  String get totalFormatted => '₹${_format(totalRevenue)}';

  static String _format(int val) {
    final s = val.toString();
    if (s.length > 3) {
      final lastThree = s.substring(s.length - 3);
      final remaining = s.substring(0, s.length - 3);
      final regex = RegExp(r'\B(?=(\d{2})+(?!\d))');
      return '${remaining.replaceAll(regex, ',')},$lastThree';
    }
    return s;
  }
}

class AdminRevenueScreen extends StatelessWidget {
  const AdminRevenueScreen({super.key});

  static const List<MonthlyRevenue> _months = [
    MonthlyRevenue(
      monthYear: 'September 2026',
      venueRevenue: 120000,
      membershipRevenue: 40000,
      rentalRevenue: 15000,
      totalRevenue: 175000,
      growthText: '+15.1% vs last month',
    ),
    MonthlyRevenue(
      monthYear: 'August 2026',
      venueRevenue: 105000,
      membershipRevenue: 35000,
      rentalRevenue: 12000,
      totalRevenue: 152000,
      growthText: '+8.6% vs last month',
    ),
    MonthlyRevenue(
      monthYear: 'July 2026',
      venueRevenue: 98000,
      membershipRevenue: 32000,
      rentalRevenue: 10000,
      totalRevenue: 140000,
      growthText: '+12.0% vs last month',
    ),
    MonthlyRevenue(
      monthYear: 'June 2026',
      venueRevenue: 85000,
      membershipRevenue: 30000,
      rentalRevenue: 10000,
      totalRevenue: 125000,
      growthText: '+4.2% vs last month',
    ),
    MonthlyRevenue(
      monthYear: 'May 2026',
      venueRevenue: 82000,
      membershipRevenue: 28000,
      rentalRevenue: 10000,
      totalRevenue: 120000,
      growthText: '+6.1% vs last month',
    ),
    MonthlyRevenue(
      monthYear: 'April 2026',
      venueRevenue: 78000,
      membershipRevenue: 25000,
      rentalRevenue: 10000,
      totalRevenue: 113000,
      growthText: 'Base month',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      appBar: AppBar(
        title: const Text('Revenue Breakdown'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          // Annual Summary Card
          AdminCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YEAR TO DATE (2026)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '₹8,25,000',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Monthly Avg',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '₹1,37,500',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2ECC71).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Overall Growth',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '+54.8%',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2ECC71),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Monthly Breakdown Section
          const AdminSectionLabel('Monthly Breakdown'),
          const SizedBox(height: 10),

          for (var i = 0; i < _months.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _MonthlyRevenueCard(item: _months[i]),
          ],
        ],
      ),
    );
  }
}

class _MonthlyRevenueCard extends StatelessWidget {
  const _MonthlyRevenueCard({required this.item});

  final MonthlyRevenue item;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.monthYear,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.totalFormatted,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            item.growthText,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2ECC71),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.fieldBorder),
          ),
          _RevenueItemRow(
            icon: Icons.stadium_rounded,
            label: 'Venue Revenue',
            amount: item.venueFormatted,
            percentage: (item.venueRevenue / item.totalRevenue * 100).round(),
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          _RevenueItemRow(
            icon: Icons.card_membership_rounded,
            label: 'Membership Revenue',
            amount: item.membershipFormatted,
            percentage: (item.membershipRevenue / item.totalRevenue * 100).round(),
            color: const Color(0xFF9B59B6),
          ),
          const SizedBox(height: 8),
          _RevenueItemRow(
            icon: Icons.sports_tennis_rounded,
            label: 'Rental Revenue',
            amount: item.rentalFormatted,
            percentage: (item.rentalRevenue / item.totalRevenue * 100).round(),
            color: const Color(0xFFE67E22),
          ),
        ],
      ),
    );
  }
}

class _RevenueItemRow extends StatelessWidget {
  const _RevenueItemRow({
    required this.icon,
    required this.label,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String amount;
  final int percentage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.navy,
            ),
          ),
        ),
        Text(
          '$percentage%',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}
