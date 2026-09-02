import 'package:flutter/material.dart';

import '../state/app_catalogue_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';
import '../widgets/filter_pill.dart';
import 'equipment_detail_screen.dart';

export '../state/app_catalogue_state.dart' show EquipmentItem, CatalogueType;

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  static List<EquipmentItem> get items => AppCatalogueState.published;

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  CatalogueType? _filter;

  @override
  void initState() {
    super.initState();
    AppCatalogueState.items.addListener(_onChanged);
  }

  @override
  void dispose() {
    AppCatalogueState.items.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  List<EquipmentItem> get _visible {
    final all = AppCatalogueState.published;
    if (_filter == null) return all;
    return all.where((item) => item.type == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _visible;
    return CustomScrollView(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 8),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Rent gear for your next game',
              style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          sliver: SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterPill(
                    label: 'All',
                    selected: _filter == null,
                    onTap: () => setState(() => _filter = null),
                  ),
                  const SizedBox(width: 8),
                  for (final type in CatalogueType.values) ...[
                    FilterPill(
                      label: type.label,
                      selected: _filter == type,
                      onTap: () => setState(() => _filter = type),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
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
