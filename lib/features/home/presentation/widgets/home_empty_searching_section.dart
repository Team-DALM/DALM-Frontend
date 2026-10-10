import 'package:flutter/material.dart';

import '../../../../app/theme/dalm_colors.dart';
import '../../../../app/theme/dalm_typography.dart';
import '../../../../core/widgets/dalm_progress_indicator.dart';

class HomeEmptySearchingSection extends StatelessWidget {
  const HomeEmptySearchingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '아직 찾고 있는 닮은 순간이 없어요.',
          style: DalmTypography.bodyBold.copyWith(
            color: DalmColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '사진을 남기면 가까운 곳부터 7일 동안 찾아요.',
          style: DalmTypography.caption.copyWith(
            color: DalmColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        const DalmProgressIndicator.daily(currentDay: 1, totalDays: 7),
      ],
    );
  }
}
