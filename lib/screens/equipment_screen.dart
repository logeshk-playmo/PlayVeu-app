import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';
import 'equipment_detail_screen.dart';

class EquipmentScreen extends StatelessWidget {
  const EquipmentScreen({super.key});

  static const items = <EquipmentItem>[
    EquipmentItem(
      name: 'Yonex Astrox Racket',
      sport: 'Badminton',
      price: '₹50 / hour',
      image:
          'https://images.unsplash.com/photo-1626225453014-a9ac938c647d?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedTennisRacket,
      category: 'Rackets & Bats',
      description:
          'High-performance graphite badminton racket designed for powerful smashes and quick swings. Pre-strung with high-durability Yonex BG65 string with comfortable grip wrap.',
      features: [
        'High-modulus graphite shaft',
        'Pre-strung with Yonex BG65 string (24 lbs)',
        'Isometric head shape for enlarged sweet spot',
        'Includes padded thermal head cover',
      ],
      availability: 'In Stock (8 Available)',
      condition: 'Excellent / Pro Grade',
      deposit: '₹200 (Refundable)',
      rating: 4.9,
      reviews: 38,
    ),
    EquipmentItem(
      name: 'Football Size 5',
      sport: 'Football',
      price: '₹30 / hour',
      image:
          'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedFootball,
      category: 'Balls & Inflatables',
      description:
          'Official FIFA standard size 5 match football. Features a 32-panel PU synthetic leather outer with high air retention bladder, suitable for turf and grass.',
      features: [
        'Official match size 5 specification',
        'All-weather textured PU surface for grip',
        'Reinforced butyl bladder for air retention',
        'Air pump & pressure gauge available at desk',
      ],
      availability: 'In Stock (12 Available)',
      condition: 'Tournament Ready',
      deposit: '₹100 (Refundable)',
      rating: 4.7,
      reviews: 45,
    ),
    EquipmentItem(
      name: 'Cricket Kit',
      sport: 'Cricket',
      price: '₹80 / hour',
      image:
          'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedCricketBat,
      category: 'Full Protection Kits',
      description:
          'Comprehensive cricket kit containing an English willow bat, premium batting leg guards, batting gloves, thigh pad, and a lightweight safety helmet.',
      features: [
        'Grade 1 English willow cricket bat',
        'Dual-density foam batting pads & gloves',
        'Adjustable grill safety helmet',
        'Compact carry kit bag included',
      ],
      availability: 'In Stock (4 Sets Available)',
      condition: 'Professional Grade',
      deposit: '₹300 (Refundable)',
      rating: 4.8,
      reviews: 29,
    ),
    EquipmentItem(
      name: 'TT Paddle Set',
      sport: 'Table Tennis',
      price: '₹40 / hour',
      image:
          'https://images.unsplash.com/photo-1609710228159-0fa9bd7c0827?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedTableTennisBat,
      category: 'Paddles & Table Gear',
      description:
          'Pair of ITTF approved ping pong paddles with spin-optimized rubber padding and comfortable flared wood handles. Includes 3 competition 3-star balls.',
      features: [
        '2 premium table tennis paddles',
        'ITTF approved spin & speed rubber',
        '3 seamless 3-star 40+ celluloid balls',
        'Protective zippered hard case',
      ],
      availability: 'In Stock (6 Sets Available)',
      condition: 'Excellent Condition',
      deposit: '₹150 (Refundable)',
      rating: 4.8,
      reviews: 32,
    ),
    EquipmentItem(
      name: 'Chess Set',
      sport: 'Chess',
      price: '₹20 / session',
      image:
          'https://images.unsplash.com/photo-1529699211952-734e80c4d42b?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedChessKing,
      category: 'Board Games',
      description:
          'Tournament standard weighted Staunton chess pieces with felted bottoms, rollup tournament board, and digital chess timer upon request.',
      features: [
        'Triple weighted Staunton regulation pieces',
        'Roll-up vinyl tournament board (20x20")',
        'Extra queens included for pawn promotion',
        'Optional DGT digital chess clock',
      ],
      availability: 'In Stock (10 Sets Available)',
      condition: 'Mint Condition',
      deposit: '₹100 (Refundable)',
      rating: 4.9,
      reviews: 21,
    ),
    EquipmentItem(
      name: 'Carrom Board',
      sport: 'Carrom',
      price: '₹35 / hour',
      image:
          'https://images.unsplash.com/photo-1575444758702-4a6b9222336e?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedGame,
      category: 'Board Games',
      description:
          'Full-size 32x32 inch champion carrom board crafted from smooth English birch ply with sturdy hardwood borders. Includes tournament coins, striker, and surface powder.',
      features: [
        '32x32 inch smooth English ply playing surface',
        'Heavy-duty 3-inch wooden borders for rebound',
        'Complete set of wooden coins & precision striker',
        'High-grade boric powder bottle included',
      ],
      availability: 'In Stock (5 Boards Available)',
      condition: 'Club Standard',
      deposit: '₹150 (Refundable)',
      rating: 4.6,
      reviews: 19,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Rent gear for your next game',
              style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 208,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = items[index];
              return _EquipmentCard(
                item: item,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EquipmentDetailScreen(item: item),
                    ),
                  );
                },
              );
            }, childCount: items.length),
          ),
        ),
      ],
    );
  }
}

class EquipmentItem {
  const EquipmentItem({
    required this.name,
    required this.sport,
    required this.price,
    required this.image,
    required this.icon,
    required this.category,
    required this.description,
    required this.features,
    required this.availability,
    this.condition = 'Excellent',
    this.deposit = '₹100 (Refundable)',
    this.rating = 4.8,
    this.reviews = 20,
  });

  final String name;
  final String sport;
  final String price;
  final String image;
  final List<List<dynamic>> icon;
  final String category;
  final String description;
  final List<String> features;
  final String availability;
  final String condition;
  final String deposit;
  final double rating;
  final int reviews;
}

class _EquipmentCard extends StatelessWidget {
  const _EquipmentCard({required this.item, required this.onTap});

  final EquipmentItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSurfaces.radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: AppSurfaces.card(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Image.network(
                    item.image,
                    height: 108,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 108,
                      color: AppColors.fieldBorder,
                      alignment: Alignment.center,
                      child: AppIcon(
                        item.icon,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.58),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.price.split(' / ').first,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          AppIcon(
                            item.icon,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.sport,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        item.price,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
