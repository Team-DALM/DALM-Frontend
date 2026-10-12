import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_profile_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/features/profile/presentation/widgets/vision_detail/profile_analysis_card.dart';
import 'package:dalm/features/profile/presentation/widgets/vision_detail/profile_analysis_progress_bar.dart';
import 'package:flutter/material.dart';

class ProfileSceneCard extends StatelessWidget {
  const ProfileSceneCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileAnalysisCard(
      title: '가장 많이 담은 장면',
      child: Column(
        children: [
          _SceneRow(
            label: '하늘',
            value: 8,
            fraction: 0.8,
            color: DalmProfileColors.analysisBlue,
          ),
          SizedBox(height: 19),
          _SceneRow(
            label: '창가',
            value: 6,
            fraction: 0.6,
            color: DalmProfileColors.analysisGold,
          ),
          SizedBox(height: 19),
          _SceneRow(
            label: '거리',
            value: 4,
            fraction: 0.4,
            color: DalmProfileColors.analysisCoral,
          ),
        ],
      ),
    );
  }
}

class _SceneRow extends StatelessWidget {
  const _SceneRow({
    required this.label,
    required this.value,
    required this.fraction,
    required this.color,
  });

  final String label;
  final int value;
  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Text(
              label,
              textAlign: TextAlign.left,
              style: DalmTypography.caption.copyWith(
                color: DalmColors.textWarm,
                fontSize: 9,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 220,
          child: ProfileAnalysisProgressBar(
            value: fraction,
            color: color,
            backgroundColor: DalmProfileColors.analysisTrack,
          ),
        ),
        SizedBox(
          width: 30,
          child: Text(
            '$value',
            textAlign: TextAlign.end,
            style: DalmTypography.caption.copyWith(
              color: DalmColors.textPrimary,
              fontSize: 9,
            ),
          ),
        ),
      ],
    );
  }
}
