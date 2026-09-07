import 'package:flutter/material.dart';

import '../../../../app/theme/dalm_colors.dart';
import '../../../../app/theme/dalm_typography.dart';
import '../../../../core/widgets/dalm_button.dart';
import '../../../../core/widgets/dalm_photo_frame.dart';
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
    return MediaQuery.withNoTextScaling(
      child: Semantics(
        liveRegion: true,
        label: '오늘 등록한 사진을 확인하고 있습니다.',
        child: switch (layout) {
          HomeTodaySectionLayout.primary => _PrimaryValidatingTodayView(
            photo: photo,
          ),
          HomeTodaySectionLayout.compact => _CompactValidatingTodayView(
            photo: photo,
          ),
        },
      ),
    );
  }
}

class _PrimaryValidatingTodayView extends StatelessWidget {
  const _PrimaryValidatingTodayView({required this.photo});

  final HomeTodayPhoto photo;

  static const double _cardRadius = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeHeadline(
          title: '오늘의 장면을 살펴보고 있어요.',
          description: '사진을 확인한 뒤 닮은 순간을 찾기 시작해요.',
        ),
        const SizedBox(height: 24),
        Material(
          color: DalmColors.surface,
          borderRadius: BorderRadius.circular(_cardRadius),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
            child: Column(
              children: [
                FractionallySizedBox(
                  widthFactor: 0.72,
                  child: DalmPhotoFrame(
                    image: NetworkImage(photo.imageUrl),
                    semanticLabel: '확인 중인 오늘의 사진',
                    overlay: const _ValidatingPhotoOverlay(),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const _ValidatingDot(),
                    const SizedBox(width: 8),
                    Text(
                      '사진 적합성 확인 중',
                      style: DalmTypography.bodyBold.copyWith(
                        color: DalmColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  '잠시 후 결과를 알려드릴게요.',
                  style: DalmTypography.caption.copyWith(
                    color: DalmColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CompactValidatingTodayView extends StatelessWidget {
  const _CompactValidatingTodayView({required this.photo});

  final HomeTodayPhoto photo;

  static const double _cardRadius = 10;
  static const double _cardAspectRatio = 2.15;
  static const double _imageWidthFactor = 0.34;

  @override
  Widget build(BuildContext context) {
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
              '사진 확인 중',
              style: DalmTypography.caption.copyWith(
                color: DalmColors.textSecondary,
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
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      SizedBox(
                        width: constraints.maxWidth * _imageWidthFactor,
                        child: DalmPhotoFrame(
                          image: NetworkImage(photo.imageUrl),
                          semanticLabel: '확인 중인 오늘의 사진',
                          overlay: const _ValidatingPhotoOverlay(compact: true),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const _ValidatingDot(),
                                const SizedBox(width: 7),
                                Text(
                                  'PHOTO CHECK',
                                  style: DalmTypography.caption.copyWith(
                                    fontSize: 9,
                                    letterSpacing: 0.3,
                                    color: DalmColors.secondaryAction,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '사진을 천천히\n살펴보고 있어요.',
                              style: DalmTypography.serifBody.copyWith(
                                color: DalmColors.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '곧 탐색을 시작해요.',
                              style: DalmTypography.caption.copyWith(
                                color: DalmColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ValidatingPhotoOverlay extends StatelessWidget {
  const _ValidatingPhotoOverlay({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: DalmColors.overlay.withValues(alpha: compact ? 0.22 : 0.28),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: compact ? 22 : 30,
              child: const CircularProgressIndicator(
                strokeWidth: 1.5,
                color: DalmColors.textInverse,
              ),
            ),
            if (!compact) ...[
              const SizedBox(height: 12),
              Text(
                '장면을 읽는 중',
                style: DalmTypography.caption.copyWith(
                  color: DalmColors.textInverse,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ValidatingDot extends StatelessWidget {
  const _ValidatingDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: const BoxDecoration(
        color: DalmColors.secondaryAction,
        shape: BoxShape.circle,
      ),
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
    return MediaQuery.withNoTextScaling(
      child: switch (layout) {
        HomeTodaySectionLayout.primary => _PrimaryRejectedTodayView(
          photo: photo,
          onPhotoUpload: onPhotoUpload,
        ),
        HomeTodaySectionLayout.compact => _CompactRejectedTodayView(
          photo: photo,
          onPhotoUpload: onPhotoUpload,
        ),
      },
    );
  }
}

class _PrimaryRejectedTodayView extends StatelessWidget {
  const _PrimaryRejectedTodayView({
    required this.photo,
    required this.onPhotoUpload,
  });

  final HomeTodayPhoto photo;
  final VoidCallback onPhotoUpload;

  static const double _cardRadius = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeHeadline(
          title: '이 장면은 남기기 어려워요.',
          description: '조금 다른 사진으로 오늘을 다시 남겨주세요.',
        ),
        const SizedBox(height: 24),
        Material(
          color: DalmColors.surface,
          borderRadius: BorderRadius.circular(_cardRadius),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
            child: Column(
              children: [
                FractionallySizedBox(
                  widthFactor: 0.68,
                  child: DalmPhotoFrame(
                    image: NetworkImage(photo.imageUrl),
                    semanticLabel: '등록이 거절된 오늘의 사진',
                    overlay: const _RejectedPhotoOverlay(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 17,
                      color: DalmColors.destructive,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      '사진 확인 결과',
                      style: DalmTypography.bodyBold.copyWith(
                        color: DalmColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: DalmColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    photo.rejectionMessage ?? '등록할 수 없는 사진입니다.',
                    style: DalmTypography.body.copyWith(
                      color: DalmColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DalmButton(label: '다른 사진 선택하기', onPressed: onPhotoUpload),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CompactRejectedTodayView extends StatelessWidget {
  const _CompactRejectedTodayView({
    required this.photo,
    required this.onPhotoUpload,
  });

  final HomeTodayPhoto photo;
  final VoidCallback onPhotoUpload;

  static const double _cardRadius = 10;
  static const double _cardAspectRatio = 1.95;
  static const double _imageWidthFactor = 0.34;

  @override
  Widget build(BuildContext context) {
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
              '다시 선택해주세요',
              style: DalmTypography.caption.copyWith(
                color: DalmColors.destructive,
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
                child: InkWell(
                  onTap: onPhotoUpload,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        SizedBox(
                          width: constraints.maxWidth * _imageWidthFactor,
                          child: DalmPhotoFrame(
                            image: NetworkImage(photo.imageUrl),
                            semanticLabel: '등록이 거절된 오늘의 사진',
                            overlay: const _RejectedPhotoOverlay(compact: true),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PHOTO CHECK',
                                style: DalmTypography.caption.copyWith(
                                  fontSize: 9,
                                  letterSpacing: 0.3,
                                  color: DalmColors.destructive,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '사진을 다시\n선택해주세요.',
                                style: DalmTypography.serifBody.copyWith(
                                  color: DalmColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                photo.rejectionMessage ?? '등록할 수 없는 사진입니다.',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: DalmTypography.caption.copyWith(
                                  fontSize: 10,
                                  color: DalmColors.textSecondary,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Text(
                                    '다른 사진 고르기',
                                    style: DalmTypography.caption.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: DalmColors.textPrimary,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.arrow_forward,
                                    size: 15,
                                    color: DalmColors.textPrimary,
                                  ),
                                ],
                              ),
                            ],
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
      ],
    );
  }
}

class _RejectedPhotoOverlay extends StatelessWidget {
  const _RejectedPhotoOverlay({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: DalmColors.overlay.withValues(alpha: 0.18),
      child: Center(
        child: Container(
          width: compact ? 30 : 42,
          height: compact ? 30 : 42,
          decoration: BoxDecoration(
            color: DalmColors.surface.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.close,
            size: compact ? 17 : 22,
            color: DalmColors.destructive,
          ),
        ),
      ),
    );
  }
}

class _SearchingTodayView extends StatelessWidget {
  const _SearchingTodayView({required this.photo, required this.layout});

  final HomeTodayPhoto photo;
  final HomeTodaySectionLayout layout;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: switch (layout) {
        HomeTodaySectionLayout.primary => _PrimarySearchingTodayView(
          photo: photo,
        ),
        HomeTodaySectionLayout.compact => _CompactSearchingTodayView(
          photo: photo,
        ),
      },
    );
  }
}

class _PrimarySearchingTodayView extends StatelessWidget {
  const _PrimarySearchingTodayView({required this.photo});

  final HomeTodayPhoto photo;

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
                const SizedBox(height: 20),
                Text(
                  photo.aiTitle ?? '가장 가까운 장면부터 살펴보고 있어요.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: DalmTypography.bodyBold.copyWith(
                    color: DalmColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '오늘부터 7일 동안 닮은 순간을 찾아요.',
                  style: DalmTypography.caption.copyWith(
                    color: DalmColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CompactSearchingTodayView extends StatelessWidget {
  const _CompactSearchingTodayView({required this.photo});

  final HomeTodayPhoto photo;

  static const double _cardRadius = 10;
  static const double _cardAspectRatio = 2.05;
  static const double _imageWidthFactor = 0.36;

  @override
  Widget build(BuildContext context) {
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
              'SEARCHING',
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
                            Text(
                              '평행한 순간 매칭 중',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: DalmTypography.caption.copyWith(
                                fontSize: 10,
                                color: DalmColors.textSecondary,
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
    final match = photo.match!;

    return MediaQuery.withNoTextScaling(
      child: switch (layout) {
        HomeTodaySectionLayout.primary => _PrimaryMatchedTodayView(
          photo: photo,
          partnerImageUrl: match.partnerImageUrl,
          onTap: onTap,
        ),
        HomeTodaySectionLayout.compact => _CompactMatchedTodayView(
          photo: photo,
          partnerImageUrl: match.partnerImageUrl,
          onTap: onTap,
        ),
      },
    );
  }
}

class _PrimaryMatchedTodayView extends StatelessWidget {
  const _PrimaryMatchedTodayView({
    required this.photo,
    required this.partnerImageUrl,
    required this.onTap,
  });

  final HomeTodayPhoto photo;
  final String partnerImageUrl;
  final VoidCallback onTap;

  static const double _cardRadius = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TODAY · MOMENT FOUND',
          style: DalmTypography.caption.copyWith(
            fontSize: 10,
            letterSpacing: 0.2,
            color: DalmColors.destructive,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          photo.aiTitle ?? '오늘 남긴 장면과 닮은\n시선이 벌써 도착했어요.',
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
                    leftImage: NetworkImage(photo.imageUrl),
                    rightImage: NetworkImage(partnerImageUrl),
                    status: DalmPhotoPairStatus.hidden,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _TodayTimeText(registeredAt: photo.registeredAt),
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
    );
  }
}

class _CompactMatchedTodayView extends StatelessWidget {
  const _CompactMatchedTodayView({
    required this.photo,
    required this.partnerImageUrl,
    required this.onTap,
  });

  final HomeTodayPhoto photo;
  final String partnerImageUrl;
  final VoidCallback onTap;

  static const double _cardRadius = 10;
  static const double _cardAspectRatio = 1.9;
  static const double _pairWidthFactor = 0.5;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '오늘의 발견',
              style: DalmTypography.bodyBold.copyWith(
                color: DalmColors.textPrimary,
              ),
            ),
            const Spacer(),
            Text(
              '오늘 도착한 연결',
              style: DalmTypography.caption.copyWith(
                color: DalmColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: _cardAspectRatio,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_cardRadius),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A11141B),
                      blurRadius: 14,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: DalmColors.surface,
                  borderRadius: BorderRadius.circular(_cardRadius),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          SizedBox(
                            width: constraints.maxWidth * _pairWidthFactor,
                            child: DalmPhotoPair(
                              leftImage: NetworkImage(photo.imageUrl),
                              rightImage: NetworkImage(partnerImageUrl),
                              status: DalmPhotoPairStatus.hidden,
                              hiddenLabel: '아직 가려진\n낯선 장면',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MOMENT FOUND',
                                  style: DalmTypography.caption.copyWith(
                                    fontSize: 9,
                                    letterSpacing: 0.3,
                                    color: DalmColors.destructive,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  photo.aiTitle ?? '닮은 순간을 발견했어요.',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: DalmTypography.serifBody.copyWith(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: DalmColors.textPrimary,
                                  ),
                                ),
                                const Spacer(),
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: DalmColors.border,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      '열어보기',
                                      style: DalmTypography.caption.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: DalmColors.textPrimary,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      width: 26,
                                      height: 26,
                                      decoration: const BoxDecoration(
                                        color: DalmColors.surfaceMuted,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward,
                                        size: 14,
                                        color: DalmColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TodayTimeText extends StatelessWidget {
  const _TodayTimeText({required this.registeredAt});

  final DateTime registeredAt;

  @override
  Widget build(BuildContext context) {
    final localDate = registeredAt.toLocal();
    final hour = localDate.hour.toString().padLeft(2, '0');
    final minute = localDate.minute.toString().padLeft(2, '0');

    return Text(
      'TODAY $hour:$minute',
      style: DalmTypography.caption.copyWith(
        fontSize: 10,
        color: DalmColors.secondaryAction,
      ),
    );
  }
}
