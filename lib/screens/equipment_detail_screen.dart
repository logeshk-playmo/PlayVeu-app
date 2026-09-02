import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../state/app_catalogue_state.dart';
import '../state/app_rental_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';
import '../widgets/primary_button.dart';
import 'rental_confirmation_screen.dart';

class EquipmentDetailScreen extends StatelessWidget {
  const EquipmentDetailScreen({super.key, required this.item});

  final EquipmentItem item;

  void _handlePayOnline(BuildContext context) {
    final latest = AppCatalogueState.byId(item.id) ?? item;
    if (latest.stockCount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This item is out of stock.')),
      );
      return;
    }

    AppRentalState.rent(latest);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RentalConfirmationScreen(
          item: latest,
          creditsUsed: 0,
          remainingCredits: AppCreditsState.current,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

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
                  Image.network(
                    item.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.navy,
                      child: Center(
                        child: AppIcon(
                          item.icon,
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
                        item.category,
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
                          item.name,
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
                              '${item.rating}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF92400E),
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '(${item.reviews})',
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

                  // Sport Tag & Availability
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
                          item.sport,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppIcon(
                              HugeIcons.strokeRoundedCheckmarkCircle02,
                              color: AppColors.accent,
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              item.availability,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E8449),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

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
                              item.price,
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
                              item.deposit,
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
                  const SizedBox(height: 24),

                  // Description
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
                    item.description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Features List
                  if (item.features.isNotEmpty) ...[
                    const Text(
                      'Features & Inclusions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...item.features.map((feature) {
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
                              item.condition,
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
            child: PrimaryButton(
              label: 'Pay Online',
              onPressed: () => _handlePayOnline(context),
            ),
          ),
        ),
      ),
    );
  }
}
