import 'package:flutter/foundation.dart';

import 'app_catalogue_state.dart';

class EquipmentRentalRecord {
  const EquipmentRentalRecord({
    required this.id,
    required this.itemId,
    required this.uniqueItemId,
    required this.name,
    required this.category,
    this.sport = 'Badminton',
    required this.image,
    required this.rentedDate,
    required this.duration,
    required this.returnDate,
    required this.price,
    required this.status,
    this.playerName = 'Logesh',
  });

  final String id;
  final String itemId;
  final String uniqueItemId;
  final String name;
  final String category;
  final String sport;
  final String image;
  final String rentedDate;
  final String duration;
  final String returnDate;
  final String price;
  final String status;
  final String playerName;

  bool get isActive => status == 'Rented' || status == 'Overdue';

  EquipmentRentalRecord copyWith({
    String? status,
    String? playerName,
    String? rentedDate,
    String? duration,
    String? returnDate,
    String? price,
  }) {
    return EquipmentRentalRecord(
      id: id,
      itemId: itemId,
      uniqueItemId: uniqueItemId,
      name: name,
      category: category,
      sport: sport,
      image: image,
      rentedDate: rentedDate ?? this.rentedDate,
      duration: duration ?? this.duration,
      returnDate: returnDate ?? this.returnDate,
      price: price ?? this.price,
      status: status ?? this.status,
      playerName: playerName ?? this.playerName,
    );
  }
}

abstract final class AppRentalState {
  static final ValueNotifier<List<EquipmentRentalRecord>> rentals =
      ValueNotifier<List<EquipmentRentalRecord>>(List.from(_seed));

  static const List<EquipmentRentalRecord> _seed = [
    EquipmentRentalRecord(
      id: 'r1',
      itemId: 'eq1',
      uniqueItemId: 'RACKET-BDM-001',
      name: 'Yonex Astrox Racket',
      category: 'Rackets & Bats',
      sport: 'Badminton',
      image: 'https://images.unsplash.com/photo-1626225453014-a9ac938c647d?w=800&auto=format&fit=crop&q=60',
      rentedDate: '02 Sep 2026',
      duration: '2 Days',
      returnDate: '04 Sep 2026',
      price: '₹200',
      status: 'Rented',
      playerName: 'Rahul Kumar',
    ),
    EquipmentRentalRecord(
      id: 'r2',
      itemId: 'eq2',
      uniqueItemId: 'BALL-FB-001',
      name: 'Football Size 5',
      category: 'Balls & Inflatables',
      sport: 'Football',
      image: 'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=800&auto=format&fit=crop&q=60',
      rentedDate: '01 Sep 2026',
      duration: '3 Days',
      returnDate: '04 Sep 2026',
      price: '₹150',
      status: 'Rented',
      playerName: 'Arun Kumar',
    ),
    EquipmentRentalRecord(
      id: 'r3',
      itemId: 'eq3',
      uniqueItemId: 'KIT-CRI-001',
      name: 'Cricket Kit',
      category: 'Full Protection Kits',
      sport: 'Cricket',
      image: 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=800&auto=format&fit=crop&q=60',
      rentedDate: '25 Aug 2026',
      duration: '4 Days',
      returnDate: '29 Aug 2026',
      price: '₹450',
      status: 'Returned',
      playerName: 'Rahul Kumar',
    ),
    EquipmentRentalRecord(
      id: 'r4',
      itemId: 'eq4',
      uniqueItemId: 'PAD-TT-001',
      name: 'TT Paddle Set',
      category: 'Paddles & Table Gear',
      sport: 'Table Tennis',
      image: 'https://images.unsplash.com/photo-1609710228159-0fa9bd7c0827?w=800&auto=format&fit=crop&q=60',
      rentedDate: '20 Aug 2026',
      duration: '1 Day',
      returnDate: '21 Aug 2026',
      price: '₹100',
      status: 'Returned',
      playerName: 'Logesh',
    ),
  ];

  static void reset() {
    rentals.value = List<EquipmentRentalRecord>.from(_seed);
  }

  static Set<String> get activeRentedPhysicalIds => rentals.value
      .where((r) => r.isActive)
      .map((r) => r.uniqueItemId.toUpperCase())
      .toSet();

  static bool isPhysicalIdRented(String uniqueId) {
    return activeRentedPhysicalIds.contains(uniqueId.trim().toUpperCase());
  }

  static String assignPhysicalId(EquipmentItem item) {
    final active = activeRentedPhysicalIds;
    for (final id in item.physicalIds) {
      if (!active.contains(id.toUpperCase())) {
        return id;
      }
    }
    return item.primaryUniqueId;
  }

  static EquipmentRentalRecord? findByUniqueId(String uniqueId) {
    final query = uniqueId.trim().toUpperCase();
    for (final rental in rentals.value) {
      if (rental.uniqueItemId.toUpperCase() == query) {
        return rental;
      }
    }
    return null;
  }

  static EquipmentRentalRecord? findActiveByUniqueId(String uniqueId) {
    final query = uniqueId.trim().toUpperCase();
    for (final rental in rentals.value) {
      if (rental.uniqueItemId.toUpperCase() == query && rental.isActive) {
        return rental;
      }
    }
    return null;
  }

  static List<EquipmentRentalRecord> rentalsForPlayer(String playerName) {
    final normalized = playerName.trim().toLowerCase();
    if (normalized.isEmpty) return rentals.value;
    return rentals.value
        .where((r) => r.playerName.toLowerCase().contains(normalized))
        .toList();
  }

  static EquipmentRentalRecord rent(
    EquipmentItem item, {
    String playerName = 'Logesh',
    String? specificPhysicalId,
  }) {
    final now = DateTime.now();
    final isDay = item.price.toLowerCase().contains('day');
    final isSession = item.price.toLowerCase().contains('session');
    final duration = isDay
        ? '1 Day'
        : isSession
            ? '1 Session'
            : '1 Hour';
    final due = isDay ? now.add(const Duration(days: 1)) : now;
    final rupeePart = item.price.split(' / ').first;

    final uniqueId = specificPhysicalId ?? assignPhysicalId(item);

    AppCatalogueState.adjustStock(item.id, -1);
    final newRental = EquipmentRentalRecord(
      id: 'r_${now.millisecondsSinceEpoch}',
      itemId: item.id,
      uniqueItemId: uniqueId,
      name: item.name,
      category: item.category,
      sport: item.sport,
      image: item.image,
      rentedDate: _formatDate(now),
      duration: duration,
      returnDate: _formatDate(due),
      price: rupeePart,
      status: 'Rented',
      playerName: playerName,
    );

    rentals.value = [
      newRental,
      ...rentals.value,
    ];
    return newRental;
  }

  static void markReturned(String id) {
    overrideStatus(id, 'Returned');
  }

  static bool returnByUniqueId(String uniqueId) {
    final active = findActiveByUniqueId(uniqueId);
    if (active != null) {
      overrideStatus(active.id, 'Returned');
      return true;
    }
    return false;
  }

  static void overrideStatus(String id, String status) {
    final next = rentals.value.map((rental) {
      if (rental.id != id) return rental;
      _syncStock(rental, status);
      return rental.copyWith(status: status);
    }).toList();
    rentals.value = next;
  }

  static void _syncStock(EquipmentRentalRecord rental, String nextStatus) {
    final wasOut = rental.isActive || rental.status == 'Damaged';
    final nowOut = nextStatus == 'Rented' ||
        nextStatus == 'Overdue' ||
        nextStatus == 'Damaged';
    if (wasOut && !nowOut) {
      AppCatalogueState.adjustStock(rental.itemId, 1);
    } else if (!wasOut && nowOut) {
      AppCatalogueState.adjustStock(rental.itemId, -1);
    }
  }

  static String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final day = date.day.toString().padLeft(2, '0');
    return '$day ${months[date.month - 1]} ${date.year}';
  }
}
