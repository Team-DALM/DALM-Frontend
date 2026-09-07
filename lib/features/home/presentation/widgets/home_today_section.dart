import 'package:flutter/material.dart';

import '../../../../app/theme/dalm_colors.dart';
import '../../../../app/theme/dalm_typography.dart';
import '../../../../core/widgets/dalm_photo_pair.dart';
import '../../domain/entities/home_today_photo.dart';
import 'home_headline.dart';

enum HomeTodaySectionLayout { primary, compact }

class HomeTodaySection extends StatelessWidget {
  const HomeTodaySection({
    super.key,
    required this.canRegister,
    required this.photo,
    required this.layout,
    required this.onPhotoUpload,
    required this.onMatchTap,
  });

  final bool canRegister;
  final HomeTodayPhoto? photo;
  final HomeTodaySectionLayout layout;

  final VoidCallback onPhotoUpload;
  final ValueChanged<String> onMatchTap;

  @override
  Widget build(BuildContext context) {
    final currentPhoto = photo;

    if (currentPhoto == null) {
      return _EmptyTodayView(
        canRegister: canRegister,
        layout: layout,
        onPhotoUpload: onPhotoUpload,
      );
    }

    return switch (currentPhoto.status) {
      HomeTodayPhotoStatus.validating => _ValidatingTodayView(
        photo: currentPhoto,
        layout: layout,
      ),
      HomeTodayPhotoStatus.rejected => _RejectedTodayView(
        photo: currentPhoto,
        layout: layout,
        onPhotoUpload: onPhotoUpload,
      ),
      HomeTodayPhotoStatus.searching => _SearchingTodayView(
        photo: currentPhoto,
        layout: layout,
      ),
      HomeTodayPhotoStatus.matched => _MatchedTodayView(
        photo: currentPhoto,
        layout: layout,
        onTap: () {
          onMatchTap(currentPhoto.match!.matchId);
        },
      ),
    };
  }
}

// 오늘의 사진 등록 전 UI
class _EmptyTodayView extends StatelessWidget {
  const _EmptyTodayView({
    required this.canRegister,
    required this.layout,
    required this.onPhotoUpload,
  });

  final bool canRegister;
  final HomeTodaySectionLayout layout;
  final VoidCallback onPhotoUpload;

  static const double _cardRadius = 8;

  @override
  Widget build(BuildContext context) {
    final isCompact = layout == HomeTodaySectionLayout.compact;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeHeadline(
          title: '오늘, 어떤 장면을\n남기고 싶나요?',
          description: '잘 찍은 사진보다 마음에 남은 한 장이면 충분해요.',
        ),
        const SizedBox(height: 24),
        Opacity(
          opacity: canRegister ? 1 : 0.5,
          child: AspectRatio(
            aspectRatio: isCompact ? 1.5 : 1.08,
            child: Semantics(
              button: canRegister,
              label: canRegister ? '오늘 사진 남기기' : '현재 사진을 등록할 수 없음',
              child: CustomPaint(
                foregroundPainter: const _DashedBorderPainter(
                  color: DalmColors.border,
                  borderRadius: _cardRadius,
                ),
                child: Material(
                  color: DalmColors.surface,
                  borderRadius: BorderRadius.circular(_cardRadius),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: canRegister ? onPhotoUpload : null,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _AddPhotoIcon(),
                          const SizedBox(height: 14),
                          Text(
                            '오늘의 사진 한 장 남기기',
                            style: DalmTypography.bodyBold.copyWith(
                              color: DalmColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            canRegister
                                ? '하루에 단 한 장만 기록할 수 있어요.'
                                : '지금은 사진을 등록할 수 없어요.',
                            textAlign: TextAlign.center,
                            style: DalmTypography.caption.copyWith(
                              color: DalmColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 카메라 icon UI
class _AddPhotoIcon extends StatelessWidget {
  const _AddPhotoIcon();

  static const double _backgroundSize = 52;
  static const double _iconSize = 30;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _backgroundSize,
      height: _backgroundSize,
      decoration: const BoxDecoration(
        color: DalmColors.surfaceMuted,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.add,
        size: _iconSize,
        color: DalmColors.secondaryAction,
      ),
    );
  }
}

// 점선 Border UI
class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.borderRadius});

  final Color color;
  final double borderRadius;

  static const double _strokeWidth = 1;
  static const double _dashLength = 5;
  static const double _gapLength = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      _strokeWidth / 2,
      _strokeWidth / 2,
      size.width - _strokeWidth,
      size.height - _strokeWidth,
    );

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;

      while (distance < metric.length) {
        final end = distance + _dashLength > metric.length
            ? metric.length
            : distance + _dashLength;

        canvas.drawPath(metric.extractPath(distance, end), paint);

        distance += _dashLength + _gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius;
  }
}

class _ValidatingTodayView extends StatelessWidget {
  const _ValidatingTodayView({required this.photo, required this.layout});

  final HomeTodayPhoto photo;
  final HomeTodaySectionLayout layout;

  @override
  Widget build(BuildContext context) {
    return _TodayStatePlaceholder(
      title: '사진 확인 중',
      description: '사진이 등록 가능한 장면인지 확인하고 있습니다.',
      layout: layout,
    );
  }
}

class _RejectedTodayView extends StatelessWidget {
  const _RejectedTodayView({
    required this.photo,
    required this.layout,
    required this.onPhotoUpload,
  });

  final HomeTodayPhoto photo;
  final HomeTodaySectionLayout layout;
  final VoidCallback onPhotoUpload;

  @override
  Widget build(BuildContext context) {
    return _TodayStatePlaceholder(
      title: '사진을 다시 선택해주세요',
      description: photo.rejectionMessage ?? '등록할 수 없는 사진입니다.',
      layout: layout,
      onTap: onPhotoUpload,
    );
  }
}

class _SearchingTodayView extends StatelessWidget {
  const _SearchingTodayView({required this.photo, required this.layout});

  final HomeTodayPhoto photo;
  final HomeTodaySectionLayout layout;

  static const int _totalDays = 7;

  int get _currentDay {
    final remainingDays = photo.remainingDays ?? _totalDays;

    return (_totalDays - remainingDays + 1).clamp(1, _totalDays);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: switch (layout) {
        HomeTodaySectionLayout.primary => _PrimarySearchingTodayView(
          photo: photo,
          currentDay: _currentDay,
          totalDays: _totalDays,
        ),
        HomeTodaySectionLayout.compact => _CompactSearchingTodayView(
          photo: photo,
          currentDay: _currentDay,
          totalDays: _totalDays,
        ),
      },
    );
  }
}

class _PrimarySearchingTodayView extends StatelessWidget {
  const _PrimarySearchingTodayView({
    required this.photo,
    required this.currentDay,
    required this.totalDays,
  });

  final HomeTodayPhoto photo;
  final int currentDay;
  final int totalDays;

  static const double _cardRadius = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeHeadline(
          title: '오늘의 장면을 남겼어요.',
          description: '이제 닮은 시선을 천천히 찾아볼게요.',
        ),
        const SizedBox(height: 24),
        Material(
          color: DalmColors.surface,
          borderRadius: BorderRadius.circular(_cardRadius),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DalmPhotoPair(
                  leftImage: NetworkImage(photo.imageUrl),
                  status: DalmPhotoPairStatus.searching,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _TodayTimeBadge(registeredAt: photo.registeredAt),
                    const Spacer(),
                    Text(
                      '평행한 순간 매칭 중',
                      style: DalmTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: DalmColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Text(
                  'DAY $currentDay · $totalDays DAYS',
                  style: DalmTypography.caption.copyWith(
                    fontSize: 10,
                    letterSpacing: 0.2,
                    color: DalmColors.secondaryAction,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  photo.aiTitle ?? '가장 가까운 장면부터 살펴보고 있어요.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: DalmTypography.bodyBold.copyWith(
                    color: DalmColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CompactSearchingTodayView extends StatelessWidget {
  const _CompactSearchingTodayView({
    required this.photo,
    required this.currentDay,
    required this.totalDays,
  });

  final HomeTodayPhoto photo;
  final int currentDay;
  final int totalDays;

  static const double _cardRadius = 10;
  static const double _cardAspectRatio = 2.05;
  static const double _imageWidthFactor = 0.36;

  @override
  Widget build(BuildContext context) {
    final remainingDays = photo.remainingDays ?? totalDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '오늘의 장면',
              style: DalmTypography.bodyBold.copyWith(
                color: DalmColors.textPrimary,
              ),
            ),
            const Spacer(),
            Text(
              'SEARCHING · DAY $currentDay',
              style: DalmTypography.caption.copyWith(
                fontSize: 10,
                color: DalmColors.secondaryAction,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: _cardAspectRatio,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Material(
                color: DalmColors.surface,
                borderRadius: BorderRadius.circular(_cardRadius),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * _imageWidthFactor,
                      child: Image.network(
                        photo.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const ColoredBox(
                            color: DalmColors.surfaceMuted,
                            child: Center(
                              child: Icon(
                                Icons.image_outlined,
                                color: DalmColors.textDisabled,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 14, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              photo.aiTitle ?? '닮은 순간을 찾고 있어요.',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: DalmTypography.serifBody.copyWith(
                                color: DalmColors.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(height: 6),
                            Text(
                              '가장 가까운 장면부터 탐색 중',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: DalmTypography.caption.copyWith(
                                fontSize: 10,
                                color: DalmColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$remainingDays일 남음',
                              style: DalmTypography.caption.copyWith(
                                fontWeight: FontWeight.w700,
                                color: DalmColors.destructive,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TodayTimeBadge extends StatelessWidget {
  const _TodayTimeBadge({required this.registeredAt});

  final DateTime registeredAt;

  @override
  Widget build(BuildContext context) {
    final localDate = registeredAt.toLocal();
    final hour = localDate.hour.toString().padLeft(2, '0');
    final minute = localDate.minute.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: DalmColors.primaryAction,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'TODAY $hour:$minute',
        style: DalmTypography.caption.copyWith(
          fontSize: 9,
          height: 1,
          color: DalmColors.textInverse,
        ),
      ),
    );
  }
}

class _MatchedTodayView extends StatelessWidget {
  const _MatchedTodayView({
    required this.photo,
    required this.layout,
    required this.onTap,
  });

  final HomeTodayPhoto photo;
  final HomeTodaySectionLayout layout;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _TodayStatePlaceholder(
      title: photo.aiTitle ?? '닮은 순간을 발견했어요',
      description: '오늘 사진과 닮은 순간을 확인해보세요.',
      layout: layout,
      onTap: onTap,
    );
  }
}

class _TodayStatePlaceholder extends StatelessWidget {
  const _TodayStatePlaceholder({
    required this.title,
    required this.description,
    required this.layout,
    this.onTap,
  });

  final String title;
  final String description;
  final HomeTodaySectionLayout layout;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isPrimary = layout == HomeTodaySectionLayout.primary;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(isPrimary ? 24 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(description, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
