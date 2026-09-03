import 'package:flutter/foundation.dart';
import 'package:hugeicons/hugeicons.dart';

enum CatalogueType { equipment, gear, shoes }

extension CatalogueTypeLabel on CatalogueType {
  String get label {
    switch (this) {
      case CatalogueType.equipment:
        return 'Equipment';
      case CatalogueType.gear:
        return 'Gear';
      case CatalogueType.shoes:
        return 'Shoes';
    }
  }
}

class EquipmentItem {
  const EquipmentItem({
    required this.name,
    required this.sport,
    required this.price,
    required this.image,
    required this.icon,
    required this.category,
    required this.description,
    required this.features,
    required this.availability,
    this.id = '',
    this.condition = 'Excellent',
    this.deposit = '₹100 (Refundable)',
    this.rating = 4.8,
    this.reviews = 20,
    this.type = CatalogueType.equipment,
    this.published = true,
    this.stockCount = 1,
    this.physicalIds = const [],
  });

  final String id;
  final String name;
  final String sport;
  final String price;
  final String image;
  final List<List<dynamic>> icon;
  final String category;
  final String description;
  final List<String> features;
  final String availability;
  final String condition;
  final String deposit;
  final double rating;
  final int reviews;
  final CatalogueType type;
  final bool published;
  final int stockCount;
  final List<String> physicalIds;

  String get primaryUniqueId =>
      physicalIds.isNotEmpty ? physicalIds.first : '$id-001';

  EquipmentItem copyWith({
    String? id,
    String? name,
    String? sport,
    String? price,
    String? image,
    List<List<dynamic>>? icon,
    String? category,
    String? description,
    List<String>? features,
    String? availability,
    String? condition,
    String? deposit,
    double? rating,
    int? reviews,
    CatalogueType? type,
    bool? published,
    int? stockCount,
    List<String>? physicalIds,
  }) {
    return EquipmentItem(
      id: id ?? this.id,
      name: name ?? this.name,
      sport: sport ?? this.sport,
      price: price ?? this.price,
      image: image ?? this.image,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      description: description ?? this.description,
      features: features ?? this.features,
      availability: availability ?? this.availability,
      condition: condition ?? this.condition,
      deposit: deposit ?? this.deposit,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      type: type ?? this.type,
      published: published ?? this.published,
      stockCount: stockCount ?? this.stockCount,
      physicalIds: physicalIds ?? this.physicalIds,
    );
  }
}

abstract final class AppCatalogueState {
  static final ValueNotifier<List<EquipmentItem>> items =
      ValueNotifier<List<EquipmentItem>>(List.from(_seed));

  static List<EquipmentItem> get published =>
      items.value.where((item) => item.published).toList();

  static void reset() {
    items.value = List<EquipmentItem>.from(_seed);
  }

  static EquipmentItem? byId(String id) {
    for (final item in items.value) {
      if (item.id == id) return item;
    }
    return null;
  }

  static EquipmentItem? findItemByPhysicalId(String physicalId) {
    final query = physicalId.trim().toUpperCase();
    for (final item in items.value) {
      if (item.physicalIds.any((id) => id.toUpperCase() == query)) {
        return item;
      }
    }
    return null;
  }

  static bool isValidPhysicalId(String physicalId) {
    return findItemByPhysicalId(physicalId) != null;
  }

  static List<String> allPhysicalIds() {
    return items.value.expand((item) => item.physicalIds).toList();
  }

  static void adjustStock(String id, int delta) {
    if (id.isEmpty || delta == 0) return;
    final next = items.value.map((item) {
      if (item.id != id) return item;
      final stock = (item.stockCount + delta).clamp(0, 9999);
      return item.copyWith(
        stockCount: stock,
        availability: stock <= 0
            ? 'Out of stock'
            : 'In Stock ($stock Available)',
      );
    }).toList();
    items.value = next;
  }

  static void upsert(EquipmentItem item) {
    final next = List<EquipmentItem>.from(items.value);
    final index = next.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      next[index] = item;
    } else {
      next.insert(0, item);
    }
    items.value = next;
  }

  static const _seed = <EquipmentItem>[
    EquipmentItem(
      id: 'eq1',
      name: 'Yonex Astrox Racket',
      sport: 'Badminton',
      price: '₹50 / hour',
      image:
          'https://images.unsplash.com/photo-1626225453014-a9ac938c647d?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedTennisRacket,
      category: 'Rackets & Bats',
      description:
          'High-performance graphite badminton racket designed for powerful smashes and quick swings. Pre-strung with high-durability Yonex BG65 string with comfortable grip wrap.',
      features: [
        'High-modulus graphite shaft',
        'Pre-strung with Yonex BG65 string (24 lbs)',
        'Isometric head shape for enlarged sweet spot',
        'Includes padded thermal head cover',
      ],
      availability: 'In Stock (8 Available)',
      condition: 'Excellent / Pro Grade',
      deposit: '₹200 (Refundable)',
      rating: 4.9,
      reviews: 38,
      type: CatalogueType.equipment,
      stockCount: 8,
      physicalIds: [
        'RACKET-BDM-001',
        'RACKET-BDM-002',
        'RACKET-BDM-003',
        'RACKET-BDM-004',
        'RACKET-BDM-005',
        'RACKET-BDM-006',
        'RACKET-BDM-007',
        'RACKET-BDM-008',
      ],
    ),
    EquipmentItem(
      id: 'eq2',
      name: 'Football Size 5',
      sport: 'Football',
      price: '₹30 / hour',
      image:
          'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedFootball,
      category: 'Balls & Inflatables',
      description:
          'Official FIFA standard size 5 match football. Features a 32-panel PU synthetic leather outer with high air retention bladder, suitable for turf and grass.',
      features: [
        'Official match size 5 specification',
        'All-weather textured PU surface for grip',
        'Reinforced butyl bladder for air retention',
        'Air pump & pressure gauge available at desk',
      ],
      availability: 'In Stock (12 Available)',
      condition: 'Tournament Ready',
      deposit: '₹100 (Refundable)',
      rating: 4.7,
      reviews: 45,
      type: CatalogueType.equipment,
      stockCount: 12,
      physicalIds: [
        'BALL-FB-001',
        'BALL-FB-002',
        'BALL-FB-003',
        'BALL-FB-004',
        'BALL-FB-005',
        'BALL-FB-006',
        'BALL-FB-007',
        'BALL-FB-008',
        'BALL-FB-009',
        'BALL-FB-010',
        'BALL-FB-011',
        'BALL-FB-012',
      ],
    ),
    EquipmentItem(
      id: 'eq3',
      name: 'Cricket Kit',
      sport: 'Cricket',
      price: '₹80 / hour',
      image:
          'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedCricketBat,
      category: 'Full Protection Kits',
      description:
          'Comprehensive cricket kit containing an English willow bat, premium batting leg guards, batting gloves, thigh pad, and a lightweight safety helmet.',
      features: [
        'Grade 1 English willow cricket bat',
        'Dual-density foam batting pads & gloves',
        'Adjustable grill safety helmet',
        'Compact carry kit bag included',
      ],
      availability: 'In Stock (4 Sets Available)',
      condition: 'Professional Grade',
      deposit: '₹300 (Refundable)',
      rating: 4.8,
      reviews: 29,
      type: CatalogueType.gear,
      stockCount: 4,
      physicalIds: [
        'KIT-CRI-001',
        'KIT-CRI-002',
        'KIT-CRI-003',
        'KIT-CRI-004',
      ],
    ),
    EquipmentItem(
      id: 'eq4',
      name: 'TT Paddle Set',
      sport: 'Table Tennis',
      price: '₹40 / hour',
      image:
          'https://images.unsplash.com/photo-1609710228159-0fa9bd7c0827?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedTableTennisBat,
      category: 'Paddles & Table Gear',
      description:
          'Pair of ITTF approved ping pong paddles with spin-optimized rubber padding and comfortable flared wood handles. Includes 3 competition 3-star balls.',
      features: [
        '2 premium table tennis paddles',
        'ITTF approved spin & speed rubber',
        '3 seamless 3-star 40+ celluloid balls',
        'Protective zippered hard case',
      ],
      availability: 'In Stock (6 Sets Available)',
      condition: 'Excellent Condition',
      deposit: '₹150 (Refundable)',
      rating: 4.8,
      reviews: 32,
      type: CatalogueType.equipment,
      stockCount: 6,
      physicalIds: [
        'PAD-TT-001',
        'PAD-TT-002',
        'PAD-TT-003',
        'PAD-TT-004',
        'PAD-TT-005',
        'PAD-TT-006',
      ],
    ),
    EquipmentItem(
      id: 'eq5',
      name: 'Chess Set',
      sport: 'Chess',
      price: '₹20 / session',
      image:
          'https://images.unsplash.com/photo-1529699211952-734e80c4d42b?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedChessKing,
      category: 'Board Games',
      description:
          'Tournament standard weighted Staunton chess pieces with felted bottoms, rollup tournament board, and digital chess timer upon request.',
      features: [
        'Triple weighted Staunton regulation pieces',
        'Roll-up vinyl tournament board (20x20")',
        'Extra queens included for pawn promotion',
        'Optional DGT digital chess clock',
      ],
      availability: 'In Stock (10 Sets Available)',
      condition: 'Mint Condition',
      deposit: '₹100 (Refundable)',
      rating: 4.9,
      reviews: 21,
      type: CatalogueType.gear,
      stockCount: 10,
      physicalIds: [
        'SET-CHS-001',
        'SET-CHS-002',
        'SET-CHS-003',
        'SET-CHS-004',
        'SET-CHS-005',
        'SET-CHS-006',
        'SET-CHS-007',
        'SET-CHS-008',
        'SET-CHS-009',
        'SET-CHS-010',
      ],
    ),
    EquipmentItem(
      id: 'eq6',
      name: 'Carrom Board',
      sport: 'Carrom',
      price: '₹35 / hour',
      image:
          'https://images.unsplash.com/photo-1575444758702-4a6b9222336e?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedGame,
      category: 'Board Games',
      description:
          'Full-size 32x32 inch champion carrom board crafted from smooth English birch ply with sturdy hardwood borders. Includes tournament coins, striker, and surface powder.',
      features: [
        '32x32 inch smooth English ply playing surface',
        'Heavy-duty 3-inch wooden borders for rebound',
        'Complete set of wooden coins & precision striker',
        'High-grade boric powder bottle included',
      ],
      availability: 'In Stock (5 Boards Available)',
      condition: 'Club Standard',
      deposit: '₹150 (Refundable)',
      rating: 4.6,
      reviews: 19,
      type: CatalogueType.gear,
      stockCount: 5,
      physicalIds: [
        'BRD-CAR-001',
        'BRD-CAR-002',
        'BRD-CAR-003',
        'BRD-CAR-004',
        'BRD-CAR-005',
      ],
    ),
    EquipmentItem(
      id: 'eq7',
      name: 'Yonex Power Cushion Shoes',
      sport: 'Badminton',
      price: '₹80 / day',
      image:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedWorkoutRun,
      category: 'Shoes',
      description:
          'Non-marking indoor badminton shoes with Power Cushion midsole for shock absorption on hard courts. Available in sizes UK 6–11.',
      features: [
        'Non-marking gum rubber outsole',
        'Power Cushion shock absorption',
        'Breathable mesh upper',
        'Sizes UK 6 to UK 11',
      ],
      availability: 'In Stock (14 Pairs Available)',
      condition: 'New / Rental Grade',
      deposit: '₹250 (Refundable)',
      rating: 4.8,
      reviews: 16,
      type: CatalogueType.shoes,
      stockCount: 14,
      physicalIds: [
        'SHOE-BDM-001',
        'SHOE-BDM-002',
        'SHOE-BDM-003',
        'SHOE-BDM-004',
        'SHOE-BDM-005',
        'SHOE-BDM-006',
        'SHOE-BDM-007',
        'SHOE-BDM-008',
        'SHOE-BDM-009',
        'SHOE-BDM-010',
        'SHOE-BDM-011',
        'SHOE-BDM-012',
        'SHOE-BDM-013',
        'SHOE-BDM-014',
      ],
    ),
    EquipmentItem(
      id: 'eq8',
      name: 'Nivia Football Studs',
      sport: 'Football',
      price: '₹60 / day',
      image:
          'https://images.unsplash.com/photo-1511886929837-354d827aae26?w=800&auto=format&fit=crop&q=60',
      icon: HugeIcons.strokeRoundedWorkoutRun,
      category: 'Shoes',
      description:
          'Firm-ground football boots with moulded studs for turf and natural grass. Includes spare laces.',
      features: [
        'Moulded FG studs',
        'Synthetic leather upper',
        'Padded collar',
        'Sizes UK 6 to UK 11',
      ],
      availability: 'In Stock (10 Pairs Available)',
      condition: 'Good / Match Ready',
      deposit: '₹200 (Refundable)',
      rating: 4.5,
      reviews: 11,
      type: CatalogueType.shoes,
      stockCount: 10,
      physicalIds: [
        'SHOE-FB-001',
        'SHOE-FB-002',
        'SHOE-FB-003',
        'SHOE-FB-004',
        'SHOE-FB-005',
        'SHOE-FB-006',
        'SHOE-FB-007',
        'SHOE-FB-008',
        'SHOE-FB-009',
        'SHOE-FB-010',
      ],
    ),
  ];
}
