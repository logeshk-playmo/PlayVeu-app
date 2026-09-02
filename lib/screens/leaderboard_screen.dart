import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';

final _pointsFormat = NumberFormat('#,###');

String _formatPoints(int points) => _pointsFormat.format(points);

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  static const _sports = <String>[
    'Box Cricket',
    'Pickleball',
    'Swimming',
    'Table Tennis',
    'Badminton',
    'Football',
  ];

  static const _boards = <String, List<_RankedPlayer>>{
    'Box Cricket': [
      _RankedPlayer(rank: 1, name: 'Arjun Rao', points: 1840),
      _RankedPlayer(rank: 2, name: 'Meera Shah', points: 1720),
      _RankedPlayer(rank: 3, name: 'Logesh', points: 1650, isYou: true),
      _RankedPlayer(rank: 4, name: 'Kabir Singh', points: 1490),
      _RankedPlayer(rank: 5, name: 'Ananya Iyer', points: 1380),
      _RankedPlayer(rank: 6, name: 'Rahul Nair', points: 1210),
      _RankedPlayer(rank: 7, name: 'Sneha Patel', points: 1140),
    ],
    'Pickleball': [
      _RankedPlayer(rank: 1, name: 'Sneha Patel', points: 1910),
      _RankedPlayer(rank: 2, name: 'Diya Menon', points: 1760),
      _RankedPlayer(rank: 3, name: 'Arjun Rao', points: 1680),
      _RankedPlayer(rank: 4, name: 'Logesh', points: 1520, isYou: true),
      _RankedPlayer(rank: 5, name: 'Vikram Joshi', points: 1390),
      _RankedPlayer(rank: 6, name: 'Meera Shah', points: 1240),
      _RankedPlayer(rank: 7, name: 'Kabir Singh', points: 1110),
    ],
    'Swimming': [
      _RankedPlayer(rank: 1, name: 'Ananya Iyer', points: 2100),
      _RankedPlayer(rank: 2, name: 'Rahul Nair', points: 1980),
      _RankedPlayer(rank: 3, name: 'Priya Das', points: 1810),
      _RankedPlayer(rank: 4, name: 'Meera Shah', points: 1640),
      _RankedPlayer(rank: 5, name: 'Sneha Patel', points: 1470),
      _RankedPlayer(rank: 6, name: 'Logesh', points: 1320, isYou: true),
      _RankedPlayer(rank: 7, name: 'Arjun Rao', points: 1180),
    ],
    'Table Tennis': [
      _RankedPlayer(rank: 1, name: 'Kabir Singh', points: 2050),
      _RankedPlayer(rank: 2, name: 'Logesh', points: 1890, isYou: true),
      _RankedPlayer(rank: 3, name: 'Vikram Joshi', points: 1740),
      _RankedPlayer(rank: 4, name: 'Diya Menon', points: 1590),
      _RankedPlayer(rank: 5, name: 'Arjun Rao', points: 1410),
      _RankedPlayer(rank: 6, name: 'Ananya Iyer', points: 1260),
      _RankedPlayer(rank: 7, name: 'Rahul Nair', points: 1090),
    ],
    'Badminton': [
      _RankedPlayer(rank: 1, name: 'Logesh', points: 2240, isYou: true),
      _RankedPlayer(rank: 2, name: 'Priya Das', points: 2110),
      _RankedPlayer(rank: 3, name: 'Meera Shah', points: 1960),
      _RankedPlayer(rank: 4, name: 'Sneha Patel', points: 1780),
      _RankedPlayer(rank: 5, name: 'Kabir Singh', points: 1610),
      _RankedPlayer(rank: 6, name: 'Diya Menon', points: 1450),
      _RankedPlayer(rank: 7, name: 'Vikram Joshi', points: 1290),
    ],
    'Football': [
      _RankedPlayer(rank: 1, name: 'Rahul Nair', points: 2380),
      _RankedPlayer(rank: 2, name: 'Arjun Rao', points: 2210),
      _RankedPlayer(rank: 3, name: 'Kabir Singh', points: 2030),
      _RankedPlayer(rank: 4, name: 'Vikram Joshi', points: 1870),
      _RankedPlayer(rank: 5, name: 'Logesh', points: 1700, isYou: true),
      _RankedPlayer(rank: 6, name: 'Ananya Iyer', points: 1540),
      _RankedPlayer(rank: 7, name: 'Priya Das', points: 1360),
    ],
  };

  String _selectedSport = _sports.first;

  @override
  Widget build(BuildContext context) {
    final players = _boards[_selectedSport] ?? const <_RankedPlayer>[];
    final podium = players.take(3).toList();
    final rest = players.skip(3).toList();

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      itemCount: rest.length + 2,
      separatorBuilder: (context, index) =>
          SizedBox(height: index == 0 ? 16 : 10),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Row(
            children: [
              const Expanded(
                child: Text(
                  'This week',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              _SportFilter(
                sports: _sports,
                selected: _selectedSport,
                onSelected: (sport) => setState(() => _selectedSport = sport),
              ),
            ],
          );
        }

        if (index == 1) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            child: SizedBox(
              width: double.infinity,
              child: _Podium(key: ValueKey(_selectedSport), players: podium),
            ),
          );
        }

        return _RankTile(player: rest[index - 2]);
      },
    );
  }
}

class _Podium extends StatelessWidget {
  const _Podium({super.key, required this.players});

  final List<_RankedPlayer> players;

  static const _gold = Color(0xFFE6B422);
  static const _silver = Color(0xFF8EA3B0);
  static const _bronze = Color(0xFFC67B3E);

  @override
  Widget build(BuildContext context) {
    final first = players.elementAtOrNull(0);
    final second = players.elementAtOrNull(1);
    final third = players.elementAtOrNull(2);

    return Container(
      width: double.infinity,
      decoration: AppSurfaces.card(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: second == null
                      ? const SizedBox.shrink()
                      : _PodiumPlayer(player: second, medal: _silver),
                ),
                Expanded(
                  child: first == null
                      ? const SizedBox.shrink()
                      : _PodiumPlayer(
                          player: first,
                          medal: _gold,
                          featured: true,
                        ),
                ),
                Expanded(
                  child: third == null
                      ? const SizedBox.shrink()
                      : _PodiumPlayer(player: third, medal: _bronze),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 68,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _PodiumStand(rank: 2, color: _silver, height: 50),
                ),
                Expanded(
                  child: _PodiumStand(rank: 1, color: _gold, height: 68),
                ),
                Expanded(
                  child: _PodiumStand(rank: 3, color: _bronze, height: 38),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumPlayer extends StatelessWidget {
  const _PodiumPlayer({
    required this.player,
    required this.medal,
    this.featured = false,
  });

  final _RankedPlayer player;
  final Color medal;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final avatarSize = featured ? 64.0 : 48.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (featured)
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: AppIcon(
                HugeIcons.strokeRoundedChampion,
                size: 18,
                color: _Podium._gold,
              ),
            ),
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: medal.withValues(alpha: 0.16),
              border: Border.all(color: medal, width: featured ? 2.4 : 1.8),
            ),
            alignment: Alignment.center,
            child: Text(
              player.initials,
              style: TextStyle(
                fontSize: featured ? 20 : 15,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Text(
              player.shortName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: featured ? 13 : 12,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ),
          if (player.isYou) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'You',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ],
          const SizedBox(height: 2),
          SizedBox(
            width: double.infinity,
            child: Text(
              '${_formatPoints(player.points)} pts',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: featured ? 12 : 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumStand extends StatelessWidget {
  const _PodiumStand({
    required this.rank,
    required this.color,
    required this.height,
  });

  final int rank;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withValues(alpha: rank == 1 ? 0.36 : 0.22),
              color.withValues(alpha: 0.08),
            ],
          ),
          border: Border(top: BorderSide(color: color.withValues(alpha: 0.55))),
        ),
        alignment: Alignment.center,
        child: Text(
          '$rank',
          style: TextStyle(
            fontSize: rank == 1 ? 22 : 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _SportFilter extends StatelessWidget {
  const _SportFilter({
    required this.sports,
    required this.selected,
    required this.onSelected,
  });

  final List<String> sports;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Filter by sport',
      initialValue: selected,
      offset: const Offset(0, 8),
      position: PopupMenuPosition.under,
      color: Colors.white,
      elevation: 4,
      shadowColor: AppColors.navy.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSurfaces.radius),
        side: const BorderSide(color: AppColors.fieldBorder),
      ),
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          for (final sport in sports)
            PopupMenuItem<String>(
              value: sport,
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      sport,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: sport == selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: sport == selected
                            ? AppColors.primaryDark
                            : AppColors.navy,
                      ),
                    ),
                  ),
                  if (sport == selected)
                    const AppIcon(
                      HugeIcons.strokeRoundedTick02,
                      size: 16,
                      color: AppColors.primary,
                    ),
                ],
              ),
            ),
        ];
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 6, 8, 6),
        decoration: AppSurfaces.card(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppIcon(
              HugeIcons.strokeRoundedFilter,
              size: 14,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              selected,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(width: 2),
            const AppIcon(
              HugeIcons.strokeRoundedArrowDown01,
              size: 14,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _RankedPlayer {
  const _RankedPlayer({
    required this.rank,
    required this.name,
    required this.points,
    this.isYou = false,
  });

  final int rank;
  final String name;
  final int points;
  final bool isYou;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.characters.first.toUpperCase();
    }
    return '${parts.first.characters.first}${parts[1].characters.first}'
        .toUpperCase();
  }

  String get shortName {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first;
    return '${parts.first} ${parts[1].characters.first}.';
  }
}

class _RankTile extends StatelessWidget {
  const _RankTile({required this.player});

  final _RankedPlayer player;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: AppSurfaces.card(
        color: player.isYou ? AppColors.primary.withValues(alpha: 0.06) : null,
        border: player.isYou ? AppColors.primary : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${player.rank}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              player.isYou ? '${player.name} (You)' : player.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ),
          Text(
            '${_formatPoints(player.points)} pts',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
