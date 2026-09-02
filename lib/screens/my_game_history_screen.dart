import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';

class MyGameHistoryScreen extends StatefulWidget {
  const MyGameHistoryScreen({
    super.key,
    this.initialGames,
    this.onExploreMatches,
  });

  final List<Map<String, dynamic>>? initialGames;
  final VoidCallback? onExploreMatches;

  static const defaultGames = <Map<String, dynamic>>[
    {
      'id': 'g1',
      'sport': 'Badminton',
      'name': 'Sunday Badminton Match',
      'type': 'Match',
      'venue': 'Smash Arena',
      'location': 'Indiranagar, Bangalore',
      'date': '06 Sep 2026',
      'startTime': '06:00 PM',
      'endTime': '08:00 PM',
      'duration': '2 Hours',
      'players': 8,
      'status': 'Completed',
      'icon': HugeIcons.strokeRoundedBadminton,
    },
    {
      'id': 'g2',
      'sport': 'Football',
      'name': 'Weekend Football 5v5',
      'type': 'Match',
      'venue': 'PlayVue Sports Academy',
      'location': 'Koramangala, Bangalore',
      'date': '07 Sep 2026',
      'startTime': '07:00 PM',
      'endTime': '09:00 PM',
      'duration': '2 Hours',
      'players': 10,
      'status': 'Upcoming',
      'icon': HugeIcons.strokeRoundedFootball,
    },
    {
      'id': 'g3',
      'sport': 'Cricket',
      'name': 'Box Cricket Premier',
      'type': 'Match',
      'venue': 'Champions Sports Club',
      'location': 'HSR Layout, Bangalore',
      'date': '08 Sep 2026',
      'startTime': '05:00 PM',
      'endTime': '08:00 PM',
      'duration': '3 Hours',
      'players': 12,
      'status': 'Ongoing',
      'icon': HugeIcons.strokeRoundedCricketBat,
    },
    {
      'id': 'g4',
      'sport': 'Pickleball',
      'name': 'Pickleball Doubles Night',
      'type': 'Match',
      'venue': 'Smash Arena',
      'location': 'Indiranagar, Bangalore',
      'date': '09 Sep 2026',
      'startTime': '07:00 PM',
      'endTime': '08:30 PM',
      'duration': '1.5 Hours',
      'players': 4,
      'status': 'Registered',
      'icon': HugeIcons.strokeRoundedTableTennisBat,
    },
    {
      'id': 'g5',
      'sport': 'Cricket',
      'name': 'Weekend Cricket Cup',
      'type': 'Tournament',
      'venue': 'Sports Arena',
      'location': 'Whitefield, Bangalore',
      'date': '10 Sep 2026',
      'startTime': '09:00 AM',
      'endTime': '06:00 PM',
      'duration': 'Full Day',
      'teams': 8,
      'status': 'Registered',
      'prize': 'Trophy & 500 Credits',
      'icon': HugeIcons.strokeRoundedChampion,
    },
  ];

  @override
  State<MyGameHistoryScreen> createState() => _MyGameHistoryScreenState();
}

class _MyGameHistoryScreenState extends State<MyGameHistoryScreen> {
  late List<Map<String, dynamic>> _games;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    if (widget.initialGames != null) {
      _games = List<Map<String, dynamic>>.from(widget.initialGames!);
    } else {
      _games = List<Map<String, dynamic>>.from(AppPlayState.myGames.value);
      AppPlayState.myGames.addListener(_onGlobalGamesChanged);
    }
  }

  @override
  void dispose() {
    if (widget.initialGames == null) {
      AppPlayState.myGames.removeListener(_onGlobalGamesChanged);
    }
    super.dispose();
  }

  void _onGlobalGamesChanged() {
    if (widget.initialGames == null && mounted) {
      setState(() {
        _games = List<Map<String, dynamic>>.from(AppPlayState.myGames.value);
      });
    }
  }

  @override
  void didUpdateWidget(covariant MyGameHistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialGames != null) {
      _games = List<Map<String, dynamic>>.from(widget.initialGames!);
    } else {
      _games = List<Map<String, dynamic>>.from(AppPlayState.myGames.value);
    }
  }

  void _handleStartGame(Map<String, dynamic> game) {
    final gameId = game['id'].toString();
    setState(() {
      final idx = _games.indexWhere((g) => g['id'].toString() == gameId);
      if (idx != -1) {
        _games[idx] = Map<String, dynamic>.from(_games[idx])..['status'] = 'Ongoing';
      }
    });

    if (widget.initialGames == null) {
      AppPlayState.startGame(gameId);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${game['name']} started! Status is now Ongoing.'),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredGames {
    if (_selectedFilter == 'All') return _games;
    if (_selectedFilter == 'Matches') {
      return _games.where((g) => g['type'] == 'Match').toList();
    }
    if (_selectedFilter == 'Tournaments') {
      return _games.where((g) => g['type'] == 'Tournament').toList();
    }
    return _games.where((g) => g['status'] == _selectedFilter).toList();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF2ECC71);
      case 'ongoing':
        return const Color(0xFFE67E22);
      case 'upcoming':
        return AppColors.primaryDark;
      case 'requested':
        return const Color(0xFFE67E22);
      case 'joined':
        return const Color(0xFF2ECC71);
      case 'registered':
        return AppColors.primary;
      case 'cancelled':
        return const Color(0xFFE74C3C);
      default:
        return AppColors.navy;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFFE6F9EE);
      case 'ongoing':
        return const Color(0xFFFFF4E8);
      case 'upcoming':
        return const Color(0xFFE8F6FF);
      case 'requested':
        return const Color(0xFFFFF4E8);
      case 'joined':
        return const Color(0xFFE6F9EE);
      case 'registered':
        return const Color(0xFFE6F4FF);
      case 'cancelled':
        return const Color(0xFFFFECEB);
      default:
        return AppColors.backgroundBottom;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Games'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: _games.isEmpty
            ? _EmptyGameState(onExploreMatches: () {
                if (widget.onExploreMatches != null) {
                  widget.onExploreMatches!();
                } else {
                  Navigator.pop(context);
                }
              })
            : Column(
                children: [
                  // Filter Chips
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    color: AppColors.backgroundBottom,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'All',
                            count: _games.length,
                            isSelected: _selectedFilter == 'All',
                            onTap: () => setState(() => _selectedFilter = 'All'),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Matches',
                            count: _games
                                .where((g) => g['type'] == 'Match')
                                .length,
                            isSelected: _selectedFilter == 'Matches',
                            onTap: () =>
                                setState(() => _selectedFilter = 'Matches'),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Tournaments',
                            count: _games
                                .where((g) => g['type'] == 'Tournament')
                                .length,
                            isSelected: _selectedFilter == 'Tournaments',
                            onTap: () =>
                                setState(() => _selectedFilter = 'Tournaments'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.fieldBorder),

                  // Games List
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                      itemCount: _filteredGames.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final game = _filteredGames[index];
                        return _GameHistoryCard(
                          game: game,
                          statusColor: _getStatusColor(game['status'] ?? ''),
                          statusBgColor:
                              _getStatusBgColor(game['status'] ?? ''),
                          onStartGame: () => _handleStartGame(game),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.fieldBorder,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.navy,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.25)
                    : AppColors.backgroundTop,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.primaryDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameHistoryCard extends StatelessWidget {
  const _GameHistoryCard({
    required this.game,
    required this.statusColor,
    required this.statusBgColor,
    required this.onStartGame,
  });

  final Map<String, dynamic> game;
  final Color statusColor;
  final Color statusBgColor;
  final VoidCallback onStartGame;

  void _confirmStartGame(BuildContext context, bool isTournament) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isTournament ? 'Start Tournament?' : 'Start Match?',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        content: Text(
          isTournament
              ? 'Are you sure you want to start this tournament?\n\nOnce started, the tournament status will change to Ongoing.'
              : 'Are you sure you want to start this match?\n\nOnce started, the match status will change to Ongoing.',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              onStartGame();
            },
            child: Text(isTournament ? 'Start Tournament' : 'Start Match'),
          ),
        ],
      ),
    );
  }

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
    final isTournament = game['type'] == 'Tournament';
    final sport = game['sport'] ?? 'Sport';
    final name = game['name'] ?? '';
    final venue = game['venue'] ?? '';
    final location = game['location'] ?? '';
    final date = game['date'] ?? '';
    final startTime = game['startTime'] ?? '';
    final endTime = game['endTime'] ?? '';
    final duration = game['duration'] ?? '';
    final status = game['status'] ?? 'Upcoming';
    final visibility = game['visibility'] ?? 'Public';
    final isHost = game['isHost'] == true;
    final players = game['players'];
    final teams = game['teams'];
    final prize = game['prize'];
    final icon = game['icon'] ?? (isTournament ? HugeIcons.strokeRoundedChampion : _getSportIcon(sport));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppSurfaces.card(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxItemWidth = constraints.maxWidth;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Sport / Badges / Name & Status / Host Menu
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isTournament
                          ? const Color(0xFFFFECC8)
                          : AppColors.primarySoft.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppIcon(
                      icon,
                      color: isTournament
                          ? const Color(0xFFC77700)
                          : AppColors.primaryDark,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              sport,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isTournament
                                    ? const Color(0xFFFFECC8)
                                    : const Color(0xFFE8F6FF),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isTournament ? 'Tournament' : 'Match',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: isTournament
                                      ? const Color(0xFFC77700)
                                      : AppColors.primaryDark,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: visibility == 'Private'
                                    ? const Color(0xFFF0F0F0)
                                    : const Color(0xFFE8F6FF),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    visibility == 'Private'
                                        ? Icons.lock_outline_rounded
                                        : Icons.public_rounded,
                                    size: 10,
                                    color: visibility == 'Private'
                                        ? AppColors.textSecondary
                                        : AppColors.primaryDark,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    visibility,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: visibility == 'Private'
                                          ? AppColors.textSecondary
                                          : AppColors.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isHost)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F8F0),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Host',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2ECC71),
                                  ),
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: statusBgColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isHost) ...[
                    const SizedBox(width: 4),
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onSelected: (val) {
                        if (val == 'start') {
                          _confirmStartGame(context, isTournament);
                        } else if (val == 'details') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Details for $name')),
                          );
                        }
                      },
                      itemBuilder: (ctx) => [
                        if (status == 'Upcoming')
                          PopupMenuItem(
                            value: 'start',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.play_arrow_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isTournament
                                      ? 'Start Tournament'
                                      : 'Start Match',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.navy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const PopupMenuItem(
                          value: 'details',
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: AppColors.textSecondary,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'View Details',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.navy,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.fieldBorder),
              const SizedBox(height: 12),

              // Venue & Location
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppIcon(
                    HugeIcons.strokeRoundedLocation01,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      location.isNotEmpty ? '$venue · $location' : venue,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Date & Time
              Wrap(
                spacing: 16,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxItemWidth),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppIcon(
                          HugeIcons.strokeRoundedCalendar03,
                          color: AppColors.textSecondary,
                          size: 15,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            date,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxItemWidth),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppIcon(
                          HugeIcons.strokeRoundedClock01,
                          color: AppColors.textSecondary,
                          size: 15,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            endTime.isNotEmpty ? '$startTime - $endTime' : startTime,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Duration & Players/Teams/Prize
              Wrap(
                spacing: 16,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxItemWidth),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppIcon(
                          HugeIcons.strokeRoundedHourglass,
                          color: AppColors.textSecondary,
                          size: 15,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            duration,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxItemWidth),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIcon(
                          isTournament
                              ? HugeIcons.strokeRoundedChampion
                              : HugeIcons.strokeRoundedUserGroup,
                          color: AppColors.textSecondary,
                          size: 15,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            isTournament
                                ? '$teams Teams'
                                : '$players Players',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (prize != null && prize.toString().isNotEmpty)
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxItemWidth),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AppIcon(
                            HugeIcons.strokeRoundedGift,
                            color: Color(0xFFE67E22),
                            size: 15,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '$prize',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFE67E22),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyGameState extends StatelessWidget {
  const _EmptyGameState({required this.onExploreMatches});

  final VoidCallback onExploreMatches;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primarySoft.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: AppIcon(
                  HugeIcons.strokeRoundedWorkoutRun,
                  color: AppColors.primary,
                  size: 44,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Games Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You haven\'t joined or played any\ngames yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onExploreMatches,
              icon: const Icon(Icons.explore_rounded, size: 18),
              label: const Text('Explore Open Matches'),
            ),
          ],
        ),
      ),
    );
  }
}
