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
  const AdminFacilityEditorScreen({super.key, this.venue});

  final Map<String, dynamic>? venue;

  @override
  State<AdminFacilityEditorScreen> createState() =>
      _AdminFacilityEditorScreenState();
}

class _AdminFacilityEditorScreenState extends State<AdminFacilityEditorScreen> {
  static const _statuses = ['Open', 'Closed', 'Maintenance', 'Hidden'];
  static const _availableSports = [
    'Badminton',
    'Football',
    'Cricket',
    'Table Tennis',
    'Tennis',
    'Carrom',
    'Chess',
    'Squash',
    'Basketball',
  ];

  late String _status;
  late final TextEditingController _name;
  late final TextEditingController _type;
  late final TextEditingController _location;
  late final TextEditingController _description;
  late final TextEditingController _capacity;
  late final TextEditingController _price;
  late final TextEditingController _hours;
  String? _photoUrl;
  late final TextEditingController _slot;
  late final TextEditingController _advance;
  late final TextEditingController _cancellation;
  late final TextEditingController _included;
  late List<String> _selectedGames;
  late Map<String, int> _creditRates;
  late Map<String, TextEditingController> _rateControllers;

  @override
  void initState() {
    super.initState();
    final v = widget.venue;
    _status = v?['status'] as String? ?? 'Open';
    _name = TextEditingController(text: v?['name'] as String? ?? '');
    _type = TextEditingController(text: v?['type'] as String? ?? 'Sports Academy');
    _location = TextEditingController(text: v?['location'] as String? ?? '');
    _description = TextEditingController(text: v?['description'] as String? ?? '');
    _capacity = TextEditingController(text: v?['capacity'] as String? ?? '4 Courts');
    _price = TextEditingController(
      text: '${(v?['pricing'] as Map?)?['1 Hour'] ?? 500}',
    );
    _hours = TextEditingController(text: v?['hours'] as String? ?? '6:00 AM - 10:00 PM');
    _photoUrl = v?['image'] as String?;
    _slot = TextEditingController(
      text: '${v?['rentalSlotMinutes'] ?? 30}',
    );
    _advance = TextEditingController(
      text: '${v?['advanceBookingDays'] ?? 30}',
    );
    _cancellation = TextEditingController(
      text: v?['cancellationNote'] as String? ?? '',
    );
    _included = TextEditingController(
      text: v?['includedNote'] as String? ?? '',
    );
    _creditRates = Map<String, int>.from(
      (v?['creditRates'] as Map?) ?? {},
    );

    if (v != null && v['games'] is List) {
      _selectedGames = List<String>.from(v['games'] as List);
    } else {
      _selectedGames = ['Badminton', 'Football'];
    }

    _rateControllers = {
      for (final sport in _selectedGames)
        sport: TextEditingController(
          text: _creditRates[sport]?.toString() ?? '',
        ),
    };
  }

  @override
  void dispose() {
    _name.dispose();
    _type.dispose();
    _location.dispose();
    _description.dispose();
    _capacity.dispose();
    _price.dispose();
    _hours.dispose();
    _slot.dispose();
    _advance.dispose();
    _cancellation.dispose();
    _included.dispose();
    for (final controller in _rateControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showPhotoPicker() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Facility Photo',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8F4FD),
                  child: Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                ),
                title: const Text('Take Photo'),
                subtitle: const Text('Use device camera'),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _photoUrl =
                        'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&auto=format&fit=crop&q=60';
                  });
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8F4FD),
                  child: Icon(Icons.photo_library_rounded, color: AppColors.primary),
                ),
                title: const Text('Choose from Gallery'),
                subtitle: const Text('Select from device photos'),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _photoUrl =
                        'https://images.unsplash.com/photo-1521537634581-0dced2fee2ef?w=800&auto=format&fit=crop&q=60';
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleSport(String sport) {
    setState(() {
      if (_selectedGames.contains(sport)) {
        if (_selectedGames.length > 1) {
          _selectedGames.remove(sport);
          _rateControllers[sport]?.dispose();
          _rateControllers.remove(sport);
        }
      } else {
        _selectedGames.add(sport);
        _rateControllers[sport] = TextEditingController(
          text: _creditRates[sport]?.toString() ?? '',
        );
      }
    });
  }

  void _save() {
    final name = _name.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a facility name.')),
      );
      return;
    }

    final location = _location.text.trim();
    if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a location.')),
      );
      return;
    }

    for (final entry in _rateControllers.entries) {
      final parsed = int.tryParse(entry.value.text);
      if (parsed == null) {
        _creditRates.remove(entry.key);
      } else {
        _creditRates[entry.key] = parsed;
      }
    }

    final isNew = widget.venue == null;
    final venueId = isNew
        ? 'v_${DateTime.now().millisecondsSinceEpoch}'
        : (widget.venue!['id'] as String);

    const defaultImg =
        'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&auto=format&fit=crop&q=60';
    final imageUrl = _photoUrl?.isNotEmpty == true ? _photoUrl! : defaultImg;
    final hourlyPrice = int.tryParse(_price.text.trim()) ?? 500;

    final venue = <String, dynamic>{
      'id': venueId,
      'name': name,
      'type': _type.text.trim().isEmpty ? 'Sports Academy' : _type.text.trim(),
      'location': location,
      'description': _description.text.trim().isEmpty
          ? 'A modern sports facility offering premier courts and sports amenities.'
          : _description.text.trim(),
      'games': List<String>.from(_selectedGames),
      'facilities': widget.venue?['facilities'] ??
          ['Parking', 'Changing Rooms', 'Drinking Water'],
      'hours': _hours.text.trim().isEmpty ? '6:00 AM - 10:00 PM' : _hours.text.trim(),
      'capacity': _capacity.text.trim().isEmpty ? '4 Courts' : _capacity.text.trim(),
      'image': imageUrl,
      'images': [imageUrl],
      'rating': widget.venue?['rating'] ?? 4.8,
      'reviews': widget.venue?['reviews'] ?? 1,
      'distance': widget.venue?['distance'] ?? '~2.0 Kms',
      'pricing': {
        '30 Mins': (hourlyPrice * 0.6).round(),
        '1 Hour': hourlyPrice,
        '2 Hours': (hourlyPrice * 1.8).round(),
      },
      'status': _status,
      'rentalSlotMinutes': int.tryParse(_slot.text) ?? 30,
      'advanceBookingDays': int.tryParse(_advance.text) ?? 30,
      'cancellationNote': _cancellation.text.trim().isEmpty
          ? 'Free cancellation up to 2 hours before the slot.'
          : _cancellation.text.trim(),
      'includedNote': _included.text.trim().isEmpty
          ? 'Court, lighting, and drinking water included.'
          : _included.text.trim(),
      'creditRates': Map<String, int>.from(_creditRates),
    };

    AppFacilityState.upsert(venue);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isNew ? 'Facility "$name" added successfully.' : 'Facility "$name" updated.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.venue == null;

    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      appBar: AppBar(
        title: Text(isNew ? 'Add Facility' : (widget.venue!['name'] as String)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          // Basic Info
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdminSectionLabel('Facility Details'),
                const SizedBox(height: 12),
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: 'Facility Name *',
                    hintText: 'e.g. Smash Zone Arena',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _type,
                        decoration: const InputDecoration(
                          labelText: 'Facility Type',
                          hintText: 'e.g. Sports Complex',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _capacity,
                        decoration: const InputDecoration(
                          labelText: 'Capacity / Courts',
                          hintText: 'e.g. 4 Courts',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _location,
                  decoration: const InputDecoration(
                    labelText: 'Location *',
                    hintText: 'e.g. Indiranagar, Bengaluru',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _description,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Brief summary of the facility and amenities...',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _price,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Hourly Price (₹)',
                          hintText: 'e.g. 500',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _hours,
                        decoration: const InputDecoration(
                          labelText: 'Operating Hours',
                          hintText: 'e.g. 6:00 AM - 10:00 PM',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Facility Photo',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 8),
                if (_photoUrl == null || _photoUrl!.isEmpty)
                  InkWell(
                    onTap: _showPhotoPicker,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundBottom,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.fieldBorder,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 28,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Upload Photo',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'JPG, PNG supported',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _photoUrl!,
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 160,
                        color: AppColors.backgroundBottom,
                        child: const Center(
                          child: Icon(
                            Icons.image_rounded,
                            size: 48,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _showPhotoPicker,
                    icon: const Icon(Icons.photo_camera_rounded, size: 16),
                    label: const Text('Change Photo'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryDark,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Sports Available
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdminSectionLabel('Supported Sports'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final sport in _availableSports)
                      AdminPill(
                        label: sport,
                        selected: _selectedGames.contains(sport),
                        onTap: () => _toggleSport(sport),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Status
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
          const SizedBox(height: 14),

          // Rental & Policies
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdminSectionLabel('Rental & Booking Settings'),
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
                  decoration: const InputDecoration(labelText: 'Included Note'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _cancellation,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Cancellation Note'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Credit Rates
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
                for (final sport in _selectedGames) ...[
                  TextField(
                    controller: _rateControllers[sport],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: sport),
                  ),
                  if (sport != _selectedGames.last) const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AdminSaveBar(
        label: isNew ? 'Add Facility' : 'Save facility',
        onPressed: _save,
      ),
    );
  }
}
