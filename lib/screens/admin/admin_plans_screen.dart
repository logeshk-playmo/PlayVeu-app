import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../state/app_membership_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icon.dart';
import 'admin_bookings_screen.dart';
import 'admin_player_list_screen.dart';
import 'admin_revenue_screen.dart';
import 'admin_ui.dart';

class AdminPlansScreen extends StatefulWidget {
  const AdminPlansScreen({
    super.key,
    this.onOpenProfile,
    this.onOpenFacilities,
    this.onOpenBookings,
    this.onOpenCatalogue,
    this.onOpenCatalogueRentals,
  });

  final VoidCallback? onOpenProfile;
  final VoidCallback? onOpenFacilities;
  final VoidCallback? onOpenBookings;
  final VoidCallback? onOpenCatalogue;
  final VoidCallback? onOpenCatalogueRentals;

  @override
  State<AdminPlansScreen> createState() => _AdminPlansScreenState();
}

class _AdminPlansScreenState extends State<AdminPlansScreen> {
  @override
  void initState() {
    super.initState();
    AppMembershipState.plans.addListener(_onPlansChanged);
  }

  @override
  void dispose() {
    AppMembershipState.plans.removeListener(_onPlansChanged);
    super.dispose();
  }

  void _onPlansChanged() {
    if (mounted) setState(() {});
  }

  Widget _buildHomePlanCard(BuildContext context, MembershipPlan plan) {
    final durationText =
        plan.duration.isNotEmpty ? plan.duration : '30 Days';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => AdminPlanEditorScreen(plan: plan),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 175,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.fieldBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${plan.priceLabel} / ${plan.duration}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${plan.creditsGranted} Credits',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Duration: $durationText',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnifiedKpiCard() {
    return Container(
      decoration: AppSurfaces.card(),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildKpiItem(
                  icon: HugeIcons.strokeRoundedCoins01,
                  iconColor: const Color(0xFF10B981),
                  label: "Today's Revenue",
                  value: '₹24,500',
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: AppColors.fieldBorder.withValues(alpha: 0.7),
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              Expanded(
                child: _buildKpiItem(
                  icon: HugeIcons.strokeRoundedCalendar03,
                  iconColor: AppColors.primary,
                  label: "Today's Bookings",
                  value: '42',
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              height: 1,
              color: AppColors.fieldBorder.withValues(alpha: 0.7),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _buildKpiItem(
                  icon: HugeIcons.strokeRoundedUserGroup,
                  iconColor: const Color(0xFF6366F1),
                  label: 'Players',
                  value: '128',
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: AppColors.fieldBorder.withValues(alpha: 0.7),
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              Expanded(
                child: _buildKpiItem(
                  icon: HugeIcons.strokeRoundedTennisRacket,
                  iconColor: const Color(0xFFF59E0B),
                  label: 'Courts',
                  value: '8 / 12',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKpiItem({
    required List<List<dynamic>> icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: AppIcon(
              icon,
              size: 19,
              color: iconColor,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildRevenueRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }

  Widget _buildUtilisationRow(String sport, double fraction, String percent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              sport,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
            Text(
              percent,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 8,
            backgroundColor: AppColors.fieldBorder.withValues(alpha: 0.5),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentStat(String count, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttentionRow({
    required IconData icon,
    required Color color,
    required String text,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerRow(String name, String initial) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
          child: Text(
            initial,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
        ),
        const AdminBadge(label: 'Active', color: Color(0xFF2ECC71)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        // 1. Admin Home Header
        const Text(
          'Good Morning, Admin 👋',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 16),

        // 2. Unified KPI Dashboard Card
        _buildUnifiedKpiCard(),
        const SizedBox(height: 20),

        // 3. Plans
        const AdminSectionLabel('Plans'),
        const SizedBox(height: 10),
        SizedBox(
          height: 135,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: AppMembershipState.plans.value.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final plan = AppMembershipState.plans.value[index];
              return _buildHomePlanCard(context, plan);
            },
          ),
        ),
        const SizedBox(height: 22),

        // 4. Revenue Overview
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AdminSectionLabel('Revenue Overview'),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AdminRevenueScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: [
                    Text(
                      'View Detail',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        AdminCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            children: [
              _buildRevenueRow('Venue Booking', '₹1,20,000'),
              const Divider(height: 16, color: AppColors.fieldBorder),
              _buildRevenueRow('Membership', '₹40,000'),
              const Divider(height: 16, color: AppColors.fieldBorder),
              _buildRevenueRow('Equipment Rental', '₹14,500'),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // 6. Court Utilisation
        const AdminSectionLabel('Court Utilisation'),
        const SizedBox(height: 10),
        AdminCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            children: [
              _buildUtilisationRow('Badminton', 0.90, '90%'),
              const SizedBox(height: 12),
              _buildUtilisationRow('Football', 0.70, '70%'),
              const SizedBox(height: 12),
              _buildUtilisationRow('Cricket', 0.80, '80%'),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // 7. Equipment
        const AdminSectionLabel('Equipment'),
        const SizedBox(height: 10),
        AdminCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildEquipmentStat('156', 'Total', AppColors.navy),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildEquipmentStat(
                      '121',
                      'Available',
                      const Color(0xFF2ECC71),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildEquipmentStat(
                      '28',
                      'Rented',
                      AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildEquipmentStat(
                      '7',
                      'Damaged',
                      const Color(0xFFE74C3C),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // 8. Attention Required
        const Row(
          children: [
            Text('⚠️', style: TextStyle(fontSize: 15)),
            SizedBox(width: 6),
            AdminSectionLabel('Attention Required'),
          ],
        ),
        const SizedBox(height: 10),
        AdminCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              _buildAttentionRow(
                icon: Icons.access_time_rounded,
                color: const Color(0xFFE67E22),
                text: '3 Overdue Rentals',
                onTap: widget.onOpenCatalogueRentals ??
                    widget.onOpenCatalogue,
              ),
              const Divider(height: 16, color: AppColors.fieldBorder),
              _buildAttentionRow(
                icon: Icons.warning_amber_rounded,
                color: const Color(0xFFE74C3C),
                text: '2 Damaged Items',
                onTap: widget.onOpenCatalogueRentals ??
                    widget.onOpenCatalogue,
              ),
              const Divider(height: 16, color: AppColors.fieldBorder),
              _buildAttentionRow(
                icon: Icons.pending_actions_rounded,
                color: AppColors.primary,
                text: '4 Pending Bookings',
                onTap: widget.onOpenBookings ??
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const AdminBookingsScreen(),
                        ),
                      );
                    },
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // 9. Recent Players
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AdminSectionLabel('Recent Players'),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AdminPlayerListScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        AdminCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              _buildPlayerRow('Rahul Kumar', 'R'),
              const Divider(height: 16, color: AppColors.fieldBorder),
              _buildPlayerRow('Arun Kumar', 'A'),
              const Divider(height: 16, color: AppColors.fieldBorder),
              _buildPlayerRow('Vijay Kumar', 'V'),
            ],
          ),
        ),
      ],
    );
  }
}

class AdminPlanEditorScreen extends StatefulWidget {
  const AdminPlanEditorScreen({super.key, this.plan});

  final MembershipPlan? plan;

  @override
  State<AdminPlanEditorScreen> createState() => _AdminPlanEditorScreenState();
}

class _AdminPlanEditorScreenState extends State<AdminPlanEditorScreen> {
  late final TextEditingController _name;
  late final TextEditingController _price;
  late final TextEditingController _credits;
  late final TextEditingController _discount;
  late String _duration;
  late bool _published;

  static const _durations = ['Monthly', 'Quarterly', 'Yearly'];

  @override
  void initState() {
    super.initState();
    final plan = widget.plan;
    _name = TextEditingController(text: plan?.name ?? '');
    _price = TextEditingController(text: '${plan?.priceInr ?? 499}');
    _credits = TextEditingController(text: '${plan?.creditsGranted ?? 100}');
    _discount = TextEditingController(text: '${plan?.discountPercent ?? 0}');
    _duration = plan?.duration ?? 'Monthly';
    _published = plan?.published ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _credits.dispose();
    _discount.dispose();
    super.dispose();
  }

  void _save() {
    final name = _name.text.trim();
    if (name.isEmpty) return;

    AppMembershipState.upsert(
      MembershipPlan(
        id: widget.plan?.id ?? 'plan_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        priceInr: int.tryParse(_price.text) ?? 0,
        duration: _duration,
        creditsGranted: int.tryParse(_credits.text) ?? 0,
        discountPercent: int.tryParse(_discount.text) ?? 0,
        subsidyCredits: 0,
        subsidyBy: 'PlayVue',
        published: _published,
        mappings: widget.plan?.mappings ?? const [],
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      appBar: AppBar(
        title: Text(widget.plan == null ? 'New plan' : 'Edit plan'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdminSectionLabel('Plan'),
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
                        controller: _price,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Price ₹'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _credits,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Credits'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final d in _durations)
                      AdminPill(
                        label: d,
                        selected: _duration == d,
                        onTap: () => setState(() => _duration = d),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdminSectionLabel('Discount'),
                const SizedBox(height: 12),
                TextField(
                  controller: _discount,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Discount %'),
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
        label: 'Save plan',
        onPressed: _save,
      ),
    );
  }
}
