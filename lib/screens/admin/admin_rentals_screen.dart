import 'package:flutter/material.dart';

import '../../state/app_catalogue_state.dart';
import '../../state/app_rental_state.dart';
import '../../theme/app_theme.dart';
import 'admin_ui.dart';

class AdminRentalsList extends StatefulWidget {
  const AdminRentalsList({super.key});

  @override
  State<AdminRentalsList> createState() => _AdminRentalsListState();
}

class _AdminRentalsListState extends State<AdminRentalsList> {
  static const _statuses = [
    'Rented',
    'Returned',
    'Overdue',
    'Damaged',
  ];

  @override
  void initState() {
    super.initState();
    AppRentalState.rentals.addListener(_onChanged);
    AppCatalogueState.items.addListener(_onChanged);
  }

  @override
  void dispose() {
    AppRentalState.rentals.removeListener(_onChanged);
    AppCatalogueState.items.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _override(EquipmentRentalRecord rental) async {
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
                  'Update rental',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${rental.name}  ·  ${rental.playerName}',
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
                    trailing: rental.status == status
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

    if (next != null && next != rental.status) {
      AppRentalState.overrideStatus(rental.id, next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rentals = AppRentalState.rentals.value;

    if (rentals.isEmpty) {
      return const Center(
        child: Text(
          'No rentals yet.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      itemCount: rentals.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return _RentalAdminCard(
          rental: rentals[index],
          onTap: () => _override(rentals[index]),
        );
      },
    );
  }
}

class _RentalAdminCard extends StatelessWidget {
  const _RentalAdminCard({required this.rental, required this.onTap});

  final EquipmentRentalRecord rental;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final item = AppCatalogueState.byId(rental.itemId);
    final stock = item?.stockCount;

    return AdminCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  rental.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ),
              AdminBadge(
                label: rental.status,
                color: adminStatusColor(rental.status),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${rental.playerName}  ·  due ${rental.returnDate}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stock == null
                ? '${rental.duration}  ·  ${rental.price}'
                : '${rental.duration}  ·  ${rental.price}  ·  $stock in stock',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}
