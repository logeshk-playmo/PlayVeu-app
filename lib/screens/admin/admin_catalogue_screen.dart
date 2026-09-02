import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../state/app_catalogue_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icon.dart';
import 'admin_rentals_screen.dart';
import 'admin_ui.dart';

class AdminCatalogueScreen extends StatelessWidget {
  const AdminCatalogueScreen({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: const [
        _AdminCatalogueItemsPane(),
        AdminRentalsList(),
      ],
    );
  }
}

class _AdminCatalogueItemsPane extends StatefulWidget {
  const _AdminCatalogueItemsPane();

  @override
  State<_AdminCatalogueItemsPane> createState() =>
      _AdminCatalogueItemsPaneState();
}

class _AdminCatalogueItemsPaneState extends State<_AdminCatalogueItemsPane> {
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

  @override
  Widget build(BuildContext context) {
    final items = AppCatalogueState.items.value
        .where((item) => _filter == null || item.type == _filter)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              AdminPill(
                label: 'All',
                selected: _filter == null,
                onTap: () => setState(() => _filter = null),
              ),
              const SizedBox(width: 8),
              for (final type in CatalogueType.values) ...[
                AdminPill(
                  label: type.label,
                  selected: _filter == type,
                  onTap: () => setState(() => _filter = type),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (final item in items) ...[
          AdminCard(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => AdminCatalogueEditorScreen(item: item),
                ),
              );
            },
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: AppIcon(item.icon, color: AppColors.primary, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item.type.label}  ·  ${item.price}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                AdminBadge(
                  label: item.published ? 'Live' : 'Hidden',
                  color: adminStatusColor(item.published ? 'Live' : 'Hidden'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class AdminCatalogueEditorScreen extends StatefulWidget {
  const AdminCatalogueEditorScreen({super.key, this.item});

  final EquipmentItem? item;

  @override
  State<AdminCatalogueEditorScreen> createState() =>
      _AdminCatalogueEditorScreenState();
}

class _AdminCatalogueEditorScreenState extends State<AdminCatalogueEditorScreen> {
  late final TextEditingController _name;
  late final TextEditingController _sport;
  late final TextEditingController _price;
  late final TextEditingController _category;
  late final TextEditingController _deposit;
  late final TextEditingController _stock;
  late CatalogueType _type;
  late bool _published;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _name = TextEditingController(text: item?.name ?? '');
    _sport = TextEditingController(text: item?.sport ?? 'Badminton');
    _price = TextEditingController(text: item?.price ?? '₹50 / hour');
    _category = TextEditingController(text: item?.category ?? 'Equipment');
    _deposit = TextEditingController(text: item?.deposit ?? '₹100 (Refundable)');
    _stock = TextEditingController(text: '${item?.stockCount ?? 1}');
    _type = item?.type ?? CatalogueType.equipment;
    _published = item?.published ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _sport.dispose();
    _price.dispose();
    _category.dispose();
    _deposit.dispose();
    _stock.dispose();
    super.dispose();
  }

  void _save() {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    final stock = int.tryParse(_stock.text) ?? 1;

    final item = (widget.item ??
            EquipmentItem(
              id: 'eq_${DateTime.now().millisecondsSinceEpoch}',
              name: name,
              sport: _sport.text.trim(),
              price: _price.text.trim(),
              image: widget.item?.image ??
                  'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=60',
              icon: HugeIcons.strokeRoundedDumbbell02,
              category: _category.text.trim(),
              description: widget.item?.description ?? 'Added by admin.',
              features: widget.item?.features ?? const ['Available for rental'],
              availability: 'In Stock ($stock Available)',
            ))
        .copyWith(
          name: name,
          sport: _sport.text.trim(),
          price: _price.text.trim(),
          category: _category.text.trim(),
          deposit: _deposit.text.trim(),
          stockCount: stock,
          availability: 'In Stock ($stock Available)',
          type: _type,
          published: _published,
          id: widget.item?.id ?? 'eq_${DateTime.now().millisecondsSinceEpoch}',
        );

    AppCatalogueState.upsert(item);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      appBar: AppBar(
        title: Text(widget.item == null ? 'New item' : 'Edit item'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdminSectionLabel('Item'),
                const SizedBox(height: 12),
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _sport,
                        decoration: const InputDecoration(labelText: 'Sport'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _price,
                        decoration: const InputDecoration(labelText: 'Price'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _category,
                        decoration: const InputDecoration(labelText: 'Category'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _stock,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Stock'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _deposit,
                  decoration: const InputDecoration(labelText: 'Deposit'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdminSectionLabel('Type'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final type in CatalogueType.values)
                      AdminPill(
                        label: type.label,
                        selected: _type == type,
                        onTap: () => setState(() => _type = type),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AdminCard(
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Published',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Visible to players',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _published,
                  onChanged: (val) => setState(() => _published = val),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AdminSaveBar(
        label: 'Save item',
        onPressed: _save,
      ),
    );
  }
}
