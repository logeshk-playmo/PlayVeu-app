import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../state/app_rental_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icon.dart';
import 'equipment_detail_screen.dart';

export '../../state/app_rental_state.dart' show EquipmentRentalRecord;

class EquipmentHistoryScreen extends StatefulWidget {
  const EquipmentHistoryScreen({super.key});

  @override
  State<EquipmentHistoryScreen> createState() => _EquipmentHistoryScreenState();
}

class _EquipmentHistoryScreenState extends State<EquipmentHistoryScreen> {
  @override
  void initState() {
    super.initState();
    AppRentalState.rentals.addListener(_onChanged);
  }

  @override
  void dispose() {
    AppRentalState.rentals.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  void _openDetails(EquipmentRentalRecord rental) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EquipmentDetailScreen.fromRental(rental: rental),
      ),
    );
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
      AppRentalState.markReturned(rental.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${rental.name} has been returned successfully.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final rentals = AppRentalState.rentals.value;

    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      appBar: AppBar(
        title: const Text('My Equipments'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: rentals.isEmpty
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
              itemCount: rentals.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final rental = rentals[index];
                return _RentalCard(
                  rental: rental,
                  onTap: () => _openDetails(rental),
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
    required this.onTap,
    required this.onReturn,
  });

  final EquipmentRentalRecord rental;
  final VoidCallback onTap;
  final VoidCallback onReturn;

  @override
  Widget build(BuildContext context) {
    final canReturn = rental.status == 'Rented' || rental.status == 'Overdue';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
                  child: Image(
                    image: rental.image.startsWith('http')
                        ? NetworkImage(rental.image)
                        : AssetImage(rental.image) as ImageProvider,
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
                        '${rental.sport} • ${rental.category}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ID: ${rental.uniqueItemId}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
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
            _DetailRow(label: 'Item ID', value: rental.uniqueItemId),
            const SizedBox(height: 6),
            _DetailRow(label: 'Rental Date', value: rental.rentedDate),
            const SizedBox(height: 6),
            _DetailRow(label: 'Duration', value: rental.duration),
            const SizedBox(height: 6),
            _DetailRow(label: 'Due Date', value: rental.returnDate),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatusBadge(status: rental.status),
                if (canReturn)
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
    final isOverdue = status == 'Overdue';
    final isDamaged = status == 'Damaged';
    final Color bg;
    final Color border;
    final Color textCol;
    final List<List<dynamic>> icon;
    if (isOverdue || isDamaged) {
      bg = const Color(0xFFE74C3C).withValues(alpha: 0.12);
      border = const Color(0xFFE74C3C).withValues(alpha: 0.4);
      textCol = const Color(0xFFE74C3C);
      icon = HugeIcons.strokeRoundedClock01;
    } else if (isRented) {
      bg = AppColors.primarySoft.withValues(alpha: 0.18);
      border = AppColors.primarySoft.withValues(alpha: 0.6);
      textCol = AppColors.primaryDark;
      icon = HugeIcons.strokeRoundedClock01;
    } else {
      bg = AppColors.accent.withValues(alpha: 0.15);
      border = AppColors.accent.withValues(alpha: 0.4);
      textCol = const Color(0xFF1E824C);
      icon = HugeIcons.strokeRoundedCheckmarkCircle02;
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
