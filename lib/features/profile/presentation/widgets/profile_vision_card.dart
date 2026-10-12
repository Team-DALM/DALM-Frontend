import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_profile_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class ProfileVisionCard extends StatelessWidget {
  const ProfileVisionCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DalmProfileColors.cardStart,
            DalmProfileColors.cardMiddle,
            DalmProfileColors.cardEnd,
          ],
          stops: [0, 0.66, 1],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: const Key('vision-card'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AUGUST · YOUR VISION',
                  style: DalmTypography.caption.copyWith(
                    color: DalmProfileColors.cardMuted,
                    fontSize: 8,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  '당신은 빛이 머무는\n조용한 공간을 자주 담았어요.',
                  style: DalmTypography.serifBody.copyWith(
                    color: DalmColors.textInverse,
                    fontSize: 19,
                    height: 1.42,
                  ),
                ),
                const SizedBox(height: 18),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _KeywordChip('#공간'),
                    _KeywordChip('#저녁빛'),
                    _KeywordChip('#비'),
                    _KeywordChip('#거리'),
                  ],
                ),
                const SizedBox(height: 26),
                const Divider(
                  height: 1,
                  color: DalmProfileColors.cardDivider,
                ),
                const SizedBox(height: 19),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '따뜻한 빛 68% · 대각선 구도 54%',
                        style: DalmTypography.caption.copyWith(
                          color: DalmProfileColors.cardMuted,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Text(
                      '자세히 보기 →',
                      style: DalmTypography.caption.copyWith(
                        color: DalmProfileColors.cardAccent,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KeywordChip extends StatelessWidget {
  const _KeywordChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: DalmProfileColors.chipBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        child: Text(
          label,
          style: DalmTypography.caption.copyWith(
            color: DalmProfileColors.cardMuted,
            fontSize: 9,
            height: 1,
          ),
        ),
      ),
    );
  }
}

