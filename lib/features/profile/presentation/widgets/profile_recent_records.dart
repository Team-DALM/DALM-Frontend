import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class ProfileRecentRecords extends StatelessWidget {
  const ProfileRecentRecords({super.key});

  static const _photos = [
    'assets/images/onboarding_bus_1.png',
    'assets/images/onboarding_bus_2.png',
    'assets/images/onboarding_bus_1.png',
    'assets/images/onboarding_bus_2.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '이번 달 기록',
              style: DalmTypography.bodyBold.copyWith(
                color: DalmColors.textPrimary,
                fontSize: 13,
              ),
            ),
            const Spacer(),
            Text(
              '전체 보기',
              style: DalmTypography.caption.copyWith(
                color: DalmColors.secondaryAction,
                fontSize: 9,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var index = 0; index < _photos.length; index++) ...[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 0.78,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      _photos[index],
                      fit: BoxFit.cover,
                      alignment: index.isEven
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: AspectRatio(
                aspectRatio: 0.78,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: DalmColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '+19',
                        style: DalmTypography.body.copyWith(
                          color: DalmColors.secondaryAction,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '더보기',
                        style: DalmTypography.caption.copyWith(
                          color: DalmColors.textSecondary,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
