import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../state/app_catalogue_state.dart';
import '../../state/app_rental_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/primary_button.dart';
import 'rental_confirmation_screen.dart';

class EquipmentDetailScreen extends StatefulWidget {
  const EquipmentDetailScreen({
    super.key,
    required this.item,
    this.uniqueItemId,
    this.rentalId,
  });

  factory EquipmentDetailScreen.fromRental({
    Key? key,
    required EquipmentRentalRecord rental,
  }) {
    final catItem =
        AppCatalogueState.findItemByPhysicalId(rental.uniqueItemId) ??
            AppCatalogueState.byId(rental.itemId) ??
            EquipmentItem(
              id: rental.itemId,
              name: rental.name,
              sport: rental.sport,
              price: rental.price,
              image: rental.image,
              icon: HugeIcons.strokeRoundedTennisRacket,
              category: rental.category,
              description:
                  'Official sports equipment issued and verified by PlayVue.',
              features: const [
                'Verified physical inventory item',
                'Issued with authentic serial tag',
              ],
              availability: rental.status,
              physicalIds: [rental.uniqueItemId],
            );

    return EquipmentDetailScreen(
      key: key,
      item: catItem,
      uniqueItemId: rental.uniqueItemId,
      rentalId: rental.id,
    );
  }

  final EquipmentItem item;
  final String? uniqueItemId;
  final String? rentalId;

  @override
  State<EquipmentDetailScreen> createState() => _EquipmentDetailScreenState();
}

class _EquipmentDetailScreenState extends State<EquipmentDetailScreen> {
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

  EquipmentRentalRecord? get _currentRental {
    if (widget.uniqueItemId != null && widget.uniqueItemId!.isNotEmpty) {
      return AppRentalState.findByUniqueId(widget.uniqueItemId!);
    }
    if (widget.rentalId != null && widget.rentalId!.isNotEmpty) {
      return AppRentalState.rentals.value
          .where((r) => r.id == widget.rentalId)
          .firstOrNull;
    }
    return null;
  }

  EquipmentItem get _currentItem {
    if (widget.uniqueItemId != null && widget.uniqueItemId!.isNotEmpty) {
      final found =
          AppCatalogueState.findItemByPhysicalId(widget.uniqueItemId!);
      if (found != null) return found;
    }
    return AppCatalogueState.byId(widget.item.id) ?? widget.item;
  }

  void _handlePayOnline(BuildContext context) {
    final latest = _currentItem;
    if (latest.stockCount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This item is out of stock.')),
      );
      return;
    }

    final rental = AppRentalState.rent(latest);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RentalConfirmationScreen(
          item: latest,
          creditsUsed: 0,
          remainingCredits: AppCreditsState.current,
          uniqueItemId: rental.uniqueItemId,
        ),
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
        content: Text(
          'Are you sure you want to return ${rental.uniqueItemId} (${rental.name})?',
          style: const TextStyle(
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
          content: Text(
            '${rental.name} (${rental.uniqueItemId}) returned successfully.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final catItem = _currentItem;
    final rental = _currentRental;

    final name = rental?.name ?? catItem.name;
    final category = rental?.category ?? catItem.category;
    final sport = rental?.sport ?? catItem.sport;
    final image = (rental?.image.isNotEmpty ?? false)
        ? rental!.image
        : catItem.image;
    final uniqueId = rental?.uniqueItemId ??
        widget.uniqueItemId ??
        catItem.primaryUniqueId;
    final status = rental != null ? rental.status : catItem.availability;

    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      body: CustomScrollView(
        slivers: [
          // Collapsible/Floating App Bar with Equipment Image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.navy,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.45),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.45),
                  child: IconButton(
                    icon: const Icon(
                      Icons.share_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Share functionality coming soon'),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image(
                    image: image.startsWith('http')
                        ? NetworkImage(image)
                        : AssetImage(image) as ImageProvider,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.navy,
                      child: Center(
                        child: AppIcon(
                          catItem.icon,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 72,
                        ),
                      ),
                    ),
                  ),
                  // Dark Gradient Overlay at top and bottom for readability
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.55),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Category badge on image
                  Positioned(
                    bottom: 16,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content Body
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding + 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Rating Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFD97706),
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${catItem.rating}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF92400E),
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '(${catItem.reviews})',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFFB45309),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Sport Tag & Availability/Status
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundTop,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.fieldBorder),
                        ),
                        child: Text(
                          sport,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusChip(
                        status: status,
                        isRental: rental != null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Unique ID Prominent Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const AppIcon(
                            HugeIcons.strokeRoundedQrCode,
                            size: 20,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'PHYSICAL ITEM ID',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Unique ID: $uniqueId',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Rental Information Card (if active/historical rental)
                  if (rental != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: AppSurfaces.card(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rental Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(
                              height: 1,
                              color: AppColors.fieldBorder,
                            ),
                          ),
                          _DetailRow(
                            label: 'Unique ID',
                            value: rental.uniqueItemId,
                            isBold: true,
                          ),
                          const SizedBox(height: 8),
                          _DetailRow(
                            label: 'Rental Date',
                            value: rental.rentedDate,
                          ),
                          const SizedBox(height: 8),
                          _DetailRow(
                            label: 'Rental Duration',
                            value: rental.duration,
                          ),
                          const SizedBox(height: 8),
                          _DetailRow(
                            label: 'Due Date',
                            value: rental.returnDate,
                          ),
                          const SizedBox(height: 8),
                          _DetailRow(
                            label: 'Rental Price',
                            value: rental.price,
                            isBold: true,
                          ),
                          const SizedBox(height: 8),
                          _DetailRow(
                            label: 'Rented By',
                            value: rental.playerName,
                          ),
                          const SizedBox(height: 8),
                          _DetailRow(
                            label: 'Current Status',
                            value: rental.status,
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ] else ...[
                    // Price & Deposit Card (Rupees only)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: AppSurfaces.card(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Rental Rate',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                catItem.price,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: AppColors.fieldBorder,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Security Deposit',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                catItem.deposit,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Description
                  if (catItem.description.isNotEmpty) ...[
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      catItem.description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Features List
                  if (catItem.features.isNotEmpty) ...[
                    const Text(
                      'Features & Inclusions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...catItem.features.map((feature) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: AppIcon(
                                HugeIcons.strokeRoundedCheckmarkCircle02,
                                color: AppColors.accent,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                feature,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.navy,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],

                  // Additional Details Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: AppSurfaces.card(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const AppIcon(
                              HugeIcons.strokeRoundedTick02,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Equipment Condition',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              catItem.condition,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(color: AppColors.fieldBorder),
                        ),
                        const Row(
                          children: [
                            AppIcon(
                              HugeIcons.strokeRoundedLocation01,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Pick-up Location',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Front Desk Counter',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
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
          ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: AppSurfaces.bar,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: rental != null
                ? (rental.isActive
                    ? PrimaryButton(
                        label: 'Return Equipment',
                        onPressed: () => _handleReturn(rental),
                      )
                    : OutlinedButton(
                        onPressed: null,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Status: ${rental.status}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ))
                : PrimaryButton(
                    label: 'Pay Online',
                    onPressed: () => _handlePayOnline(context),
                  ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, this.isRental = false});

  final String status;
  final bool isRental;

  @override
  Widget build(BuildContext context) {
    final isOverdue = status == 'Overdue';
    final isDamaged = status == 'Damaged';
    final isRented = status == 'Rented';
    final isAvailable = status == 'Available' || status.contains('Available');

    final Color bg;
    final Color textCol;
    final List<List<dynamic>> icon;

    if (isOverdue || isDamaged) {
      bg = const Color(0xFFE74C3C).withValues(alpha: 0.12);
      textCol = const Color(0xFFE74C3C);
      icon = HugeIcons.strokeRoundedAlertCircle;
    } else if (isRented) {
      bg = AppColors.primarySoft.withValues(alpha: 0.2);
      textCol = AppColors.primaryDark;
      icon = HugeIcons.strokeRoundedClock01;
    } else if (isAvailable) {
      bg = AppColors.accent.withValues(alpha: 0.12);
      textCol = const Color(0xFF1E8449);
      icon = HugeIcons.strokeRoundedCheckmarkCircle02;
    } else {
      bg = AppColors.fieldBorder.withValues(alpha: 0.4);
      textCol = AppColors.textSecondary;
      icon = HugeIcons.strokeRoundedCheckmarkCircle02;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(icon, color: textCol, size: 14),
          const SizedBox(width: 5),
          Text(
            isRental ? 'Status: $status' : status,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textCol,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  final String label;
  final String value;
  final bool isBold;

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
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: isBold ? AppColors.primaryDark : AppColors.navy,
          ),
        ),
      ],
    );
  }
}
