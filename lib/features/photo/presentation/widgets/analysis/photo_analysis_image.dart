import 'dart:io';

import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/widgets/dalm_photo_frame.dart';
import 'package:flutter/material.dart';

class PhotoAnalysisImage extends StatelessWidget {
  const PhotoAnalysisImage({
    super.key,
    required this.width,
    required this.imagePath,
    required this.progress,
  });

  final double width;
  final String imagePath;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key('photoAnalysisImage'),
      width: width,
      child: DalmPhotoFrame(
        image: FileImage(File(imagePath)),
        borderRadius: BorderRadius.circular(6),
        semanticLabel: '분석 중인 오늘의 장면',
        overlay: ColoredBox(
          color: const Color(0x26000000),
          child: Center(child: _ProgressBadge(progress: progress)),
        ),
      ),
    );
  }
}

class _ProgressBadge extends StatelessWidget {
  const _ProgressBadge({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final normalizedProgress = progress.clamp(0.0, 1.0);

    return Container(
      key: const Key('photoAnalysisProgressBadge'),
      width: 84,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: DalmColors.primaryAction.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox.square(
            dimension: 19,
            child: CircularProgressIndicator(
              value: normalizedProgress,
              strokeWidth: 2,
              backgroundColor: DalmColors.textInverse.withValues(alpha: 0.25),
              color: DalmColors.emotionalAccent,
            ),
          ),
          const SizedBox(width: 9),
          Text(
            '${(normalizedProgress * 100).round()}%',
            style: DalmTypography.caption.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: DalmColors.textInverse,
            ),
          ),
        ],
      ),
    );
  }
}
