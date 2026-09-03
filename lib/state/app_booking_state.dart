import 'package:flutter/foundation.dart';

import '../theme/app_theme.dart';

class VenueBookingRecord {
  const VenueBookingRecord({
    required this.id,
    required this.venueName,
    required this.location,
    required this.image,
    required this.sport,
    required this.court,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.creditsUsed,
    required this.status,
    this.playerName = 'Logesh',
    this.isFullDay = false,
  });

  final String id;
  final String venueName;
  final String location;
  final String image;
  final String sport;
  final String court;
  final String date;
  final String startTime;
  final String endTime;
  final String duration;
  final int creditsUsed;
  final String status;
  final String playerName;
  final bool isFullDay;

  VenueBookingRecord copyWith({String? status}) {
    return VenueBookingRecord(
      id: id,
      venueName: venueName,
      location: location,
      image: image,
      sport: sport,
      court: court,
      date: date,
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      creditsUsed: creditsUsed,
      status: status ?? this.status,
      playerName: playerName,
      isFullDay: isFullDay,
    );
  }
}

class CreditLedgerEntry {
  const CreditLedgerEntry({
    required this.reason,
    required this.amount,
  });

  final String reason;
  final int amount;
}

abstract final class AppBookingState {
  static final ValueNotifier<List<VenueBookingRecord>> bookings =
      ValueNotifier<List<VenueBookingRecord>>(List.from(_seed));

  static final ValueNotifier<List<CreditLedgerEntry>> ledger =
      ValueNotifier<List<CreditLedgerEntry>>(<CreditLedgerEntry>[]);

  static const List<VenueBookingRecord> _seed = [
    VenueBookingRecord(
      id: '1',
      venueName: 'Smash Arena',
      location: 'Indiranagar, Bengaluru',
      image:
          'https://images.unsplash.com/photo-1626225453014-a9ac938c647d?w=800&auto=format&fit=crop&q=60',
      sport: 'Badminton',
      court: 'Court 2',
      date: '03 Sep 2026',
      startTime: '06:00 PM',
      endTime: '07:00 PM',
      duration: '1 Hour',
      creditsUsed: 50,
      status: 'Confirmed',
      playerName: 'Rahul Kumar',
    ),
    VenueBookingRecord(
      id: '2',
      venueName: 'PlayVue Sports Academy',
      location: 'Bengaluru, Karnataka',
      image:
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&auto=format&fit=crop&q=60',
      sport: 'Football',
      court: 'Main Turf Pitch',
      date: '03 Sep 2026',
      startTime: '06:00 AM',
      endTime: '10:00 PM',
      duration: 'Full Day',
      creditsUsed: 560,
      status: 'Confirmed',
      playerName: 'Arun Kumar',
      isFullDay: true,
    ),
    VenueBookingRecord(
      id: '3',
      venueName: 'Elite Sports Arena',
      location: 'HSR Layout, Bengaluru',
      image:
          'https://images.unsplash.com/photo-1521537634581-0dced2fee2ef?w=800&auto=format&fit=crop&q=60',
      sport: 'Tennis',
      court: 'Center Court',
      date: '04 Sep 2026',
      startTime: '07:00 AM',
      endTime: '09:00 AM',
      duration: '2 Hours',
      creditsUsed: 120,
      status: 'Pending',
      playerName: 'Vijay Kumar',
    ),
    VenueBookingRecord(
      id: '4',
      venueName: 'Champions Sports Club',
      location: 'Whitefield, Bengaluru',
      image:
          'https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=800&auto=format&fit=crop&q=60',
      sport: 'Cricket',
      court: 'Net 1',
      date: '05 Sep 2026',
      startTime: '04:00 PM',
      endTime: '06:00 PM',
      duration: '2 Hours',
      creditsUsed: 100,
      status: 'Cancelled',
      playerName: 'Rahul Kumar',
    ),
    VenueBookingRecord(
      id: '5',
      venueName: 'Smash Arena',
      location: 'Indiranagar, Bengaluru',
      image:
          'https://images.unsplash.com/photo-1626225453014-a9ac938c647d?w=800&auto=format&fit=crop&q=60',
      sport: 'Badminton',
      court: 'Court 1',
      date: '05 Sep 2026',
      startTime: '05:00 PM',
      endTime: '07:00 PM',
      duration: '2 Hours',
      creditsUsed: 80,
      status: 'Completed',
      playerName: 'Priya Sharma',
    ),
  ];

  static void reset() {
    bookings.value = List<VenueBookingRecord>.from(_seed);
    ledger.value = <CreditLedgerEntry>[];
  }

  static void add(VenueBookingRecord record) {
    bookings.value = [record, ...bookings.value];
  }

  static void addLedger(String reason, int amount) {
    ledger.value = [
      CreditLedgerEntry(reason: reason, amount: amount),
      ...ledger.value,
    ];
  }

  static void overrideStatus(String id, String status) {
    final next = bookings.value.map((b) {
      if (b.id != id) return b;
      final previous = b.status;
      if ((previous == 'Confirmed' || previous == 'Completed') &&
          (status == 'Cancelled' || status == 'No-show')) {
        AppCreditsState.add(b.creditsUsed);
        addLedger('Refund · ${b.venueName}', b.creditsUsed);
      }
      return b.copyWith(status: status);
    }).toList();
    bookings.value = next;
  }
}
