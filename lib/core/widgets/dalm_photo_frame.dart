import 'package:flutter/material.dart';

import '../../app/theme/dalm_colors.dart';

class DalmPhotoFrame extends StatelessWidget {
  const DalmPhotoFrame({
    super.key,
    required this.image,
    this.overlay,
    this.aspectRatio = _defaultAspectRatio,
    this.borderRadius = _defaultBorderRadius,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.loadingBuilder,
    this.errorBuilder,
  }) : assert(aspectRatio > 0, 'aspectRatio는 0보다 커야 합니다.');

  static const double _defaultAspectRatio = 4 / 5;
  static const BorderRadius _defaultBorderRadius = BorderRadius.all(
    Radius.circular(8),
  );
  static const double _loadingIndicatorSize = 24;
  static const double _errorIconSize = 28;

  final ImageProvider image;

  /// 사진 위에 표시할 화면 전용 상태입니다.
  ///
  /// 분석 진행, 사진 가림, 거절 안내 등의 표현은 부모가 만들어 전달합니다.
  final Widget? overlay;

  /// 프레임의 가로/세로 비율입니다.
  final double aspectRatio;

  /// 사진, 로딩·실패 화면, 오버레이에 공통 적용되는 모서리입니다.
  final BorderRadiusGeometry borderRadius;

  /// 사진을 프레임 안에 채우는 방식입니다.
  final BoxFit fit;

  /// 사진을 자를 때 기준이 되는 정렬 위치입니다.
  final AlignmentGeometry alignment;

  /// 접근성 서비스가 읽을 사진 설명입니다.
  final String? semanticLabel;

  /// 장식용 사진처럼 접근성 트리에서 제외해야 하는 경우 사용합니다.
  final bool excludeFromSemantics;

  /// 화면별 로딩 표현이 필요할 때 기본 로딩 화면을 대체합니다.
  final ImageLoadingBuilder? loadingBuilder;

  /// 화면별 실패 표현이 필요할 때 기본 실패 화면을 대체합니다.
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(
              image: image,
              fit: fit,
              alignment: alignment,
              semanticLabel: semanticLabel,
              excludeFromSemantics: excludeFromSemantics,
              loadingBuilder: loadingBuilder ?? _buildDefaultLoading,
              errorBuilder: errorBuilder ?? _buildDefaultError,
            ),
            ?overlay,
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultLoading(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) {
      return child;
    }

    return ExcludeSemantics(
      excluding: excludeFromSemantics,
      child: const ColoredBox(
        color: DalmColors.surfaceMuted,
        child: Center(
          child: SizedBox.square(
            dimension: _loadingIndicatorSize,
            child: CircularProgressIndicator(
              color: DalmColors.secondaryAction,
              strokeWidth: 2,
              semanticsLabel: '사진 로딩 중',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return ExcludeSemantics(
      excluding: excludeFromSemantics,
      child: const ColoredBox(
        color: DalmColors.surfaceMuted,
        child: Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: _errorIconSize,
            color: DalmColors.textSecondary,
            semanticLabel: '사진을 불러오지 못했습니다',
          ),
        ),
      ),
    );
  }
}
