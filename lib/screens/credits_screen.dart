import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';
import '../widgets/primary_button.dart';
import 'credit_success_screen.dart';

class CreditsScreen extends StatefulWidget {
  const CreditsScreen({super.key, this.credits = 20, this.onBalanceChanged});

  final int credits;
  final ValueChanged<int>? onBalanceChanged;

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  static const _plans = <_CreditPlan>[
    _CreditPlan(price: '₹100', credits: 10),
    _CreditPlan(price: '₹250', credits: 30, tag: 'Popular', featured: true),
    _CreditPlan(price: '₹500', credits: 70, tag: 'Save more'),
    _CreditPlan(price: '₹1,000', credits: 160, tag: 'Best value'),
  ];

  late int _balance;
  int _selected = 1;
  bool _buying = false;

  @override
  void initState() {
    super.initState();
    _balance = widget.credits;
  }

  _CreditPlan get _plan => _plans[_selected];

  Future<void> _buy() async {
    if (_buying) return;
    setState(() => _buying = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;

    final added = _plan.credits;
    final next = _balance + added;
    setState(() {
      _balance = next;
      _buying = false;
    });
    widget.onBalanceChanged?.call(next);

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) =>
            CreditSuccessScreen(creditsAdded: added, newBalance: next),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      appBar: AppBar(title: const Text('Credits')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _BalanceCard(balance: _balance),
          const SizedBox(height: 24),
          const Text(
            'Choose a pack',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Credits never expire and can be used for any booking.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _plans.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 132,
            ),
            itemBuilder: (context, index) {
              final plan = _plans[index];
              return _PlanCard(
                plan: plan,
                selected: index == _selected,
                onTap: () => setState(() => _selected = index),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: AppSurfaces.bar,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: PrimaryButton(
              label: 'Pay ${_plan.price}',
              isLoading: _buying,
              onPressed: _buy,
            ),
          ),
        ),
      ),
    );
  }
}

class _CreditPlan {
  const _CreditPlan({
    required this.price,
    required this.credits,
    this.tag,
    this.featured = false,
  });

  final String price;
  final int credits;
  final String? tag;
  final bool featured;
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance});

  final int balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              AppIcon(
                HugeIcons.strokeRoundedWallet01,
                size: 18,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                'Available balance',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '$balance',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Credits',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final _CreditPlan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.primary.withValues(alpha: 0.08)
          : Colors.white,
      borderRadius: BorderRadius.circular(AppSurfaces.radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: AppSurfaces.card(
            color: Colors.transparent,
            border: selected ? AppColors.primary : AppColors.fieldBorder,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        plan.price,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    if (plan.tag != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: plan.featured
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          plan.tag!,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: plan.featured
                                ? Colors.white
                                : AppColors.primaryDark,
                          ),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Text(
                  '${plan.credits}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Credits',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
