import 'dart:io';

import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/core/widgets/dalm_photo_frame.dart';
import 'package:flutter/material.dart';

class PhotoUploadFailureImage extends StatelessWidget {
  const PhotoUploadFailureImage({
    super.key,
    required this.imagePath,
    this.width = 280,
  });

  final String imagePath;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key('photoUploadFailureImage'),
      width: width,
      child: DalmPhotoFrame(
        image: FileImage(File(imagePath)),
        borderRadius: BorderRadius.circular(6),
        semanticLabel: '업로드하지 못한 오늘의 장면',
        overlay: ColoredBox(
          color: DalmColors.background.withValues(alpha: 0.38),
        ),
      ),
    );
  }
}
