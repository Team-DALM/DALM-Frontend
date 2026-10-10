import 'dart:io';

import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
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
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const ColoredBox(
                    color: DalmColors.surfaceMuted,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: DalmColors.textDisabled,
                      ),
                    ),
                  );
                },
              ),
              const ColoredBox(color: Color(0x26000000)),
              Center(child: _ProgressBadge(progress: progress)),
            ],
          ),
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
