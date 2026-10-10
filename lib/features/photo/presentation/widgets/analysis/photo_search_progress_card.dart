import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class PhotoSearchProgressCard extends StatelessWidget {
  const PhotoSearchProgressCard({super.key});

  static const _stepCount = 7;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: DalmColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('평행한 순간 탐색 시작', style: DalmTypography.bodyBold),
              Text(
                'DAY 1 / 7',
                style: DalmTypography.caption.copyWith(
                  fontSize: 9,
                  color: DalmColors.secondaryAction,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: List.generate(_stepCount * 2 - 1, (index) {
              if (index.isOdd) {
                return Expanded(
                  child: Container(height: 1, color: DalmColors.border),
                );
              }

              final isToday = index == 0;
              return Container(
                width: isToday ? 11 : 6,
                height: isToday ? 11 : 6,
                decoration: BoxDecoration(
                  color: isToday
                      ? DalmColors.emotionalAccent
                      : DalmColors.border,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '오늘',
                style: DalmTypography.caption.copyWith(
                  fontSize: 9,
                  color: DalmColors.destructive,
                ),
              ),
              Text(
                '7일 후',
                style: DalmTypography.caption.copyWith(
                  fontSize: 9,
                  color: DalmColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '업로드 사진이 7일 이내의 사진들과 비교돼요.',
            style: DalmTypography.caption.copyWith(
              fontSize: 9,
              color: DalmColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
