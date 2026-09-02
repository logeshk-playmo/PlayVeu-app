import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';

class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({super.key, required this.sport});

  final String sport;

  @override
  State<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _prizeController;
  late final TextEditingController _rulesController;

  String _selectedVenue = 'PlayVue Sports Academy';
  DateTime _startDate = DateTime.now().add(const Duration(days: 7));
  final TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  final TimeOfDay _endTime = const TimeOfDay(hour: 18, minute: 0);
  String _selectedFormat = 'Knockout';
  String _maxTeams = '8 Teams';
  String _entryFee = 'Free';
  String _visibility = 'Public';

  static const _venues = [
    'PlayVue Sports Academy',
    'Smash Arena',
    'Champions Sports Club',
    'Elite Sports Arena',
  ];

  static const _formats = ['Knockout', 'Round Robin', 'League'];
  static const _teamOptions = ['4 Teams', '8 Teams', '16 Teams', '32 Teams'];
  static const _entryFees = ['Free', '50 Credits', '100 Credits', '200 Credits'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: '${widget.sport} Championship Cup',
    );
    _prizeController = TextEditingController(
      text: 'Trophy & 500 Credits',
    );
    _rulesController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _prizeController.dispose();
    _rulesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (date != null) {
      setState(() => _startDate = date);
    }
  }

  String _formatTime(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  void _submitTournament() {
    if (!_formKey.currentState!.validate()) return;

    final tournamentTitle = _titleController.text.trim();
    final prize = _prizeController.text.trim();
    final dateStr = DateFormat('dd MMM yyyy').format(_startDate);
    final timeStr = '${_formatTime(_startTime)} - ${_formatTime(_endTime)}';

    AppPlayState.addTournament(
      sport: widget.sport,
      title: tournamentTitle,
      venue: _selectedVenue,
      date: dateStr,
      time: timeStr,
      format: _selectedFormat,
      maxTeams: _maxTeams,
      entryFee: _entryFee,
      prize: prize,
      visibility: _visibility,
    );

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF7E6),
                  shape: BoxShape.circle,
                ),
                child: const AppIcon(
                  HugeIcons.strokeRoundedChampion,
                  color: Color(0xFFE67E22),
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tournament Created! 🏆',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _visibility == 'Public'
                    ? 'Your ${widget.sport} tournament is now live for team registrations.'
                    : 'Your private ${widget.sport} tournament has been created and saved in My Games.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.backgroundBottom,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.fieldBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SummaryRow(label: 'Tournament', value: tournamentTitle),
                    const SizedBox(height: 6),
                    _SummaryRow(label: 'Sport', value: widget.sport),
                    const SizedBox(height: 6),
                    _SummaryRow(label: 'Venue', value: _selectedVenue),
                    const SizedBox(height: 6),
                    _SummaryRow(label: 'Format', value: _selectedFormat),
                    const SizedBox(height: 6),
                    _SummaryRow(label: 'Teams', value: _maxTeams),
                    const SizedBox(height: 6),
                    _SummaryRow(label: 'Date & Time', value: '$dateStr, $timeStr'),
                    const SizedBox(height: 6),
                    _SummaryRow(label: 'Prize', value: prize),
                    const SizedBox(height: 6),
                    _SummaryRow(label: 'Visibility', value: _visibility),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(dialogCtx); // Close dialog
                    Navigator.pop(context); // Pop CreateTournamentScreen
                    Navigator.pop(context); // Pop SelectSportScreen
                  },
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMMM yyyy').format(_startDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Tournament'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sport Banner Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: AppSurfaces.card(),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFECC8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const AppIcon(
                        HugeIcons.strokeRoundedChampion,
                        color: Color(0xFFC77700),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selected Sport',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            widget.sport,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tournament Title Field
              const _FormLabel('Tournament Title'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'e.g. Playveuw Premier Cup',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.fieldBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.fieldBorder),
                  ),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Enter tournament title' : null,
              ),
              const SizedBox(height: 20),

              // Venue Selection
              const _FormLabel('Tournament Venue'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.fieldBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedVenue,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.navy,
                    ),
                    items: _venues.map((venue) {
                      return DropdownMenuItem(
                        value: venue,
                        child: Text(
                          venue,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedVenue = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Date Picker
              const _FormLabel('Tournament Date'),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: AppSurfaces.card(),
                  child: Row(
                    children: [
                      const AppIcon(
                        HugeIcons.strokeRoundedCalendar03,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Format Selection
              const _FormLabel('Tournament Format'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _formats.map((fmt) {
                  final isSelected = _selectedFormat == fmt;
                  return ChoiceChip(
                    label: Text(fmt),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _selectedFormat = fmt),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.navy,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Max Teams Selection
              const _FormLabel('Max Teams / Participants'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _teamOptions.map((opt) {
                  final isSelected = _maxTeams == opt;
                  return ChoiceChip(
                    label: Text(opt),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _maxTeams = opt),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.navy,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Entry Fee Selection
              const _FormLabel('Entry Fee'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _entryFees.map((fee) {
                  final isSelected = _entryFee == fee;
                  return ChoiceChip(
                    label: Text(fee),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _entryFee = fee),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.navy,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Prize / Rewards Field
              const _FormLabel('Prizes & Rewards'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _prizeController,
                decoration: InputDecoration(
                  hintText: 'e.g. Trophy + 500 Credits',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.fieldBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.fieldBorder),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Visibility
              const _FormLabel('Visibility'),
              const SizedBox(height: 8),
              _VisibilityOptionCard(
                title: 'Public',
                subtitle: 'Anyone can discover and request to join',
                icon: HugeIcons.strokeRoundedGlobe02,
                isSelected: _visibility == 'Public',
                onTap: () => setState(() => _visibility = 'Public'),
              ),
              const SizedBox(height: 10),
              _VisibilityOptionCard(
                title: 'Private',
                subtitle: 'Only invited users can participate',
                icon: HugeIcons.strokeRoundedLock,
                isSelected: _visibility == 'Private',
                onTap: () => setState(() => _visibility = 'Private'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: AppSurfaces.bar,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submitTournament,
                child: const Text('CREATE TOURNAMENT'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VisibilityOptionCard extends StatelessWidget {
  const _VisibilityOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final dynamic icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE8F6FF) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.fieldBorder,
              width: isSelected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.backgroundTop,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: AppIcon(
                    icon,
                    size: 20,
                    color: isSelected ? Colors.white : AppColors.navy,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? AppColors.navy : AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                color: isSelected ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.5),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  const _FormLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}
