import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_profile_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/features/profile/presentation/widgets/vision_detail/profile_analysis_card.dart';
import 'package:flutter/material.dart';

class ProfileTimeCard extends StatelessWidget {
  const ProfileTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileAnalysisCard(
      title: '자주 머문 시간',
      child: Column(
        children: [
          Align(
            alignment: const Alignment(0.55, 0),
            child: Text(
              '18:00–21:00',
              style: DalmTypography.caption.copyWith(
                color: DalmColors.secondaryAction,
                fontSize: 9,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const _TimeRangeBar(),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '06:00',
                style: DalmTypography.caption.copyWith(
                  color: DalmColors.textWarm,
                  fontSize: 8,
                ),
              ),
              Text(
                '24:00',
                style: DalmTypography.caption.copyWith(
                  color: DalmColors.textWarm,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeRangeBar extends StatelessWidget {
  const _TimeRangeBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 14,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: DalmProfileColors.analysisTrack,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          Align(
            alignment: const Alignment(0.48, 0),
            child: FractionallySizedBox(
              widthFactor: 0.38,
              child: Container(
                height: 6,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      DalmProfileColors.analysisBlue,
                      DalmProfileColors.analysisGold,
                      DalmProfileColors.analysisCoral,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.45, 0),
            child: Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: DalmProfileColors.analysisGold,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
