import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_icon.dart';
import 'create_match_screen.dart';
import 'create_tournament_screen.dart';

class SelectSportScreen extends StatelessWidget {
  const SelectSportScreen({super.key});

  static const _sports = <_SportOption>[
    _SportOption(
      name: 'Badminton',
      image: 'assets/sports/sport_badminton.png',
      fallbackIcon: HugeIcons.strokeRoundedBadminton,
    ),
    _SportOption(
      name: 'Cricket',
      image: 'assets/sports/sport_box_cricket.png',
      fallbackIcon: HugeIcons.strokeRoundedCricketBat,
    ),
    _SportOption(
      name: 'Pickleball',
      image: 'assets/sports/sport_pickleball.png',
      fallbackIcon: HugeIcons.strokeRoundedTableTennisBat,
    ),
    _SportOption(
      name: 'Carrom',
      fallbackIcon: HugeIcons.strokeRoundedTarget01,
    ),
    _SportOption(
      name: 'Chess',
      fallbackIcon: HugeIcons.strokeRoundedCrown,
    ),
    _SportOption(
      name: 'Football',
      image: 'assets/sports/sport_football.png',
      fallbackIcon: HugeIcons.strokeRoundedFootball,
    ),
    _SportOption(
      name: 'Tennis',
      fallbackIcon: HugeIcons.strokeRoundedTennisBall,
    ),
    _SportOption(
      name: 'Table Tennis',
      image: 'assets/sports/sport_table_tennis.png',
      fallbackIcon: HugeIcons.strokeRoundedTableTennisBat,
    ),
    _SportOption(
      name: 'Swimming',
      image: 'assets/sports/sport_swimming.png',
      fallbackIcon: HugeIcons.strokeRoundedSwimming,
    ),
  ];

  void _onSportSelected(BuildContext context, _SportOption sport) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetCtx) => _CreationChoiceSheet(
        sport: sport,
        onCreateMatch: () {
          Navigator.pop(bottomSheetCtx);
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => CreateMatchScreen(sport: sport.name),
            ),
          );
        },
        onCreateTournament: () {
          Navigator.pop(bottomSheetCtx);
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => CreateTournamentScreen(sport: sport.name),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Sport'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'Choose a sport to host a match or tournament',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.15,
                ),
                itemCount: _sports.length,
                itemBuilder: (context, index) {
                  final sport = _sports[index];
                  return _SportGridCard(
                    sport: sport,
                    onTap: () => _onSportSelected(context, sport),
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

class _SportOption {
  const _SportOption({
    required this.name,
    this.image,
    required this.fallbackIcon,
  });

  final String name;
  final String? image;
  final List<List<dynamic>> fallbackIcon;
}

class _SportGridCard extends StatelessWidget {
  const _SportGridCard({
    required this.sport,
    required this.onTap,
  });

  final _SportOption sport;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: AppSurfaces.card(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (sport.image != null)
                Image.asset(
                  sport.image!,
                  width: 52,
                  height: 52,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => AppIcon(
                    sport.fallbackIcon,
                    color: AppColors.primary,
                    size: 40,
                  ),
                )
              else
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: AppIcon(
                      sport.fallbackIcon,
                      color: AppColors.primaryDark,
                      size: 28,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                sport.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreationChoiceSheet extends StatelessWidget {
  const _CreationChoiceSheet({
    required this.sport,
    required this.onCreateMatch,
    required this.onCreateTournament,
  });

  final _SportOption sport;
  final VoidCallback onCreateMatch;
  final VoidCallback onCreateTournament;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.fieldBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                if (sport.image != null)
                  Image.asset(
                    sport.image!,
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                  )
                else
                  AppIcon(
                    sport.fallbackIcon,
                    color: AppColors.primary,
                    size: 28,
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected Sport',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        sport.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.textSecondary,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'What would you like to create?',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 16),
            _ChoiceCard(
              title: 'Create Match',
              description: 'Host a casual or competitive match with players',
              icon: HugeIcons.strokeRoundedWorkoutRun,
              badgeColor: AppColors.primarySoft.withValues(alpha: 0.35),
              iconColor: AppColors.primaryDark,
              onTap: onCreateMatch,
            ),
            const SizedBox(height: 12),
            _ChoiceCard(
              title: 'Create Tournament',
              description: 'Organize a multi-team tournament or league',
              icon: HugeIcons.strokeRoundedChampion,
              badgeColor: const Color(0xFFFFECC8),
              iconColor: const Color(0xFFC77700),
              onTap: onCreateTournament,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.badgeColor,
    required this.iconColor,
    required this.onTap,
  });

  final String title;
  final String description;
  final List<List<dynamic>> icon;
  final Color badgeColor;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: AppSurfaces.card(),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: AppIcon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
