import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_profile_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/features/profile/presentation/widgets/vision_detail/profile_analysis_card.dart';
import 'package:dalm/features/profile/presentation/widgets/vision_detail/profile_analysis_progress_bar.dart';
import 'package:flutter/material.dart';

class ProfileCompositionCard extends StatelessWidget {
  const ProfileCompositionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileAnalysisCard(
      title: '빛과 구도',
      child: Column(
        children: [
          const _CompositionRow(
            label: '따뜻한 빛',
            value: 0.68,
            color: DalmProfileColors.analysisGold,
          ),
          const SizedBox(height: 23),
          const _CompositionRow(
            label: '대각선 구도',
            value: 0.54,
            color: DalmProfileColors.analysisBlue,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '매칭에 사용된 이미지 특징을 월별로 요약한 결과예요.',
              style: DalmTypography.caption.copyWith(
                color: DalmColors.secondaryAction,
                fontSize: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompositionRow extends StatelessWidget {
  const _CompositionRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: DalmTypography.caption.copyWith(
                color: DalmColors.textWarm,
                fontSize: 9,
              ),
            ),
            const Spacer(),
            Text(
              '${(value * 100).round()}%',
              style: DalmTypography.bodyBold.copyWith(
                color: DalmColors.textPrimary,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ProfileAnalysisProgressBar(
          value: value,
          color: color,
          backgroundColor: DalmProfileColors.analysisTrack,
        ),
      ],
    );
  }
}
