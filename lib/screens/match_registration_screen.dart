import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';

class MatchRegistrationScreen extends StatefulWidget {
  const MatchRegistrationScreen({
    super.key,
    required this.match,
    this.onJoined,
  });

  final Map<String, dynamic> match;
  final VoidCallback? onJoined;

  @override
  State<MatchRegistrationScreen> createState() => _MatchRegistrationScreenState();
}

class _MatchRegistrationScreenState extends State<MatchRegistrationScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  String _selectedSkillLevel = 'Intermediate';
  static const _skillLevels = ['Beginner', 'Intermediate', 'Advanced'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Logesh K');
    _phoneController = TextEditingController(text: '+91 9999999999');
    _emailController = TextEditingController(text: 'logesh@playveuw.com');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool get _isMatchFull {
    final spotsStr = widget.match['spots']?.toString().toLowerCase() ?? '';
    if (spotsStr.contains('0 spot') || spotsStr.contains('full')) return true;
    final players = widget.match['players'];
    final totalPlayers = widget.match['totalPlayers'];
    if (players != null && totalPlayers != null && players is num && totalPlayers is num) {
      return players >= totalPlayers;
    }
    return widget.match['isFull'] == true;
  }

  void _handleJoin() {
    if (_isMatchFull) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 8),
              Text(
                'Match Full',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
          content: const Text(
            'This match has reached the maximum number of players.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    final gameName = widget.match['game'] ?? widget.match['sport'] ?? 'Match';
    final venueName = widget.match['venue'] ?? '';
    final timeStr = widget.match['time'] ?? '';
    final dateStr = widget.match['date'] ?? 'Upcoming Date';

    final matchId = widget.match['id']?.toString() ?? '';
    if (matchId.isNotEmpty) {
      AppPlayState.requestJoinMatch(matchId);
    }

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
                  color: Color(0xFFE6F9EE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF2ECC71),
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Request Sent ✓',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your request to join this match\nhas been sent to the match organizer.\n\nYou will be able to join once\nthe organizer accepts your request.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundBottom,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.fieldBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gameName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$venueName · $dateStr, $timeStr',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    widget.onJoined?.call();
                    Navigator.pop(dialogCtx);
                    Navigator.pop(context);
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
    final game = widget.match['game'] ?? 'Match';
    final venue = widget.match['venue'] ?? 'Venue';
    final time = widget.match['time'] ?? 'Time';
    final spots = widget.match['spots'] ?? 'Open';
    final date = widget.match['date'] ?? 'Upcoming Date';
    final playersDisplay = widget.match['playersCount'] ?? spots;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Match'),
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
            // Match Details Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppSurfaces.card(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const AppIcon(
                          HugeIcons.strokeRoundedWorkoutRun,
                          color: AppColors.primaryDark,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                            Text(
                              venue,
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: AppColors.fieldBorder),
                  ),
                  _DetailRow(
                    icon: HugeIcons.strokeRoundedCalendar03,
                    label: 'Date',
                    value: date,
                  ),
                  const SizedBox(height: 8),
                  _DetailRow(
                    icon: HugeIcons.strokeRoundedClock01,
                    label: 'Time',
                    value: time,
                  ),
                  const SizedBox(height: 8),
                  _DetailRow(
                    icon: HugeIcons.strokeRoundedUserGroup,
                    label: 'Players',
                    value: playersDisplay,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Your Details Section
            const Text(
              'Your Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppSurfaces.card(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _InputLabel('Full Name'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration('Enter your name'),
                  ),
                  const SizedBox(height: 14),
                  const _InputLabel('Phone Number'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration('Enter phone number'),
                  ),
                  const SizedBox(height: 14),
                  const _InputLabel('Email Address'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration('Enter email address'),
                  ),
                  const SizedBox(height: 14),
                  const _InputLabel('Your Skill Level'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _skillLevels.map((lvl) {
                      final isSelected = _selectedSkillLevel == lvl;
                      return ChoiceChip(
                        label: Text(lvl),
                        selected: isSelected,
                        onSelected: (val) =>
                            setState(() => _selectedSkillLevel = lvl),
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.navy,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
                onPressed: _handleJoin,
                child: const Text('SUBMIT REQUEST'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.backgroundBottom,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.fieldBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.fieldBorder),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final List<List<dynamic>> icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppIcon(icon, color: AppColors.primary, size: 16),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}

class _InputLabel extends StatelessWidget {
  const _InputLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.navy,
      ),
    );
  }
}
