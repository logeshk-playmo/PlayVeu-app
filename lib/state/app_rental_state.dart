import 'package:flutter/foundation.dart';

import 'app_catalogue_state.dart';

class EquipmentRentalRecord {
  const EquipmentRentalRecord({
    required this.id,
    required this.itemId,
    required this.name,
    required this.category,
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
  final String name;
  final String category;
  final String image;
  final String rentedDate;
  final String duration;
  final String returnDate;
  final String price;
  final String status;
  final String playerName;

  bool get isActive => status == 'Rented' || status == 'Overdue';

  EquipmentRentalRecord copyWith({String? status}) {
    return EquipmentRentalRecord(
      id: id,
      itemId: itemId,
      name: name,
      category: category,
      image: image,
      rentedDate: rentedDate,
      duration: duration,
      returnDate: returnDate,
      price: price,
      status: status ?? this.status,
      playerName: playerName,
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
      name: 'Yonex Astrox Racket',
      category: 'Sports Equipment',
      image: 'assets/sports/sport_badminton.png',
      rentedDate: '02 Sep 2026',
      duration: '2 Days',
      returnDate: '04 Sep 2026',
      price: '₹200',
      status: 'Rented',
    ),
    EquipmentRentalRecord(
      id: 'r2',
      itemId: 'eq2',
      name: 'Football Size 5',
      category: 'Sports Equipment',
      image: 'assets/sports/sport_football.png',
      rentedDate: '01 Sep 2026',
      duration: '3 Days',
      returnDate: '04 Sep 2026',
      price: '₹150',
      status: 'Rented',
    ),
    EquipmentRentalRecord(
      id: 'r3',
      itemId: 'eq3',
      name: 'Cricket Kit',
      category: 'Sports Equipment',
      image: 'assets/sports/sport_box_cricket.png',
      rentedDate: '25 Aug 2026',
      duration: '4 Days',
      returnDate: '29 Aug 2026',
      price: '₹450',
      status: 'Returned',
    ),
    EquipmentRentalRecord(
      id: 'r4',
      itemId: 'eq4',
      name: 'TT Paddle Set',
      category: 'Sports Equipment',
      image: 'assets/sports/sport_table_tennis.png',
      rentedDate: '20 Aug 2026',
      duration: '1 Day',
      returnDate: '21 Aug 2026',
      price: '₹100',
      status: 'Returned',
    ),
  ];

  static void reset() {
    rentals.value = List<EquipmentRentalRecord>.from(_seed);
  }

  static void rent(EquipmentItem item, {String playerName = 'Logesh'}) {
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

    AppCatalogueState.adjustStock(item.id, -1);
    rentals.value = [
      EquipmentRentalRecord(
        id: 'r_${now.millisecondsSinceEpoch}',
        itemId: item.id,
        name: item.name,
        category: item.category,
        image: item.image,
        rentedDate: _formatDate(now),
        duration: duration,
        returnDate: _formatDate(due),
        price: rupeePart,
        status: 'Rented',
        playerName: playerName,
      ),
      ...rentals.value,
    ];
  }

  static void markReturned(String id) {
    overrideStatus(id, 'Returned');
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
