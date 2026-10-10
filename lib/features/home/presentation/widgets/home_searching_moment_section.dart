import 'package:flutter/material.dart';

import '../../../../app/theme/dalm_colors.dart';
import '../../../../app/theme/dalm_typography.dart';
import '../../domain/entities/home_searching_moment.dart';
import 'home_searching_moment_card.dart';

class HomeSearchingMomentSection extends StatelessWidget {
  const HomeSearchingMomentSection({
    super.key,
    required this.moments,
    required this.onMomentTap,
  });

  final List<HomeSearchingMoment> moments;
  final ValueChanged<String> onMomentTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '평행한 순간을 찾는 중',
              style: DalmTypography.bodyBold.copyWith(
                color: DalmColors.textPrimary,
              ),
            ),
            const Spacer(),
            Text(
              '${moments.length}개',
              style: DalmTypography.caption.copyWith(
                color: DalmColors.secondaryAction,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (int index = 0; index < moments.length; index++) ...[
          HomeSearchingMomentCard(
            moment: moments[index],
            onTap: () => onMomentTap(moments[index].id),
          ),
          if (index < moments.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}
