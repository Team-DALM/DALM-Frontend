import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/features/profile/presentation/widgets/shared/profile_toggle_switch.dart';
import 'package:flutter/material.dart';

class ProfilePrivacyToggleCard extends StatelessWidget {
  const ProfilePrivacyToggleCard({
    super.key,
    required this.title,
    required this.description,
    required this.helperText,
    required this.value,
    required this.onChanged,
    this.helperColor = DalmColors.secondaryAction,
  });

  final String title;
  final String description;
  final String helperText;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color helperColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: DalmColors.surfaceMuted,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(height: 11),
                      Text(
                        description,
                        style: DalmTypography.caption.copyWith(
                          color: DalmColors.textSecondary,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ProfileToggleSwitch(value: value, onChanged: onChanged),
              ],
            ),
            const SizedBox(height: 17),
            const Divider(height: 1, color: DalmColors.warmBorder),
            const SizedBox(height: 14),
            Text(
              helperText,
              style: DalmTypography.caption.copyWith(
                color: helperColor,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
