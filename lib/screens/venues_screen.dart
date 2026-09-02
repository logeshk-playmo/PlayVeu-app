import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../state/app_facility_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';
import 'venue_details_screen.dart';

typedef VenueScreen = VenuesScreen;

class VenuesScreen extends StatefulWidget {
  const VenuesScreen({
    super.key,
    this.selectedSport,
  });

  final String? selectedSport;

  static List<Map<String, dynamic>> get venues =>
      AppFacilityState.visibleToPlayers;

  @override
  State<VenuesScreen> createState() => _VenuesScreenState();
}

class _VenuesScreenState extends State<VenuesScreen> {
  String? _selectedSport;

  @override
  void initState() {
    super.initState();
    _selectedSport = widget.selectedSport;
    AppFacilityState.facilities.addListener(_onFacilitiesChanged);
  }

  @override
  void dispose() {
    AppFacilityState.facilities.removeListener(_onFacilitiesChanged);
    super.dispose();
  }

  void _onFacilitiesChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant VenuesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedSport != oldWidget.selectedSport) {
      _selectedSport = widget.selectedSport;
    }
  }

  bool _matchesSport(List<String> games, String target) {
    final t = target.trim().toLowerCase();
    if (t.isEmpty || t == 'all') return true;

    for (final game in games) {
      final g = game.trim().toLowerCase();
      if (g == t) return true;

      // Robust matching for common aliases & variations
      if (t.contains('cricket') && g.contains('cricket')) return true;
      if (t.contains('pickleball') && g.contains('pickleball')) return true;
      if (t.contains('table tennis') && g.contains('table tennis')) return true;
      if (t.contains('swimming') && g.contains('swimming')) return true;
      if (t.contains('badminton') && g.contains('badminton')) return true;
      if (t.contains('football') && g.contains('football')) return true;
      if (t.contains('tennis') &&
          !t.contains('table') &&
          g.contains('tennis') &&
          !g.contains('table')) {
        return true;
      }
      if (t.contains('squash') && g.contains('squash')) return true;
    }
    return false;
  }

  List<Map<String, dynamic>> get _filteredVenues {
    if (_selectedSport == null || _selectedSport!.trim().isEmpty) {
      return VenuesScreen.venues;
    }
    return VenuesScreen.venues
        .where((venue) => _matchesSport(
              (venue['games'] as List).cast<String>(),
              _selectedSport!,
            ))
        .toList();
  }

  void _clearFilter() {
    setState(() => _selectedSport = null);
  }

  static List<List<dynamic>> _iconFor(String game) {
    final g = game.toLowerCase();
    if (g.contains('football')) return HugeIcons.strokeRoundedFootball;
    if (g.contains('cricket')) return HugeIcons.strokeRoundedCricketBat;
    if (g.contains('badminton')) return HugeIcons.strokeRoundedBadminton;
    if (g.contains('table tennis')) return HugeIcons.strokeRoundedTableTennisBat;
    if (g.contains('tennis')) return HugeIcons.strokeRoundedTennisRacket;
    if (g.contains('swimming')) return HugeIcons.strokeRoundedSwimming;
    if (g.contains('pickleball')) return HugeIcons.strokeRoundedTennisRacket;
    return HugeIcons.strokeRoundedWorkoutRun;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredVenues;
    final canPop = Navigator.of(context).canPop();

    Widget body;
    if (filtered.isEmpty) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primarySoft.withValues(alpha: 0.2),
                ),
                child: const Center(
                  child: AppIcon(
                    HugeIcons.strokeRoundedFootballPitch,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'No ${_selectedSport ?? ''} Venues',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'There are currently no venues available\nfor ${_selectedSport ?? 'this sport'}.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _clearFilter,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'View All Venues',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      body = ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        itemCount: filtered.length + (_selectedSport != null ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (_selectedSport != null && index == 0) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primarySoft.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primarySoft.withValues(alpha: 0.45),
                ),
              ),
              child: Row(
                children: [
                  AppIcon(
                    _iconFor(_selectedSport!),
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Showing venues for',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          _selectedSport!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _clearFilter,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: AppColors.primaryDark,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final venueIndex = _selectedSport != null ? index - 1 : index;
          final venue = filtered[venueIndex];
          return _VenueCard(
            venue: venue,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VenueDetailsScreen(venue: venue),
                ),
              );
            },
          );
        },
      );
    }

    if (canPop) {
      return Scaffold(
        backgroundColor: AppColors.backgroundBottom,
        appBar: AppBar(
          title: Text(_selectedSport != null ? '$_selectedSport Venues' : 'Venues'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: body,
      );
    }

    return body;
  }
}

class _VenueCard extends StatefulWidget {
  const _VenueCard({required this.venue, required this.onTap});

  final Map<String, dynamic> venue;
  final VoidCallback onTap;

  @override
  State<_VenueCard> createState() => _VenueCardState();
}

class _VenueCardState extends State<_VenueCard> {
  int _page = 0;

  List<String> get _images {
    final gallery = widget.venue['images'];
    if (gallery is List && gallery.isNotEmpty) {
      return gallery.cast<String>();
    }
    return [widget.venue['image'] as String];
  }

  int get _startingPrice {
    final pricing = widget.venue['pricing'] as Map<String, int>;
    return pricing.values.reduce(math.min);
  }

  String get _area {
    final location = widget.venue['location'] as String;
    return location.split(',').first.trim();
  }

  @override
  Widget build(BuildContext context) {
    final games = (widget.venue['games'] as List).cast<String>();
    final images = _images;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 176,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PageView.builder(
                      itemCount: images.length,
                      onPageChanged: (index) => setState(() => _page = index),
                      itemBuilder: (context, index) {
                        return Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.fieldBorder,
                              alignment: Alignment.center,
                              child: const AppIcon(
                                HugeIcons.strokeRoundedImageNotFound01,
                                color: AppColors.primary,
                                size: 36,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 64,
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0),
                                Colors.black.withValues(alpha: 0.45),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      bottom: 10,
                      child: _SportIcons(games: games.take(2).toList()),
                    ),
                    if (images.length > 1)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 12,
                        child: IgnorePointer(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var i = 0; i < images.length; i++) ...[
                                if (i > 0) const SizedBox(width: 5),
                                _PageDot(active: i == _page),
                              ],
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.venue['name'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _RatingBadge(
                          rating: widget.venue['rating'] as num,
                          reviews: widget.venue['reviews'] as int,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_area (${widget.venue['distance']})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.fieldBorder),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Price Starts from',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Text(
                      'INR $_startingPrice Onwards',
                      style: const TextStyle(
                        fontSize: 13,
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
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating, required this.reviews});

  final num rating;
  final int reviews;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '${rating.toStringAsFixed(1)} ($reviews)',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}

class _PageDot extends StatelessWidget {
  const _PageDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.primary : Colors.white,
      ),
    );
  }
}

class _SportIcons extends StatelessWidget {
  const _SportIcons({required this.games});

  final List<String> games;

  static List<List<dynamic>> _iconFor(String game) {
    final g = game.toLowerCase();
    if (g.contains('football')) return HugeIcons.strokeRoundedFootball;
    if (g.contains('cricket')) return HugeIcons.strokeRoundedCricketBat;
    if (g.contains('badminton')) return HugeIcons.strokeRoundedBadminton;
    if (g.contains('table tennis')) return HugeIcons.strokeRoundedTableTennisBat;
    if (g.contains('tennis')) return HugeIcons.strokeRoundedTennisRacket;
    if (g.contains('swimming')) return HugeIcons.strokeRoundedSwimming;
    return HugeIcons.strokeRoundedWorkoutRun;
  }

  @override
  Widget build(BuildContext context) {
    if (games.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < games.length; i++) ...[
          if (i > 0) ...[
            Container(
              width: 1,
              height: 12,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ],
          AppIcon(_iconFor(games[i]), size: 16, color: Colors.white),
        ],
      ],
    );
  }
}
