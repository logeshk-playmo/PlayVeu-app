import 'package:flutter/material.dart';

import '../state/app_booking_state.dart';
import '../state/app_membership_state.dart';
import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';

class MembershipsScreen extends StatefulWidget {
  const MembershipsScreen({super.key});

  @override
  State<MembershipsScreen> createState() => _MembershipsScreenState();
}

class _MembershipsScreenState extends State<MembershipsScreen> {
  @override
  void initState() {
    super.initState();
    AppMembershipState.plans.addListener(_onChanged);
    AppMembershipState.activePlan.addListener(_onChanged);
  }

  @override
  void dispose() {
    AppMembershipState.plans.removeListener(_onChanged);
    AppMembershipState.activePlan.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _subscribe(MembershipPlan plan) async {
    AppMembershipState.subscribe(plan);
    AppCreditsState.add(plan.creditsGranted);
    AppBookingState.addLedger(
      'Membership · ${plan.name}',
      plan.creditsGranted,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${plan.name} activated · +${plan.creditsGranted} credits'),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final plans = AppMembershipState.published;
    final active = AppMembershipState.activePlan.value;

    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      appBar: AppBar(title: const Text('Memberships')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          if (plans.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 48),
              child: Text(
                'No plans available.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          for (final plan in plans) ...[
            Container(
              decoration: AppSurfaces.card(
                border: active?.id == plan.id ? AppColors.primary : null,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          plan.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      Text(
                        plan.priceLabel,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${plan.duration}  ·  ${plan.creditsGranted} credits',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (plan.discountPercent > 0 || plan.subsidyCredits > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      [
                        if (plan.discountPercent > 0)
                          '${plan.discountPercent}% off bookings',
                        if (plan.subsidyCredits > 0)
                          '${plan.subsidyCredits} credit subsidy',
                      ].join('  ·  '),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  PrimaryButton(
                    label: active?.id == plan.id ? 'Active' : 'Subscribe',
                    onPressed: active?.id == plan.id
                        ? null
                        : () => _subscribe(plan),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
