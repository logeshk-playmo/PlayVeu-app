import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_icon.dart';
import 'match_registration_screen.dart';
import 'select_sport_screen.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  @override
  void initState() {
    super.initState();
    AppPlayState.openMatches.addListener(_onMatchesChanged);
  }

  @override
  void dispose() {
    AppPlayState.openMatches.removeListener(_onMatchesChanged);
    super.dispose();
  }

  void _onMatchesChanged() {
    if (mounted) setState(() {});
  }

  void _openHostGame() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SelectSportScreen(),
      ),
    );
  }

  void _openJoinMatch(Map<String, dynamic> match) {
    if (match['isFull'] == true) {
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

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MatchRegistrationScreen(
          match: match,
        ),
      ),
    );
  }

  void _showRequestPendingSheet(Map<String, dynamic> match) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF4E8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hourglass_top_rounded,
                color: Color(0xFFE67E22),
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Join Request Pending',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your request to join ${match['game'] ?? 'this match'} has been submitted and is awaiting approval from the organizer.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(sheetCtx);
                  AppPlayState.acceptJoinRequest(match['id'].toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Organizer accepted your request! You are now Joined.'),
                    ),
                  );
                },
                child: const Text('Simulate Organizer Acceptance (Demo)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Only public matches appear in Open Matches
    final matches = AppPlayState.openMatches.value
        .where((m) => m['visibility'] != 'Private')
        .toList();

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      itemCount: matches.length + 2,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == 0) {
          // Host a game Action Card
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: _openHostGame,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.28),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Host a Game +',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Create a new match or tournament',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white70,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (index == 1) {
          return const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 4),
            child: Text(
              'Open Matches',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
          );
        }

        final match = matches[index - 2];
        return _MatchCard(
          match: match,
          onJoin: () => _openJoinMatch(match),
          onRequestPending: () => _showRequestPendingSheet(match),
        );
      },
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({
    required this.match,
    required this.onJoin,
    required this.onRequestPending,
  });

  final Map<String, dynamic> match;
  final VoidCallback onJoin;
  final VoidCallback onRequestPending;

  dynamic _getSportIcon(String? sport) {
    switch (sport?.toLowerCase()) {
      case 'badminton':
        return HugeIcons.strokeRoundedBadminton;
      case 'football':
        return HugeIcons.strokeRoundedFootball;
      case 'cricket':
        return HugeIcons.strokeRoundedCricketBat;
      case 'table tennis':
      case 'pickleball':
        return HugeIcons.strokeRoundedTableTennisBat;
      case 'tennis':
        return HugeIcons.strokeRoundedTennisBall;
      default:
        return HugeIcons.strokeRoundedWorkoutRun;
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = match['game'] as String? ?? 'Match';
    final venue = match['venue'] as String? ?? '';
    final time = match['time'] as String? ?? '';
    final date = match['date'] as String? ?? '';
    final spots = match['spots'] as String? ?? '';
    final isFull = match['isFull'] == true;
    final userStatus = match['userStatus'] as String? ?? 'none';
    final isJoined = userStatus == 'Joined';
    final isRequested = userStatus == 'Requested';
    final icon = match['icon'] ?? _getSportIcon(match['sport'] as String?);

    return Container(
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
                  color: AppColors.primarySoft.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AppIcon(icon, color: AppColors.primaryDark, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
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
              if (isJoined)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F9EE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Joined',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2ECC71),
                    ),
                  ),
                )
              else if (isRequested)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4E8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Requested',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE67E22),
                    ),
                  ),
                )
              else if (isFull)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Full',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE74C3C),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.fieldBorder),
          const SizedBox(height: 10),
          Row(
            children: [
              const AppIcon(
                HugeIcons.strokeRoundedClock01,
                size: 15,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '$date · $time',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                spots,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isFull ? const Color(0xFFE74C3C) : AppColors.primaryDark,
                ),
              ),
              const SizedBox(width: 10),
              if (isJoined)
                FilledButton(
                  onPressed: null,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE6F9EE),
                    disabledBackgroundColor: const Color(0xFFE6F9EE),
                    disabledForegroundColor: const Color(0xFF2ECC71),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Joined',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2ECC71),
                    ),
                  ),
                )
              else if (isRequested)
                FilledButton(
                  onPressed: onRequestPending,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF4E8),
                    foregroundColor: const Color(0xFFE67E22),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Requested',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                FilledButton(
                  onPressed: onJoin,
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        isFull ? AppColors.fieldBorder : AppColors.primary,
                    foregroundColor: isFull ? AppColors.navy : Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    isFull ? 'Full' : 'Join',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
