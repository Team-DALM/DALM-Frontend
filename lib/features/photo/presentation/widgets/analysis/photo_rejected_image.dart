import 'dart:io';

import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class PhotoRejectedImage extends StatelessWidget {
  const PhotoRejectedImage({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key('photoRejectedImage'),
      width: 240,
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
                  return const ColoredBox(color: DalmColors.surfaceMuted);
                },
              ),
              const ColoredBox(color: DalmColors.overlay),
              Center(
                child: Image.asset(
                  'assets/icons/photo_analysis_rejected.png',
                  width: 68,
                  height: 68,
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 30,
                child: Text(
                  '이 사진은 업로드되지 않았어요.',
                  textAlign: TextAlign.center,
                  style: DalmTypography.caption.copyWith(
                    fontSize: 9,
                    color: DalmColors.textInverse,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
