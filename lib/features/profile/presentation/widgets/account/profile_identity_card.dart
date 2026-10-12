import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class ProfileIdentityCard extends StatelessWidget {
  const ProfileIdentityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: DalmColors.surfaceMuted,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Text(
            '평행한 여행자 02',
            style: DalmTypography.bodyBold.copyWith(
              color: DalmColors.textPrimary,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
