import 'package:flutter/material.dart';

import '../../../../app/theme/dalm_colors.dart';
import '../../../../app/theme/dalm_typography.dart';
import '../../../../core/widgets/dalm_photo_pair.dart';
import '../../domain/entities/home_recent_match.dart';

/// 사용자가 아직 확인하지 않은 가장 최근 매칭을 보여주는 영역입니다.
class HomeRecentMatchSection extends StatelessWidget {
  const HomeRecentMatchSection({
    super.key,
    required this.match,
    required this.unviewedMatchCount,
    required this.onTap,
  });

  final HomeRecentMatch match;
  final int unviewedMatchCount;
  final VoidCallback onTap;

  static const double _cardRadius = 10;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: Semantics(
        button: true,
        label: '${match.aiTitle}, 닮은 순간 열기',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${_relativeDate(match.matchedAt)} · MOMENT FOUND',
                  style: DalmTypography.caption.copyWith(
                    fontSize: 10,
                    letterSpacing: 0.2,
                    color: DalmColors.destructive,
                  ),
                ),
                const Spacer(),
                if (unviewedMatchCount > 1)
                  Text(
                    '$unviewedMatchCount개의 새로운 발견',
                    style: DalmTypography.caption.copyWith(
                      color: DalmColors.secondaryAction,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              match.aiTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: DalmTypography.serifHeadline.copyWith(
                color: DalmColors.textPrimary,
              ),
            ),
            const SizedBox(height: 18),
            Material(
              color: DalmColors.surface,
              borderRadius: BorderRadius.circular(_cardRadius),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      DalmPhotoPair(
                        leftImage: NetworkImage(match.myImageUrl),
                        rightImage: NetworkImage(match.partnerImageUrl),
                        status: DalmPhotoPairStatus.hidden,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            _formatDate(match.matchedAt),
                            style: DalmTypography.caption.copyWith(
                              fontSize: 10,
                              color: DalmColors.secondaryAction,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '닮은 순간 열기',
                            style: DalmTypography.bodyBold.copyWith(
                              fontSize: 12,
                              color: DalmColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: DalmColors.textPrimary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _relativeDate(DateTime dateTime) {
    final now = DateTime.now();
    final localDate = dateTime.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final matchedDate = DateTime(
      localDate.year,
      localDate.month,
      localDate.day,
    );
    final days = today.difference(matchedDate).inDays;

    if (days <= 0) {
      return 'TODAY';
    }

    if (days == 1) {
      return '1 DAY AGO';
    }

    return '$days DAYS AGO';
  }

  String _formatDate(DateTime dateTime) {
    const monthNames = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    final localDate = dateTime.toLocal();
    final month = monthNames[localDate.month - 1];
    final day = localDate.day.toString().padLeft(2, '0');

    return '$month $day';
  }
}
