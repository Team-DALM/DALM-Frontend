import 'package:flutter/material.dart';

import '../../../../app/theme/dalm_colors.dart';
import '../../../../app/theme/dalm_typography.dart';
import '../../../../core/widgets/dalm_progress_indicator.dart';
import '../../domain/entities/home_searching_moment.dart';

class HomeSearchingMomentCard extends StatelessWidget {
  const HomeSearchingMomentCard({
    super.key,
    required this.moment,
    required this.onTap,
  });

  final HomeSearchingMoment moment;
  final VoidCallback onTap;

  static const int _totalDays = 7;

  // 카드 전체의 가로·세로 비율
  static const double _cardAspectRatio = 1.65;

  // 카드 전체 너비에서 사진이 차지하는 비율
  static const double _imageWidthFactor = 0.36;

  static const double _borderRadius = 14;

  /// 서버가 내려준 남은 일수를 현재 탐색 일차로 변환합니다.
  ///
  /// 7일 남음 → DAY 1
  /// 4일 남음 → DAY 4
  /// 1일 남음 → DAY 7
  int get _currentDay {
    return (_totalDays - moment.remainingDays + 1).clamp(1, _totalDays);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: Semantics(
        button: true,
        label:
            '${moment.aiTitle}, '
            '탐색 $_currentDay일 차, '
            '${moment.remainingDays}일 남음',
        child: AspectRatio(
          aspectRatio: _cardAspectRatio,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final imageWidth = constraints.maxWidth * _imageWidthFactor;

              return DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A11141B),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: DalmColors.surface,
                  borderRadius: BorderRadius.circular(_borderRadius),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onTap,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: imageWidth,
                          child: _MomentImage(imageUrl: moment.imageUrl),
                        ),
                        Expanded(
                          child: _MomentInformation(
                            moment: moment,
                            currentDay: _currentDay,
                            totalDays: _totalDays,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MomentImage extends StatelessWidget {
  const _MomentImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const ColoredBox(
          color: DalmColors.surfaceMuted,
          child: Center(
            child: Icon(
              Icons.image_outlined,
              size: 28,
              color: DalmColors.textDisabled,
            ),
          ),
        );
      },
    );
  }
}

class _MomentInformation extends StatelessWidget {
  const _MomentInformation({
    required this.moment,
    required this.currentDay,
    required this.totalDays,
  });

  final HomeSearchingMoment moment;
  final int currentDay;
  final int totalDays;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_formatDate(moment.registeredAt)}'
            ' · DAY $currentDay',
            style: DalmTypography.caption.copyWith(
              fontSize: 10,
              height: 1.2,
              letterSpacing: 0.3,
              color: DalmColors.secondaryAction,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            moment.aiTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: DalmTypography.serifHeadline.copyWith(
              fontSize: 18,
              height: 1.45,
              color: DalmColors.textPrimary,
            ),
          ),
          const Spacer(),

          // 기존 공통 진행바 사용
          DalmProgressIndicator.linear(
            currentDay: currentDay,
            totalDays: totalDays,
          ),

          const SizedBox(height: 8),
          Text(
            '닮은 순간을 찾는 중',
            style: DalmTypography.caption.copyWith(
              fontSize: 11,
              color: DalmColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: DalmColors.border),
          const SizedBox(height: 11),
          Row(
            children: [
              Text(
                '${moment.remainingDays}일 남음',
                style: DalmTypography.bodyBold.copyWith(
                  fontSize: 12,
                  color: DalmColors.emotionalAccent,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward,
                size: 18,
                color: DalmColors.textPrimary,
              ),
            ],
          ),
        ],
      ),
    );
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
