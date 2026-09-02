import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';

class EquipmentRentalRecord {
  EquipmentRentalRecord({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.rentedDate,
    required this.duration,
    required this.returnDate,
    required this.price,
    required this.status,
  });

  final String id;
  final String name;
  final String category;
  final String image;
  final String rentedDate;
  final String duration;
  final String returnDate;
  final String price;
  String status;
}

class EquipmentHistoryScreen extends StatefulWidget {
  const EquipmentHistoryScreen({super.key});

  @override
  State<EquipmentHistoryScreen> createState() => _EquipmentHistoryScreenState();
}

class _EquipmentHistoryScreenState extends State<EquipmentHistoryScreen> {
  late List<EquipmentRentalRecord> _rentals;

  @override
  void initState() {
    super.initState();
    _rentals = [
      EquipmentRentalRecord(
        id: '1',
        name: 'Yonex Astrox Racket',
        category: 'Sports Equipment',
        image: 'assets/sports/sport_badminton.png',
        rentedDate: '02 Sep 2026',
        duration: '2 Days',
        returnDate: '04 Sep 2026',
        price: '₹200',
        status: 'Rented',
      ),
      EquipmentRentalRecord(
        id: '2',
        name: 'Football Size 5',
        category: 'Sports Equipment',
        image: 'assets/sports/sport_football.png',
        rentedDate: '01 Sep 2026',
        duration: '3 Days',
        returnDate: '04 Sep 2026',
        price: '₹150',
        status: 'Rented',
      ),
      EquipmentRentalRecord(
        id: '3',
        name: 'Cricket Kit',
        category: 'Sports Equipment',
        image: 'assets/sports/sport_box_cricket.png',
        rentedDate: '25 Aug 2026',
        duration: '4 Days',
        returnDate: '29 Aug 2026',
        price: '₹450',
        status: 'Returned',
      ),
      EquipmentRentalRecord(
        id: '4',
        name: 'TT Paddle Set',
        category: 'Sports Equipment',
        image: 'assets/sports/sport_table_tennis.png',
        rentedDate: '20 Aug 2026',
        duration: '1 Day',
        returnDate: '21 Aug 2026',
        price: '₹100',
        status: 'Returned',
      ),
    ];
  }

  Future<void> _handleReturn(EquipmentRentalRecord rental) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Return Equipment?',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.navy,
            fontSize: 18,
          ),
        ),
        content: const Text(
          'Are you sure you want to return this equipment?',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Return'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        rental.status = 'Returned';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${rental.name} has been returned successfully.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      appBar: AppBar(
        title: const Text('My Equipments'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _rentals.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const AppIcon(
                      HugeIcons.strokeRoundedDumbbell02,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Equipment Rentals',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'You haven\'t rented any equipment yet.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              itemCount: _rentals.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final rental = _rentals[index];
                return _RentalCard(
                  rental: rental,
                  onReturn: () => _handleReturn(rental),
                );
              },
            ),
    );
  }
}

class _RentalCard extends StatelessWidget {
  const _RentalCard({
    required this.rental,
    required this.onReturn,
  });

  final EquipmentRentalRecord rental;
  final VoidCallback onReturn;

  @override
  Widget build(BuildContext context) {
    final isRented = rental.status == 'Rented';

    return Container(
      decoration: AppSurfaces.card(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 68,
                height: 68,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.backgroundBottom,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.fieldBorder),
                ),
                child: Image.asset(
                  rental.image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.sports_tennis_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rental.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      rental.category,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rental Price: ${rental.price}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
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
          _DetailRow(label: 'Rented', value: rental.rentedDate),
          const SizedBox(height: 6),
          _DetailRow(label: 'Duration', value: rental.duration),
          const SizedBox(height: 6),
          _DetailRow(label: 'Return By', value: rental.returnDate),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusBadge(status: rental.status),
              if (isRented)
                FilledButton(
                  onPressed: onReturn,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    minimumSize: const Size(80, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Return',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isRented = status == 'Rented';
    final bg = isRented
        ? AppColors.primarySoft.withValues(alpha: 0.18)
        : AppColors.accent.withValues(alpha: 0.15);
    final border = isRented
        ? AppColors.primarySoft.withValues(alpha: 0.6)
        : AppColors.accent.withValues(alpha: 0.4);
    final textCol = isRented ? AppColors.primaryDark : const Color(0xFF1E824C);
    final icon = isRented
        ? HugeIcons.strokeRoundedClock01
        : HugeIcons.strokeRoundedCheckmarkCircle02;

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

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

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
