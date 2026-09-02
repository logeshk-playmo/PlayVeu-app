import 'package:flutter/foundation.dart';

import 'app_membership_state.dart';

abstract final class AppFacilityState {
  static final ValueNotifier<List<Map<String, dynamic>>> facilities =
      ValueNotifier<List<Map<String, dynamic>>>(_seed());

  static List<Map<String, dynamic>> get all =>
      facilities.value.map(_copyVenue).toList();

  static List<Map<String, dynamic>> get visibleToPlayers => facilities.value
      .where((v) => v['status'] == 'Open')
      .map(_copyVenue)
      .toList();

  static void reset() {
    facilities.value = _seed();
  }

  static Map<String, dynamic>? byId(String id) {
    for (final venue in facilities.value) {
      if (venue['id'] == id) return _copyVenue(venue);
    }
    return null;
  }

  static void upsert(Map<String, dynamic> venue) {
    final next = facilities.value.map(_copyVenue).toList();
    final id = venue['id']?.toString() ?? '';
    final index = next.indexWhere((v) => v['id'] == id);
    if (index >= 0) {
      next[index] = _copyVenue(venue);
    } else {
      next.add(_copyVenue(venue));
    }
    facilities.value = next;
  }

  static bool isBookable(Map<String, dynamic> venue) =>
      (venue['status'] as String? ?? 'Open') == 'Open';

  static int creditsForBooking({
    required Map<String, dynamic> venue,
    required String sport,
    required int amountInr,
    required int durationMinutes,
  }) {
    final hours = durationMinutes / 60.0;
    if (hours <= 0) return amountInr ~/ 10;

    final facilityId = venue['id']?.toString();
    final plan = AppMembershipState.activePlan.value;
    if (plan != null) {
      final mapped = plan.creditsPerHourFor(facilityId, sport);
      if (mapped != null) {
        var credits = (mapped * hours).round();
        if (plan.discountPercent > 0) {
          credits = (credits * (100 - plan.discountPercent) / 100).round();
        }
        credits = (credits - plan.subsidyCredits).clamp(0, 100000);
        return credits;
      }
    }

    final rates = venue['creditRates'];
    if (rates is Map && sport.isNotEmpty) {
      final perHour = rates[sport];
      if (perHour is int) {
        return (perHour * hours).round();
      }
      if (perHour is num) {
        return (perHour * hours).round();
      }
    }

    return amountInr ~/ 10;
  }

  static Map<String, dynamic> _copyVenue(Map<String, dynamic> venue) {
    final copy = Map<String, dynamic>.from(venue);
    if (venue['games'] is List) {
      copy['games'] = List<String>.from(venue['games'] as List);
    }
    if (venue['facilities'] is List) {
      copy['facilities'] = List<String>.from(venue['facilities'] as List);
    }
    if (venue['images'] is List) {
      copy['images'] = List<String>.from(venue['images'] as List);
    }
    if (venue['pricing'] is Map) {
      copy['pricing'] = Map<String, int>.from(venue['pricing'] as Map);
    }
    if (venue['creditRates'] is Map) {
      copy['creditRates'] = Map<String, int>.from(venue['creditRates'] as Map);
    } else {
      copy['creditRates'] = <String, int>{};
    }
    return copy;
  }

  static List<Map<String, dynamic>> _seed() => [
        {
          'id': 'v1',
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
          'status': 'Open',
          'rentalSlotMinutes': 30,
          'advanceBookingDays': 30,
          'cancellationNote': 'Free cancellation up to 2 hours before the slot.',
          'includedNote': 'Court, lighting, and drinking water included.',
          'creditRates': <String, int>{},
        },
        {
          'id': 'v2',
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
          'status': 'Open',
          'rentalSlotMinutes': 30,
          'advanceBookingDays': 30,
          'cancellationNote': 'Free cancellation up to 2 hours before the slot.',
          'includedNote': 'Court hire only. Gear available at the desk.',
          'creditRates': <String, int>{},
        },
        {
          'id': 'v3',
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
          'status': 'Open',
          'rentalSlotMinutes': 30,
          'advanceBookingDays': 14,
          'cancellationNote': 'Cancel at least 4 hours before to get credits back.',
          'includedNote': 'Court and shuttlecocks included.',
          'creditRates': <String, int>{'Badminton': 45, 'Squash': 40},
        },
        {
          'id': 'v4',
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
          'status': 'Open',
          'rentalSlotMinutes': 30,
          'advanceBookingDays': 30,
          'cancellationNote': 'Free cancellation up to 2 hours before the slot.',
          'includedNote': 'Pitch hire. Equipment extra.',
          'creditRates': <String, int>{},
        },
      ].map(_copyVenue).toList();
}
