import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';

class EquipmentScreen extends StatelessWidget {
  const EquipmentScreen({super.key});

  static const _items = <_EquipmentItem>[
    _EquipmentItem(
      name: 'Yonex Astrox Racket',
      sport: 'Badminton',
      price: '₹50 / hour',
      image:
          'https://images.unsplash.com/photo-1626225453014-a9ac938c647d?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedTennisRacket,
    ),
    _EquipmentItem(
      name: 'Football Size 5',
      sport: 'Football',
      price: '₹30 / hour',
      image:
          'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedFootball,
    ),
    _EquipmentItem(
      name: 'Cricket Kit',
      sport: 'Cricket',
      price: '₹80 / hour',
      image:
          'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedCricketBat,
    ),
    _EquipmentItem(
      name: 'TT Paddle Set',
      sport: 'Table Tennis',
      price: '₹40 / hour',
      image:
          'https://images.unsplash.com/photo-1609710228159-0fa9bd7c0827?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedTableTennisBat,
    ),
    _EquipmentItem(
      name: 'Chess Set',
      sport: 'Chess',
      price: '₹20 / session',
      image:
          'https://images.unsplash.com/photo-1529699211952-734e80c4d42b?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedChessKing,
    ),
    _EquipmentItem(
      name: 'Carrom Board',
      sport: 'Carrom',
      price: '₹35 / hour',
      image:
          'https://images.unsplash.com/photo-1575444758702-4a6b9222336e?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedGame,
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
              final item = _items[index];
              return _EquipmentCard(
                item: item,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item.name} rental coming soon')),
                  );
                },
              );
            }, childCount: _items.length),
          ),
        ),
      ],
    );
  }
}

class _EquipmentItem {
  const _EquipmentItem({
    required this.name,
    required this.sport,
    required this.price,
    required this.image,
    required this.icon,
  });

  final String name;
  final String sport;
  final String price;
  final String image;
  final List<List<dynamic>> icon;
}

class _EquipmentCard extends StatelessWidget {
  const _EquipmentCard({required this.item, required this.onTap});

  final _EquipmentItem item;
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
