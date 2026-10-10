import 'package:flutter/material.dart';

import '../../app/theme/dalm_colors.dart';
import '../../app/theme/dalm_typography.dart';
import 'dalm_photo_frame.dart';

class DalmOverlappingPhotos extends StatelessWidget {
  const DalmOverlappingPhotos({
    super.key,
    required this.firstImage,
    required this.secondImage,
    required this.photoWidth,
    required this.photoHeight,
    required this.horizontalOffset,
    required this.verticalOffset,
    this.firstLabel,
    this.secondLabel,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
  }) : assert(photoWidth > 0, '사진 너비는 0보다 커야 합니다.'),
       assert(photoHeight > 0, '사진 높이는 0보다 커야 합니다.'),
       assert(horizontalOffset >= 0, '가로 오프셋은 0 이상이어야 합니다.'),
       assert(verticalOffset >= 0, '세로 오프셋은 0 이상이어야 합니다.');

  final ImageProvider firstImage;
  final ImageProvider secondImage;
  final double photoWidth;
  final double photoHeight;
  final double horizontalOffset;
  final double verticalOffset;
  final String? firstLabel;
  final String? secondLabel;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: photoWidth + horizontalOffset,
      height: photoHeight + verticalOffset,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            width: photoWidth,
            height: photoHeight,
            child: _PhotoCard(
              image: firstImage,
              label: firstLabel,
              borderRadius: borderRadius,
              aspectRatio: photoWidth / photoHeight,
            ),
          ),
          Positioned(
            top: verticalOffset,
            left: horizontalOffset,
            width: photoWidth,
            height: photoHeight,
            child: _PhotoCard(
              image: secondImage,
              label: secondLabel,
              borderRadius: borderRadius,
              aspectRatio: photoWidth / photoHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  const _PhotoCard({
    required this.image,
    required this.label,
    required this.borderRadius,
    required this.aspectRatio,
  });

  final ImageProvider image;
  final String? label;
  final BorderRadiusGeometry borderRadius;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return DalmPhotoFrame(
      image: image,
      aspectRatio: aspectRatio,
      borderRadius: borderRadius,
      overlay: label == null
          ? null
          : Positioned(
              left: 16,
              bottom: 14,
              child: Text(
                label!,
                style: DalmTypography.caption.copyWith(
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                  color: DalmColors.textInverse,
                ),
              ),
            ),
    );
  }
}
