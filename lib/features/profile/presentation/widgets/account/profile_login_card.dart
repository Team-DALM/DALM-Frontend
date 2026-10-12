import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class ProfileLoginCard extends StatelessWidget {
  const ProfileLoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: DalmColors.surfaceMuted,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: DalmColors.kakao,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/icons/login_kakao.png',
                width: 21,
                height: 21,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '카카오 계정',
                    style: DalmTypography.bodyBold.copyWith(
                      color: DalmColors.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '연결됨 · 이메일은 공개되지 않아요.',
                    style: DalmTypography.caption.copyWith(
                      color: DalmColors.textSecondary,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '연결됨',
              style: DalmTypography.caption.copyWith(
                color: DalmColors.emotionalAccent,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
