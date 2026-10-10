import 'dart:io';

import 'package:dalm/app/theme/dalm_colors.dart';
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
              ColoredBox(color: DalmColors.background.withValues(alpha: 0.38)),
            ],
          ),
        ),
      ),
    );
  }
}
