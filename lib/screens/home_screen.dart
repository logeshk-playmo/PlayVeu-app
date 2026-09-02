import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';
import 'credits_screen.dart';
import 'equipment_screen.dart';
import 'leaderboard_screen.dart';
import 'login_screen.dart';
import 'play_screen.dart';
import 'profile_screen.dart';
import 'venue_details_screen.dart';
import 'venues_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _tabIndex = 0;

  int _credits = 20;
  static const _titles = ['Home', 'Equipment', 'Venue', 'Play', 'Leaderboard'];

  void _selectTab(int index) {
    setState(() => _tabIndex = index);
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _openCredits() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CreditsScreen(
          credits: _credits,
          onBalanceChanged: (total) => setState(() => _credits = total),
        ),
      ),
    );
  }

  void _openProfile() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProfileScreen(
          credits: _credits,
          onCreditsChanged: (total) => setState(() => _credits = total),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundBottom,
      appBar: AppBar(
        leadingWidth: 48,
        titleSpacing: 0,
        leading: IconButton(
          tooltip: 'Menu',
          icon: const AppIcon(HugeIcons.strokeRoundedMenu01, size: 22),
          onPressed: _openDrawer,
        ),
        title: Text(_titles[_tabIndex]),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
            icon: const AppIcon(
              HugeIcons.strokeRoundedNotification01,
              size: 22,
            ),
          ),
        ],
      ),
      drawer: _HomeDrawer(
        selectedTab: _tabIndex,
        onSelectTab: (index) {
          Navigator.of(context).pop();
          _selectTab(index);
        },
        onOpenCredits: () {
          Navigator.of(context).pop();
          _openCredits();
        },
        onOpenProfile: () {
          Navigator.of(context).pop();
          _openProfile();
        },
        onPlaceholder: (label) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$label is coming soon')));
        },
        onLogout: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        },
      ),
      body: IndexedStack(
        index: _tabIndex,
        children: [
          _HomeDashboard(
            credits: _credits,
            onOpenCredits: _openCredits,
            onOpenProfile: _openProfile,
            onSeeAllVenues: () => _selectTab(2),
          ),
          const EquipmentScreen(),
          const VenuesScreen(),
          const PlayScreen(),
          const LeaderboardScreen(),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: AppSurfaces.bar,
        child: NavigationBar(
          selectedIndex: _tabIndex,
          onDestinationSelected: _selectTab,
          destinations: const [
            NavigationDestination(
              icon: AppIcon(HugeIcons.strokeRoundedHome01),
              selectedIcon: AppIcon(
                HugeIcons.strokeRoundedHome01,
                strokeWidth: 2.4,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: AppIcon(HugeIcons.strokeRoundedDumbbell02),
              selectedIcon: AppIcon(
                HugeIcons.strokeRoundedDumbbell02,
                strokeWidth: 2.4,
              ),
              label: 'Equipment',
            ),
            NavigationDestination(
              icon: AppIcon(HugeIcons.strokeRoundedFootballPitch),
              selectedIcon: AppIcon(
                HugeIcons.strokeRoundedFootballPitch,
                strokeWidth: 2.4,
              ),
              label: 'Venue',
            ),
            NavigationDestination(
              icon: AppIcon(HugeIcons.strokeRoundedWorkoutRun),
              selectedIcon: AppIcon(
                HugeIcons.strokeRoundedWorkoutRun,
                strokeWidth: 2.4,
              ),
              label: 'Play',
            ),
            NavigationDestination(
              icon: AppIcon(HugeIcons.strokeRoundedChampion),
              selectedIcon: AppIcon(
                HugeIcons.strokeRoundedChampion,
                strokeWidth: 2.4,
              ),
              label: 'Leaderboard',
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer({
    required this.selectedTab,
    required this.onSelectTab,
    required this.onOpenCredits,
    required this.onOpenProfile,
    required this.onPlaceholder,
    required this.onLogout,
  });

  final int selectedTab;
  final ValueChanged<int> onSelectTab;
  final VoidCallback onOpenCredits;
  final VoidCallback onOpenProfile;
  final ValueChanged<String> onPlaceholder;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/app_icon.png',
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PlayVue',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        Text(
                          'Elevate your game',
                          style: TextStyle(
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
            const Divider(height: 1, color: AppColors.fieldBorder),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _DrawerTile(
                    icon: HugeIcons.strokeRoundedUser,
                    label: 'Profile',
                    onTap: onOpenProfile,
                  ),
                  _DrawerTile(
                    icon: HugeIcons.strokeRoundedHome01,
                    label: 'Home',
                    selected: selectedTab == 0,
                    onTap: () => onSelectTab(0),
                  ),
                  _DrawerTile(
                    icon: HugeIcons.strokeRoundedDumbbell02,
                    label: 'Equipment',
                    selected: selectedTab == 1,
                    onTap: () => onSelectTab(1),
                  ),
                  _DrawerTile(
                    icon: HugeIcons.strokeRoundedFootballPitch,
                    label: 'Venue',
                    selected: selectedTab == 2,
                    onTap: () => onSelectTab(2),
                  ),
                  _DrawerTile(
                    icon: HugeIcons.strokeRoundedWorkoutRun,
                    label: 'Play',
                    selected: selectedTab == 3,
                    onTap: () => onSelectTab(3),
                  ),
                  _DrawerTile(
                    icon: HugeIcons.strokeRoundedChampion,
                    label: 'Leaderboard',
                    selected: selectedTab == 4,
                    onTap: () => onSelectTab(4),
                  ),
                  _DrawerTile(
                    icon: HugeIcons.strokeRoundedWallet01,
                    label: 'Credits',
                    onTap: onOpenCredits,
                  ),
                  _DrawerTile(
                    icon: HugeIcons.strokeRoundedCalendar03,
                    label: 'Bookings',
                    onTap: () => onPlaceholder('Bookings'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.fieldBorder),
            _DrawerTile(
              icon: HugeIcons.strokeRoundedSettings01,
              label: 'Settings',
              onTap: () => onPlaceholder('Settings'),
            ),
            _DrawerTile(
              icon: HugeIcons.strokeRoundedLogout01,
              label: 'Logout',
              onTap: onLogout,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final List<List<dynamic>> icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AppIcon(
        icon,
        size: 22,
        color: selected ? AppColors.primary : AppColors.navy,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? AppColors.primary : AppColors.navy,
        ),
      ),
      selected: selected,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard({
    required this.credits,
    required this.onOpenCredits,
    required this.onOpenProfile,
    required this.onSeeAllVenues,
  });

  final int credits;
  final VoidCallback onOpenCredits;
  final VoidCallback onOpenProfile;
  final VoidCallback onSeeAllVenues;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        _ProfileCard(
          credits: credits,
          onOpenCredits: onOpenCredits,
          onOpenProfile: onOpenProfile,
        ),
        const SizedBox(height: 32),
        const _GamesBySportsCard(),
        const SizedBox(height: 32),
        _HomeVenuesSection(onSeeAll: onSeeAllVenues),
      ],
    );
  }
}

class _GamesBySportsCard extends StatelessWidget {
  const _GamesBySportsCard();

  static const _games = <(String, String)>[
    ('Box Cricket', 'assets/sports/sport_box_cricket.png'),
    ('Pickleball', 'assets/sports/sport_pickleball.png'),
    ('Swimming', 'assets/sports/sport_swimming.png'),
    ('Table Tennis', 'assets/sports/sport_table_tennis.png'),
    ('Badminton', 'assets/sports/sport_badminton.png'),
    ('Football', 'assets/sports/sport_football.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFEAF8EE)],
          stops: [0.55, 1],
        ),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GAMES BY SPORTS',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _games.length,
              separatorBuilder: (context, index) => const SizedBox(width: 18),
              itemBuilder: (context, index) {
                final game = _games[index];
                return _SportItem(name: game.$1, image: game.$2);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.credits,
    required this.onOpenCredits,
    required this.onOpenProfile,
  });

  final int credits;
  final VoidCallback onOpenCredits;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppSurfaces.card(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: onOpenProfile,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(14, 14, 10, 14),
              child: Row(
                children: [
                  _HomeAvatar(),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Logesh',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Player  ·  Bengaluru',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '+91 9999999999',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppIcon(
                    HugeIcons.strokeRoundedArrowRight01,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.fieldBorder),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                _HomeStat(
                  value: '$credits Credits',
                  label: 'Balance',
                  onTap: onOpenCredits,
                ),
                Container(width: 1, height: 32, color: AppColors.fieldBorder),
                const _HomeStat(value: '12', label: 'Matches'),
                Container(width: 1, height: 32, color: AppColors.fieldBorder),
                const _HomeStat(value: '#3', label: 'Rank'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeAvatar extends StatelessWidget {
  const _HomeAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: const CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.primary,
        child: Text(
          'L',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _HomeStat extends StatelessWidget {
  const _HomeStat({required this.value, required this.label, this.onTap});

  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );

    return Expanded(
      child: onTap == null ? child : InkWell(onTap: onTap, child: child),
    );
  }
}

class _SportItem extends StatelessWidget {
  const _SportItem({required this.name, required this.image});

  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 78,
      child: Column(
        children: [
          Image.asset(image, width: 56, height: 56, fit: BoxFit.contain),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeVenuesSection extends StatelessWidget {
  const _HomeVenuesSection({required this.onSeeAll});

  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final venues = VenuesScreen.venues;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'VENUES NEAR YOU',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: Colors.black,
                ),
              ),
            ),
            InkWell(
              onTap: onSeeAll,
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    SizedBox(width: 2),
                    AppIcon(
                      HugeIcons.strokeRoundedArrowRight01,
                      size: 14,
                      color: AppColors.primaryDark,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: venues.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 208,
          ),
          itemBuilder: (context, index) {
            final venue = venues[index];
            return _HomeVenueCard(
              venue: venue,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => VenueDetailsScreen(venue: venue),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _HomeVenueCard extends StatelessWidget {
  const _HomeVenueCard({required this.venue, required this.onTap});

  final Map<String, dynamic> venue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final games = (venue['games'] as List<dynamic>).cast<String>();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSurfaces.radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: AppSurfaces.card(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Image.network(
                    venue['image'] as String,
                    height: 108,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 108,
                      color: AppColors.fieldBorder,
                      alignment: Alignment.center,
                      child: const AppIcon(
                        HugeIcons.strokeRoundedImageNotFound01,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.58),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AppIcon(
                            HugeIcons.strokeRoundedStar,
                            size: 11,
                            color: Color(0xFFFFC107),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${venue['rating']}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        venue['name'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const AppIcon(
                            HugeIcons.strokeRoundedLocation01,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              venue['location'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        games.take(2).join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
