import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'admin_ui.dart';

class RegisteredPlayer {
  const RegisteredPlayer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.sports,
    required this.plan,
    required this.credits,
    required this.status,
    required this.avatarInitial,
    required this.joinedDate,
  });

  final String id;
  final String name;
  final String phone;
  final String email;
  final List<String> sports;
  final String plan;
  final int credits;
  final String status;
  final String avatarInitial;
  final String joinedDate;
}

class AdminPlayerListScreen extends StatefulWidget {
  const AdminPlayerListScreen({super.key});

  @override
  State<AdminPlayerListScreen> createState() => _AdminPlayerListScreenState();
}

class _AdminPlayerListScreenState extends State<AdminPlayerListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<RegisteredPlayer> _players = [
    RegisteredPlayer(
      id: 'p1',
      name: 'Rahul Kumar',
      phone: '+91 98765 43210',
      email: 'rahul.kumar@example.com',
      sports: ['Badminton', 'Football'],
      plan: 'PlayVue Plus',
      credits: 120,
      status: 'Active',
      avatarInitial: 'R',
      joinedDate: '12 Jan 2026',
    ),
    RegisteredPlayer(
      id: 'p2',
      name: 'Arun Kumar',
      phone: '+91 98123 45678',
      email: 'arun.k@example.com',
      sports: ['Cricket', 'Badminton'],
      plan: 'Weekend Pass',
      credits: 85,
      status: 'Active',
      avatarInitial: 'A',
      joinedDate: '04 Feb 2026',
    ),
    RegisteredPlayer(
      id: 'p3',
      name: 'Vijay Kumar',
      phone: '+91 97234 56789',
      email: 'vijay.kumar@example.com',
      sports: ['Football', 'Table Tennis'],
      plan: 'PlayVue Plus',
      credits: 95,
      status: 'Active',
      avatarInitial: 'V',
      joinedDate: '18 Feb 2026',
    ),
    RegisteredPlayer(
      id: 'p4',
      name: 'Logesh K',
      phone: '+91 99887 76655',
      email: 'logesh@example.com',
      sports: ['Badminton', 'Cricket', 'Football'],
      plan: 'Annual Pro',
      credits: 240,
      status: 'Active',
      avatarInitial: 'L',
      joinedDate: '01 Jan 2026',
    ),
    RegisteredPlayer(
      id: 'p5',
      name: 'Priya Sharma',
      phone: '+91 98450 11223',
      email: 'priya.sharma@example.com',
      sports: ['Tennis', 'Badminton'],
      plan: 'PlayVue Plus',
      credits: 60,
      status: 'Active',
      avatarInitial: 'P',
      joinedDate: '22 Mar 2026',
    ),
    RegisteredPlayer(
      id: 'p6',
      name: 'Sneha Patel',
      phone: '+91 97112 33445',
      email: 'sneha.patel@example.com',
      sports: ['Table Tennis', 'Carrom'],
      plan: 'Standard',
      credits: 30,
      status: 'Active',
      avatarInitial: 'S',
      joinedDate: '05 Apr 2026',
    ),
    RegisteredPlayer(
      id: 'p7',
      name: 'Karthik Raman',
      phone: '+91 99001 22334',
      email: 'karthik.r@example.com',
      sports: ['Football', 'Cricket'],
      plan: 'Weekend Pass',
      credits: 45,
      status: 'Active',
      avatarInitial: 'K',
      joinedDate: '15 May 2026',
    ),
    RegisteredPlayer(
      id: 'p8',
      name: 'Ananya Iyer',
      phone: '+91 98334 55667',
      email: 'ananya.iyer@example.com',
      sports: ['Badminton', 'Chess'],
      plan: 'PlayVue Plus',
      credits: 110,
      status: 'Active',
      avatarInitial: 'A',
      joinedDate: '02 Jun 2026',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _players.where((p) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return p.name.toLowerCase().contains(q) ||
          p.phone.contains(q) ||
          p.email.toLowerCase().contains(q) ||
          p.sports.any((s) => s.toLowerCase().contains(q)) ||
          p.plan.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      appBar: AppBar(
        title: const Text('Registered Players'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search players by name, sport, or plan...',
              hintStyle: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.fieldBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.fieldBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
            onChanged: (val) => setState(() => _searchQuery = val.trim()),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AdminSectionLabel('${filtered.length} Players Registered'),
              Text(
                'Total: ${_players.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  'No players found',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            for (var i = 0; i < filtered.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              _PlayerDetailCard(player: filtered[i]),
            ],
        ],
      ),
    );
  }
}

class _PlayerDetailCard extends StatelessWidget {
  const _PlayerDetailCard({required this.player});

  final RegisteredPlayer player;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(
                  player.avatarInitial,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${player.phone}  ·  ${player.email}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              AdminBadge(
                label: player.status,
                color: adminStatusColor(player.status),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: AppColors.fieldBorder),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Membership',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    player.plan,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Credits',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${player.credits} pts',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Sports',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    player.sports.join(', '),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
