import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';
import 'venue_details_screen.dart';

class VenuesScreen extends StatelessWidget {
  const VenuesScreen({super.key});

  static const List<Map<String, dynamic>> venues = [
    {
      'name': 'PlayVue Sports Academy',
      'image':
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&auto=format&fit=crop&q=60',
      'images': [
        'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?w=800&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=800&auto=format&fit=crop&q=60',
      ],
      'rating': 4.6,
      'reviews': 18,
      'distance': '~2.4 Kms',
      'location': 'Bengaluru, Karnataka',
      'description':
          'A modern sports academy offering multiple indoor and outdoor games.',
      'games': ['Badminton', 'Football', 'Cricket'],
      'facilities': ['Parking', 'Changing Rooms', 'Drinking Water'],
      'hours': '6:00 AM - 10:00 PM',
      'pricing': {'30 Mins': 300, '1 Hour': 500, '2 Hours': 900},
    },
    {
      'name': 'Elite Sports Arena',
      'image':
          'https://images.unsplash.com/photo-1521537634581-0dced2fee2ef?w=800&auto=format&fit=crop&q=60',
      'images': [
        'https://images.unsplash.com/photo-1521537634581-0dced2fee2ef?w=800&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=800&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1609710228159-0fa9bd7c0827?w=800&auto=format&fit=crop&q=60',
      ],
      'rating': 4.8,
      'reviews': 32,
      'distance': '~3.8 Kms',
      'location': 'HSR Layout, Bengaluru',
      'description':
          'Premium sports facility with international standard courts.',
      'games': ['Badminton', 'Tennis', 'Table Tennis'],
      'facilities': ['AC Courts', 'Shower', 'Lounge'],
      'hours': '5:00 AM - 11:00 PM',
      'pricing': {'30 Mins': 400, '1 Hour': 700, '2 Hours': 1200},
    },
    {
      'name': 'Smash Arena',
      'image':
          'https://images.unsplash.com/photo-1626225453014-a9ac938c647d?w=800&auto=format&fit=crop&q=60',
      'images': [
        'https://images.unsplash.com/photo-1626225453014-a9ac938c647d?w=800&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=800&auto=format&fit=crop&q=60',
      ],
      'rating': 4.4,
      'reviews': 9,
      'distance': '~5.1 Kms',
      'location': 'Indiranagar, Bengaluru',
      'description': 'Best destination for badminton and squash lovers.',
      'games': ['Badminton', 'Squash'],
      'facilities': ['Pro Shop', 'Coaching', 'Cafeteria'],
      'hours': '6:00 AM - 10:00 PM',
      'pricing': {'30 Mins': 250, '1 Hour': 450, '2 Hours': 800},
    },
    {
      'name': 'Champions Sports Club',
      'image':
          'https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=800&auto=format&fit=crop&q=60',
      'images': [
        'https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=800&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?w=800&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=800&auto=format&fit=crop&q=60',
      ],
      'rating': 4.5,
      'reviews': 21,
      'distance': '~12.4 Kms',
      'location': 'Whitefield, Bengaluru',
      'description':
          'Large multi-sport complex for families and professionals.',
      'games': ['Football', 'Cricket', 'Swimming'],
      'facilities': ['Large Ground', 'Floodlights', 'Lockers'],
      'hours': '6:00 AM - 11:00 PM',
      'pricing': {'30 Mins': 350, '1 Hour': 600, '2 Hours': 1000},
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: venues.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final venue = venues[index];
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
    switch (game) {
      case 'Football':
        return HugeIcons.strokeRoundedFootball;
      case 'Cricket':
        return HugeIcons.strokeRoundedCricketBat;
      case 'Badminton':
        return HugeIcons.strokeRoundedBadminton;
      case 'Table Tennis':
        return HugeIcons.strokeRoundedTableTennisBat;
      case 'Tennis':
        return HugeIcons.strokeRoundedTennisRacket;
      case 'Swimming':
        return HugeIcons.strokeRoundedSwimming;
      default:
        return HugeIcons.strokeRoundedWorkoutRun;
    }
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
