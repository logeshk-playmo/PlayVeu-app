import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../state/app_facility_state.dart';
import '../../state/app_membership_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icon.dart';
import 'admin_ui.dart';

class AdminPlansScreen extends StatefulWidget {
  const AdminPlansScreen({super.key});

  @override
  State<AdminPlansScreen> createState() => _AdminPlansScreenState();
}

class _AdminPlansScreenState extends State<AdminPlansScreen> {
  @override
  void initState() {
    super.initState();
    AppMembershipState.plans.addListener(_onChanged);
  }

  @override
  void dispose() {
    AppMembershipState.plans.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final plans = AppMembershipState.plans.value;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      itemCount: plans.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final plan = plans[index];
        return AdminCard(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => AdminPlanEditorScreen(plan: plan),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      plan.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  AdminBadge(
                    label: plan.published ? 'Published' : 'Draft',
                    color: adminStatusColor(
                      plan.published ? 'Published' : 'Draft',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${plan.priceLabel}  ·  ${plan.duration}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '${plan.creditsGranted} credits',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  if (plan.discountPercent > 0) ...[
                    const SizedBox(width: 10),
                    Text(
                      '${plan.discountPercent}% off',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
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
  late final TextEditingController _subsidy;
  late String _duration;
  late String _subsidyBy;
  late bool _published;
  late List<CreditMapping> _mappings;

  static const _durations = ['Monthly', 'Quarterly', 'Yearly'];

  @override
  void initState() {
    super.initState();
    final plan = widget.plan;
    _name = TextEditingController(text: plan?.name ?? '');
    _price = TextEditingController(text: '${plan?.priceInr ?? 499}');
    _credits = TextEditingController(text: '${plan?.creditsGranted ?? 100}');
    _discount = TextEditingController(text: '${plan?.discountPercent ?? 0}');
    _subsidy = TextEditingController(text: '${plan?.subsidyCredits ?? 0}');
    _duration = plan?.duration ?? 'Monthly';
    _subsidyBy = plan?.subsidyBy ?? 'PlayVue';
    _published = plan?.published ?? false;
    _mappings = plan?.mappings.map((m) => m.copy()).toList() ?? [];
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _credits.dispose();
    _discount.dispose();
    _subsidy.dispose();
    super.dispose();
  }

  Future<void> _addMapping() async {
    final facilities = AppFacilityState.all;
    if (facilities.isEmpty) return;

    var facilityId = facilities.first['id'] as String;
    var facility = facilities.first;
    var sport = ((facility['games'] as List).cast<String>()).first;
    final creditsCtrl = TextEditingController(text: '40');

    final added = await showModalBottomSheet<CreditMapping>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            20 + MediaQuery.viewInsetsOf(ctx).bottom,
          ),
          child: StatefulBuilder(
            builder: (ctx, setLocal) {
              final sports = (facility['games'] as List).cast<String>();
              return Column(
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
                    'Credit mapping',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonHideUnderline(
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Facility'),
                      child: DropdownButton<String>(
                        value: facilityId,
                        isExpanded: true,
                        items: [
                          for (final f in facilities)
                            DropdownMenuItem(
                              value: f['id'] as String,
                              child: Text(f['name'] as String),
                            ),
                        ],
                        onChanged: (val) {
                          if (val == null) return;
                          setLocal(() {
                            facilityId = val;
                            facility =
                                facilities.firstWhere((f) => f['id'] == val);
                            sport = (facility['games'] as List)
                                .cast<String>()
                                .first;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonHideUnderline(
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Sport'),
                      child: DropdownButton<String>(
                        value: sport,
                        isExpanded: true,
                        items: [
                          for (final s in sports)
                            DropdownMenuItem(value: s, child: Text(s)),
                        ],
                        onChanged: (val) {
                          if (val != null) setLocal(() => sport = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: creditsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Credits / hour',
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(
                          ctx,
                          CreditMapping(
                            facilityId: facilityId,
                            sport: sport,
                            creditsPerHour: int.tryParse(creditsCtrl.text) ?? 40,
                          ),
                        );
                      },
                      child: const Text('Add mapping'),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );

    creditsCtrl.dispose();
    if (added != null) {
      setState(() => _mappings.add(added));
    }
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
        subsidyCredits: int.tryParse(_subsidy.text) ?? 0,
        subsidyBy: _subsidyBy,
        published: _published,
        mappings: _mappings,
      ),
    );
    Navigator.pop(context);
  }

  String _facilityName(String id) =>
      AppFacilityState.byId(id)?['name'] as String? ?? id;

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
                const AdminSectionLabel('Discount & subsidy'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _discount,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Discount %'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _subsidy,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Subsidy cr'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final by in ['PlayVue', 'Venue'])
                      AdminPill(
                        label: by,
                        selected: _subsidyBy == by,
                        onTap: () => setState(() => _subsidyBy = by),
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
                Row(
                  children: [
                    const Expanded(child: AdminSectionLabel('Credit mapping')),
                    TextButton(
                      onPressed: _addMapping,
                      child: const Text('Add'),
                    ),
                  ],
                ),
                if (_mappings.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Uses facility rates if empty.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                else
                  for (var i = 0; i < _mappings.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const AppIcon(
                            HugeIcons.strokeRoundedFootballPitch,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${_facilityName(_mappings[i].facilityId)} · ${_mappings[i].sport}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                          Text(
                            '${_mappings[i].creditsPerHour} / hr',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () =>
                                setState(() => _mappings.removeAt(i)),
                          ),
                        ],
                      ),
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
