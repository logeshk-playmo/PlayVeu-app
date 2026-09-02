import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../state/app_facility_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icon.dart';
import 'admin_ui.dart';

class AdminFacilitiesScreen extends StatefulWidget {
  const AdminFacilitiesScreen({super.key});

  @override
  State<AdminFacilitiesScreen> createState() => _AdminFacilitiesScreenState();
}

class _AdminFacilitiesScreenState extends State<AdminFacilitiesScreen> {
  @override
  void initState() {
    super.initState();
    AppFacilityState.facilities.addListener(_onChanged);
  }

  @override
  void dispose() {
    AppFacilityState.facilities.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final facilities = AppFacilityState.all;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      itemCount: facilities.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final venue = facilities[index];
        final status = venue['status'] as String? ?? 'Open';
        final games = (venue['games'] as List).cast<String>();

        return AdminCard(
          padding: EdgeInsets.zero,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => AdminFacilityEditorScreen(venue: venue),
              ),
            );
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSurfaces.radius),
                  bottomLeft: Radius.circular(AppSurfaces.radius),
                ),
                child: Image.network(
                  venue['image'] as String,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 88,
                    height: 88,
                    color: AppColors.fieldBorder,
                    child: const AppIcon(
                      HugeIcons.strokeRoundedFootballPitch,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              venue['name'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                          AdminBadge(
                            label: status,
                            color: adminStatusColor(status),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        venue['location'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        games.take(2).join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
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
        );
      },
    );
  }
}

class AdminFacilityEditorScreen extends StatefulWidget {
  const AdminFacilityEditorScreen({super.key, required this.venue});

  final Map<String, dynamic> venue;

  @override
  State<AdminFacilityEditorScreen> createState() =>
      _AdminFacilityEditorScreenState();
}

class _AdminFacilityEditorScreenState extends State<AdminFacilityEditorScreen> {
  static const _statuses = ['Open', 'Closed', 'Maintenance', 'Hidden'];

  late String _status;
  late final TextEditingController _slot;
  late final TextEditingController _advance;
  late final TextEditingController _cancellation;
  late final TextEditingController _included;
  late Map<String, int> _creditRates;
  late Map<String, TextEditingController> _rateControllers;

  @override
  void initState() {
    super.initState();
    _status = widget.venue['status'] as String? ?? 'Open';
    _slot = TextEditingController(
      text: '${widget.venue['rentalSlotMinutes'] ?? 30}',
    );
    _advance = TextEditingController(
      text: '${widget.venue['advanceBookingDays'] ?? 30}',
    );
    _cancellation = TextEditingController(
      text: widget.venue['cancellationNote'] as String? ?? '',
    );
    _included = TextEditingController(
      text: widget.venue['includedNote'] as String? ?? '',
    );
    _creditRates = Map<String, int>.from(
      (widget.venue['creditRates'] as Map?) ?? {},
    );
    final games = (widget.venue['games'] as List).cast<String>();
    _rateControllers = {
      for (final sport in games)
        sport: TextEditingController(
          text: _creditRates[sport]?.toString() ?? '',
        ),
    };
  }

  @override
  void dispose() {
    _slot.dispose();
    _advance.dispose();
    _cancellation.dispose();
    _included.dispose();
    for (final controller in _rateControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _save() {
    for (final entry in _rateControllers.entries) {
      final parsed = int.tryParse(entry.value.text);
      if (parsed == null) {
        _creditRates.remove(entry.key);
      } else {
        _creditRates[entry.key] = parsed;
      }
    }
    final venue = Map<String, dynamic>.from(widget.venue);
    venue['status'] = _status;
    venue['rentalSlotMinutes'] = int.tryParse(_slot.text) ?? 30;
    venue['advanceBookingDays'] = int.tryParse(_advance.text) ?? 30;
    venue['cancellationNote'] = _cancellation.text.trim();
    venue['includedNote'] = _included.text.trim();
    venue['creditRates'] = Map<String, int>.from(_creditRates);
    AppFacilityState.upsert(venue);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final games = (widget.venue['games'] as List).cast<String>();

    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      appBar: AppBar(title: Text(widget.venue['name'] as String)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdminSectionLabel('Status'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final status in _statuses)
                      AdminPill(
                        label: status,
                        selected: _status == status,
                        onTap: () => setState(() => _status = status),
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
                const AdminSectionLabel('Rental'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _slot,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Slot (min)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _advance,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Advance (days)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _included,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Included'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _cancellation,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Cancellation'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdminSectionLabel('Credits / hour'),
                const SizedBox(height: 4),
                const Text(
                  'Leave blank to use ₹ ÷ 10.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                for (final sport in games) ...[
                  TextField(
                    controller: _rateControllers[sport],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: sport),
                  ),
                  if (sport != games.last) const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AdminSaveBar(
        label: 'Save facility',
        onPressed: _save,
      ),
    );
  }
}
