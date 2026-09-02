import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';
import 'booking_details_screen.dart';

class SelectSlotScreen extends StatefulWidget {
  const SelectSlotScreen({super.key, required this.venue});

  final Map<String, dynamic> venue;

  @override
  State<SelectSlotScreen> createState() => _SelectSlotScreenState();
}

class _SelectSlotScreenState extends State<SelectSlotScreen> {
  String? _selectedGame;
  String? _selectedCourt;
  DateTime? _selectedDate;
  bool _isFullDay = false;
  int _selectedHours = 1;
  int _selectedMinutes = 0;
  String? _selectedStartTime;

  late TimeOfDay _openTime;
  late TimeOfDay _closeTime;
  List<String> _availableTimeSlots = [];

  List<String> get _availableCourts {
    if (widget.venue['courts'] != null) {
      final rawCourts = widget.venue['courts'];
      if (rawCourts is Map && _selectedGame != null && rawCourts.containsKey(_selectedGame)) {
        return (rawCourts[_selectedGame] as List).cast<String>();
      } else if (rawCourts is List) {
        return rawCourts.cast<String>();
      }
    }

    final game = _selectedGame?.toLowerCase() ?? '';
    if (game.contains('football')) {
      return const ['Main Turf Pitch', 'Turf 2', '5-a-side Pitch'];
    } else if (game.contains('cricket')) {
      return const ['Box Net 1', 'Box Net 2', 'Main Pitch'];
    } else if (game.contains('tennis') && !game.contains('table')) {
      return const ['Center Court', 'Court 2', 'Court 3'];
    } else if (game.contains('table tennis')) {
      return const ['Table 1', 'Table 2', 'Table 3', 'Table 4'];
    } else if (game.contains('swimming')) {
      return const ['Lane 1-2', 'Lane 3-4', 'Main Pool'];
    } else if (game.contains('squash')) {
      return const ['Squash Court 1', 'Squash Court 2'];
    }

    return const ['Court 1', 'Court 2', 'Court 3', 'Court 4'];
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    if ((widget.venue['games'] as List?)?.isNotEmpty ?? false) {
      _selectedGame = widget.venue['games'][0];
    }
    _parseVenueOperatingHours();
    _updateAvailableTimeSlots();
  }

  void _parseVenueOperatingHours() {
    final hoursStr = widget.venue['hours'] as String?;
    if (hoursStr == null || !hoursStr.contains('-')) {
      _openTime = const TimeOfDay(hour: 6, minute: 0);
      _closeTime = const TimeOfDay(hour: 22, minute: 0);
      return;
    }
    final parts = hoursStr.split('-');
    if (parts.length != 2) {
      _openTime = const TimeOfDay(hour: 6, minute: 0);
      _closeTime = const TimeOfDay(hour: 22, minute: 0);
      return;
    }

    TimeOfDay parsePart(String s, TimeOfDay fallback) {
      final clean = s.trim();
      try {
        final dt = DateFormat('h:mm a').parse(clean);
        return TimeOfDay(hour: dt.hour, minute: dt.minute);
      } catch (_) {
        try {
          final dt = DateFormat('hh:mm a').parse(clean);
          return TimeOfDay(hour: dt.hour, minute: dt.minute);
        } catch (_) {
          return fallback;
        }
      }
    }

    _openTime = parsePart(parts[0], const TimeOfDay(hour: 6, minute: 0));
    _closeTime = parsePart(parts[1], const TimeOfDay(hour: 22, minute: 0));
  }

  String get _venueOpenTimeFormatted {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, _openTime.hour, _openTime.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  String get _venueCloseTimeFormatted {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, _closeTime.hour, _closeTime.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  int get _selectedDurationMinutes => _selectedHours * 60 + _selectedMinutes;

  int get _totalOperatingMinutes {
    final openMin = _openTime.hour * 60 + _openTime.minute;
    final closeMin = _closeTime.hour * 60 + _closeTime.minute;
    return (closeMin > openMin)
        ? (closeMin - openMin)
        : (24 * 60 - openMin + closeMin);
  }

  int _getStepMinutes(int durationMinutes) {
    if (durationMinutes <= 30) {
      return 30;
    } else if (durationMinutes == 60) {
      return 60;
    } else if (durationMinutes == 120) {
      return 120;
    } else if (durationMinutes == 180) {
      return 180;
    } else if (durationMinutes % 60 == 0) {
      return 60;
    } else {
      return 30;
    }
  }

  String _formatMinutesToTime(int totalMinutes) {
    final hour24 = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour24, minute);
    return DateFormat('hh:mm a').format(dt);
  }

  void _updateAvailableTimeSlots() {
    if (_isFullDay) {
      _availableTimeSlots = [];
      return;
    }

    final duration = _selectedDurationMinutes;
    final openMin = _openTime.hour * 60 + _openTime.minute;
    final closeMin = _closeTime.hour * 60 + _closeTime.minute;
    final latestStartMin = closeMin - duration;

    final stepMin = _getStepMinutes(duration);
    final List<String> slots = [];

    for (int m = openMin; m <= latestStartMin; m += stepMin) {
      slots.add(_formatMinutesToTime(m));
    }

    _availableTimeSlots = slots;

    if (_selectedStartTime != null && !_availableTimeSlots.contains(_selectedStartTime)) {
      _selectedStartTime = null;
    }
  }

  String _formatDuration(int hours, int minutes) {
    if (hours == 0) {
      return '$minutes Minutes';
    } else if (minutes == 0) {
      return hours == 1 ? '1 Hour' : '$hours Hours';
    } else {
      final hourPart = hours == 1 ? '1 Hour' : '$hours Hours';
      return '$hourPart $minutes Minutes';
    }
  }

  int get _payableAmount {
    final pricing = widget.venue['pricing'] as Map<String, dynamic>? ?? {};
    final hourlyRate = pricing['1 Hour'] as int? ?? 500;
    final halfHourRate = pricing['30 Mins'] as int? ?? (hourlyRate * 0.6).round();
    final twoHourRate = pricing['2 Hours'] as int? ?? (hourlyRate * 2 - 100);

    if (_isFullDay) {
      if (pricing.containsKey('Full Day')) {
        return pricing['Full Day'] as int;
      }
      final totalHours = _totalOperatingMinutes / 60.0;
      final rawPrice = totalHours * hourlyRate * 0.7;
      return (rawPrice / 100).round() * 100;
    }

    final exactKey = _formatDuration(_selectedHours, _selectedMinutes);
    if (pricing.containsKey(exactKey)) {
      return pricing[exactKey] as int;
    }
    if (_selectedHours == 0 && _selectedMinutes == 30 && pricing.containsKey('30 Mins')) {
      return pricing['30 Mins'] as int;
    }
    if (_selectedHours == 1 && _selectedMinutes == 0 && pricing.containsKey('1 Hour')) {
      return pricing['1 Hour'] as int;
    }
    if (_selectedHours == 2 && _selectedMinutes == 0 && pricing.containsKey('2 Hours')) {
      return pricing['2 Hours'] as int;
    }

    final discountPer2Hours = (hourlyRate * 2) - twoHourRate;
    final basePrice = (_selectedHours * hourlyRate) +
        (_selectedMinutes == 30 ? halfHourRate : 0);
    final discount = (_selectedHours ~/ 2) * discountPer2Hours;
    return basePrice - discount;
  }

  int get _payableCredits => _payableAmount ~/ 10;

  String _calculateEndTime(String startTime, int durationMinutes) {
    try {
      final format = DateFormat('hh:mm a');
      final start = format.parse(startTime);
      final end = start.add(Duration(minutes: durationMinutes));
      return format.format(end);
    } catch (_) {
      try {
        final format = DateFormat('h:mm a');
        final start = format.parse(startTime);
        final end = start.add(Duration(minutes: durationMinutes));
        return DateFormat('hh:mm a').format(end);
      } catch (_) {
        return startTime;
      }
    }
  }

  bool get _canDecrementHours {
    if (_selectedHours > 1) return true;
    if (_selectedHours == 1 && _selectedMinutes == 30) return true;
    if (_selectedHours == 1 && _selectedMinutes == 0) return true;
    return false;
  }

  bool get _canIncrementHours {
    final nextMin = (_selectedHours + 1) * 60 + _selectedMinutes;
    return nextMin <= _totalOperatingMinutes;
  }

  void _decrementHours() {
    setState(() {
      if (_selectedHours == 1 && _selectedMinutes == 0) {
        _selectedHours = 0;
        _selectedMinutes = 30;
      } else if (_selectedHours > 0) {
        _selectedHours -= 1;
      }
      _updateAvailableTimeSlots();
    });
  }

  void _incrementHours() {
    setState(() {
      if (_selectedHours == 0 && _selectedMinutes == 30) {
        _selectedHours = 1;
        _selectedMinutes = 0;
      } else {
        final nextMin = (_selectedHours + 1) * 60 + _selectedMinutes;
        if (nextMin <= _totalOperatingMinutes) {
          _selectedHours += 1;
        }
      }
      _updateAvailableTimeSlots();
    });
  }

  void _setMinutes(int mins) {
    setState(() {
      if (mins == 0 && _selectedHours == 0) {
        _selectedHours = 1;
        _selectedMinutes = 0;
      } else {
        final nextMin = _selectedHours * 60 + mins;
        if (nextMin <= _totalOperatingMinutes) {
          _selectedMinutes = mins;
        }
      }
      _updateAvailableTimeSlots();
    });
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _confirmBooking() {
    if (_selectedGame == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a game')),
      );
      return;
    }

    if (_selectedCourt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a court to continue.')),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select booking date')),
      );
      return;
    }

    if (!_isFullDay && _selectedStartTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an available start time')),
      );
      return;
    }

    final startTime = _isFullDay ? _venueOpenTimeFormatted : _selectedStartTime!;
    final endTime = _isFullDay
        ? _venueCloseTimeFormatted
        : _calculateEndTime(_selectedStartTime!, _selectedDurationMinutes);
    final durationStr = _isFullDay
        ? 'Full Day'
        : _formatDuration(_selectedHours, _selectedMinutes);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookingDetailsScreen(
          bookingData: {
            'venue': widget.venue,
            'game': _selectedGame,
            'court': _selectedCourt,
            'date': DateFormat('dd MMMM yyyy').format(_selectedDate!),
            'startTime': startTime,
            'endTime': endTime,
            'duration': durationStr,
            'amount': _payableAmount,
            'credits': _payableCredits,
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Slot'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Venue Header Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: AppSurfaces.card(),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.venue['image'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 60,
                        color: AppColors.fieldBorder,
                        child: const AppIcon(
                          HugeIcons.strokeRoundedImageNotFound01,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.venue['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.venue['location'],
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Game Selection
            const Text(
              'Selected Game',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ((widget.venue['games'] as List?) ?? const []).map((game) {
                final gameName = game.toString();
                final isSelected = _selectedGame == gameName;
                return ChoiceChip(
                  label: Text(gameName),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      _selectedGame = gameName;
                      if (_selectedCourt != null &&
                          !_availableCourts.contains(_selectedCourt)) {
                        _selectedCourt = null;
                      }
                    });
                  },
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.navy,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Available Courts Selection
            const Text(
              'Available Courts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableCourts.map((court) {
                final isSelected = _selectedCourt == court;
                return ChoiceChip(
                  avatar: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                  label: Text(court),
                  selected: isSelected,
                  onSelected: (val) =>
                      setState(() => _selectedCourt = val ? court : null),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.navy,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Date Selection
            const Text(
              'Select Date',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(16),
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
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _selectedDate == null
                          ? 'Select Booking Date'
                          : DateFormat('dd MMMM yyyy').format(_selectedDate!),
                      style: TextStyle(
                        fontSize: 15,
                        color: _selectedDate == null
                            ? AppColors.textSecondary
                            : AppColors.navy,
                        fontWeight: _selectedDate == null
                            ? FontWeight.normal
                            : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Duration Section
            const Text(
              'Duration',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 12),

            // Mode Selector: Custom Duration vs Full Day
            Row(
              children: [
                Expanded(
                  child: _DurationModeChip(
                    title: 'Custom Duration',
                    icon: HugeIcons.strokeRoundedClock01,
                    isSelected: !_isFullDay,
                    onTap: () {
                      setState(() {
                        _isFullDay = false;
                        _updateAvailableTimeSlots();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DurationModeChip(
                    title: 'Full Day',
                    icon: HugeIcons.strokeRoundedSun01,
                    isSelected: _isFullDay,
                    onTap: () {
                      setState(() {
                        _isFullDay = true;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Custom Duration Controls OR Full Day Card
            if (!_isFullDay) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppSurfaces.card(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Adjust Hours & Minutes',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _formatDuration(_selectedHours, _selectedMinutes),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        // Hours Stepper
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hours',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.navy,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundBottom,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.fieldBorder,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _StepperButton(
                                      icon: Icons.remove_rounded,
                                      enabled: _canDecrementHours,
                                      onTap: _decrementHours,
                                    ),
                                    Text(
                                      '$_selectedHours',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.navy,
                                      ),
                                    ),
                                    _StepperButton(
                                      icon: Icons.add_rounded,
                                      enabled: _canIncrementHours,
                                      onTap: _incrementHours,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Minutes Selector
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Minutes',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.navy,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                height: 48,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundBottom,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.fieldBorder,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: _selectedMinutes,
                                    isExpanded: true,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: AppColors.navy,
                                      size: 20,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.navy,
                                    ),
                                    dropdownColor: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    items: const [
                                      DropdownMenuItem<int>(
                                        value: 0,
                                        child: Text('00'),
                                      ),
                                      DropdownMenuItem<int>(
                                        value: 30,
                                        child: Text('30'),
                                      ),
                                    ],
                                    onChanged: (val) {
                                      if (val != null) {
                                        _setMinutes(val);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Full Day Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppSurfaces.card(),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const AppIcon(
                        HugeIcons.strokeRoundedSun01,
                        color: AppColors.primaryDark,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Full Day Booking',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$_venueOpenTimeFormatted → $_venueCloseTimeFormatted',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Entire venue operating hours',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Dynamic Time Selection (Horizontally Scrollable)
            if (!_isFullDay) ...[
              const Text(
                'Available Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 12),
              if (_availableTimeSlots.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppSurfaces.card(),
                  child: const Center(
                    child: Text(
                      'No available start times for this duration.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _availableTimeSlots.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final time = _availableTimeSlots[index];
                      final isSelected = _selectedStartTime == time;
                      return InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => setState(() => _selectedStartTime = time),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.fieldBorder,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Text(
                            time,
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected ? Colors.white : AppColors.navy,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 24),
            ],

            // Selected Slot Summary Box
            if (_isFullDay || _selectedStartTime != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppSurfaces.card(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected Slot',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              DateFormat('dd MMMM yyyy').format(
                                _selectedDate ?? DateTime.now(),
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Duration',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _isFullDay
                                  ? 'Full Day'
                                  : _formatDuration(
                                      _selectedHours,
                                      _selectedMinutes,
                                    ),
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
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Time',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _isFullDay
                                  ? '$_venueOpenTimeFormatted - $_venueCloseTimeFormatted'
                                  : '$_selectedStartTime - ${_calculateEndTime(_selectedStartTime!, _selectedDurationMinutes)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Price & Credits',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '₹$_payableAmount / $_payableCredits Credits',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ],
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
                onPressed: _confirmBooking,
                child: const Text('CONFIRM BOOKING'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DurationModeChip extends StatelessWidget {
  const _DurationModeChip({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final List<List<dynamic>> icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.fieldBorder,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.navy,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.navy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? Colors.white : AppColors.backgroundBottom,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: enabled ? onTap : null,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: enabled ? AppColors.fieldBorder : Colors.transparent,
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: enabled ? AppColors.navy : AppColors.textSecondary.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
