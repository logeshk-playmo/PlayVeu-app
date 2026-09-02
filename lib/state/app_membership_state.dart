import 'package:flutter/foundation.dart';

class CreditMapping {
  CreditMapping({
    required this.facilityId,
    required this.sport,
    required this.creditsPerHour,
  });

  String facilityId;
  String sport;
  int creditsPerHour;

  CreditMapping copy() => CreditMapping(
        facilityId: facilityId,
        sport: sport,
        creditsPerHour: creditsPerHour,
      );
}

class MembershipPlan {
  MembershipPlan({
    required this.id,
    required this.name,
    required this.priceInr,
    required this.duration,
    required this.creditsGranted,
    this.discountPercent = 0,
    this.subsidyCredits = 0,
    this.subsidyBy = 'PlayVue',
    this.published = false,
    List<CreditMapping>? mappings,
  }) : mappings = mappings ?? [];

  String id;
  String name;
  int priceInr;
  String duration;
  int creditsGranted;
  int discountPercent;
  int subsidyCredits;
  String subsidyBy;
  bool published;
  List<CreditMapping> mappings;

  String get priceLabel => '₹$priceInr';

  int? creditsPerHourFor(String? facilityId, String sport) {
    if (facilityId == null || sport.isEmpty) return null;
    for (final mapping in mappings) {
      if (mapping.facilityId == facilityId &&
          mapping.sport.toLowerCase() == sport.toLowerCase()) {
        return mapping.creditsPerHour;
      }
    }
    return null;
  }

  MembershipPlan copy() => MembershipPlan(
        id: id,
        name: name,
        priceInr: priceInr,
        duration: duration,
        creditsGranted: creditsGranted,
        discountPercent: discountPercent,
        subsidyCredits: subsidyCredits,
        subsidyBy: subsidyBy,
        published: published,
        mappings: mappings.map((m) => m.copy()).toList(),
      );
}

abstract final class AppMembershipState {
  static final ValueNotifier<List<MembershipPlan>> plans =
      ValueNotifier<List<MembershipPlan>>(_seed());

  static final ValueNotifier<MembershipPlan?> activePlan =
      ValueNotifier<MembershipPlan?>(null);

  static List<MembershipPlan> get published =>
      plans.value.where((p) => p.published).toList();

  static void reset() {
    plans.value = _seed();
    activePlan.value = null;
  }

  static void upsert(MembershipPlan plan) {
    final next = plans.value.map((p) => p.copy()).toList();
    final index = next.indexWhere((p) => p.id == plan.id);
    if (index >= 0) {
      next[index] = plan.copy();
    } else {
      next.insert(0, plan.copy());
    }
    plans.value = next;
  }

  static void subscribe(MembershipPlan plan) {
    activePlan.value = plan.copy();
  }

  static List<MembershipPlan> _seed() => [
        MembershipPlan(
          id: 'plan_plus',
          name: 'PlayVue Plus',
          priceInr: 499,
          duration: 'Monthly',
          creditsGranted: 200,
          discountPercent: 10,
          subsidyCredits: 5,
          subsidyBy: 'PlayVue',
          published: true,
          mappings: [
            CreditMapping(
              facilityId: 'v3',
              sport: 'Badminton',
              creditsPerHour: 40,
            ),
          ],
        ),
        MembershipPlan(
          id: 'plan_weekend',
          name: 'Weekend Pass',
          priceInr: 199,
          duration: 'Monthly',
          creditsGranted: 80,
          discountPercent: 0,
          subsidyCredits: 0,
          published: false,
        ),
      ];
}
