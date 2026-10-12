import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class ProfileTravelerCard extends StatelessWidget {
  const ProfileTravelerCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DalmColors.surfaceMuted,
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        key: const Key('traveler-card'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '평행한 여행자 02',
                      style: DalmTypography.bodyBold.copyWith(
                        color: DalmColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '2026년 8월부터 기록 중',
                      style: DalmTypography.caption.copyWith(
                        color: DalmColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: DalmColors.textWarm,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
