import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'primary_button.dart';

class LowCreditDialog extends StatelessWidget {
  const LowCreditDialog({
    super.key,
    required this.credits,
    required this.onBuyCredit,
  });

  final int credits;
  final VoidCallback onBuyCredit;

  static Future<void> show(BuildContext context, {required VoidCallback onBuyCredit}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => LowCreditDialog(
        credits: AppCreditsState.current,
        onBuyCredit: () {
          Navigator.pop(ctx);
          onBuyCredit();
        },
      ),
    );
  }

  static void checkAndShow(
    BuildContext context, {
    required VoidCallback onBuyCredit,
  }) {
    if (AppCreditsState.current < 10 && !AppCreditsState.hasShownLowCreditDialog) {
      AppCreditsState.hasShownLowCreditDialog = true;
      show(context, onBuyCredit: onBuyCredit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      elevation: 8,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Right Close X Button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, size: 22),
                color: AppColors.navy,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 4),

            // Warning / Coin Badge
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/coin.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Centered Title
            const Text(
              'Only few credits left!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 8),

            // Supporting Message
            const Text(
              'Buy Credit to recharge your balance and continue booking.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),

            // Available Credits Prominent Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.backgroundTop,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Available Credits: ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '$credits',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Primary Buy Credit Button
            PrimaryButton(
              label: 'Buy Credit',
              onPressed: onBuyCredit,
            ),
          ],
        ),
      ),
    );
  }
}
