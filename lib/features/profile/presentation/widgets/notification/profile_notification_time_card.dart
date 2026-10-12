import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class ProfileNotificationTimeCard extends StatelessWidget {
  const ProfileNotificationTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: DalmColors.surfaceMuted,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '기록 알림 시간',
                  style: DalmTypography.bodyBold.copyWith(
                    color: DalmColors.textPrimary,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  '오후 9:00',
                  style: DalmTypography.bodyBold.copyWith(
                    color: DalmColors.secondaryAction,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: DalmColors.warmBorder),
            const SizedBox(height: 18),
            Row(
              children: [
                Text(
                  '방해 금지 시간',
                  style: DalmTypography.caption.copyWith(
                    color: DalmColors.textSecondary,
                    fontSize: 9,
                  ),
                ),
                const Spacer(),
                Text(
                  '오후 11:00–오전 8:00',
                  style: DalmTypography.caption.copyWith(
                    color: DalmColors.textWarm,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
