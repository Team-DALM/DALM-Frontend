import 'package:flutter/material.dart';

import '../../../../app/theme/dalm_colors.dart';
import '../../../../app/theme/dalm_typography.dart';

class HomeHeadline extends StatelessWidget {
  const HomeHeadline({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: DalmTypography.serifHeadline.copyWith(
              color: DalmColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: DalmTypography.caption.copyWith(
              color: DalmColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
