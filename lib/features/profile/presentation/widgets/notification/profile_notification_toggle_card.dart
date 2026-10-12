import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/features/profile/presentation/widgets/shared/profile_toggle_switch.dart';
import 'package:flutter/material.dart';

class ProfileNotificationToggleCard extends StatelessWidget {
  const ProfileNotificationToggleCard({
    super.key,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: DalmColors.surfaceMuted,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 15, 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: DalmTypography.bodyBold.copyWith(
                      color: DalmColors.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    description,
                    style: DalmTypography.caption.copyWith(
                      color: DalmColors.textSecondary,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ProfileToggleSwitch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
