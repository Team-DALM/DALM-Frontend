import 'dart:io';

import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:flutter/material.dart';

/// 사진 확대와 이동을 지원하는 4:5 크롭 영역
class PhotoCropViewport extends StatefulWidget {
  const PhotoCropViewport({
    super.key,
    required this.imagePath,
    required this.boundaryKey,
    required this.transformationController,
    required this.quarterTurns,
    required this.areaWidth,
    required this.areaHeight,
    required this.cropWidth,
    required this.onImageReadyChanged,
  });

  final String imagePath;
  final GlobalKey boundaryKey;
  final TransformationController transformationController;
  final int quarterTurns;
  final double areaWidth;
  final double areaHeight;
  final double cropWidth;
  final ValueChanged<bool> onImageReadyChanged;

  @override
  State<PhotoCropViewport> createState() => _PhotoCropViewportState();
}

class _PhotoCropViewportState extends State<PhotoCropViewport> {
  bool? _lastReportedReady;

  @override
  void didUpdateWidget(covariant PhotoCropViewport oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath) {
      _reportImageReady(false);
    }
  }

  void _reportImageReady(bool isReady) {
    // 같은 로드 상태의 부모 위젯 반복 전달 방지
    if (_lastReportedReady == isReady) return;
    _lastReportedReady = isReady;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onImageReadyChanged(isReady);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key('photoCropArea'),
      width: widget.areaWidth,
      height: widget.areaHeight,
      child: Center(
        child: SizedBox(
          key: const Key('photoCropViewport'),
          width: widget.cropWidth,
          child: AspectRatio(
            aspectRatio: 4 / 5,
            child: ClipRect(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  RepaintBoundary(
                    key: widget.boundaryKey,
                    child: InteractiveViewer(
                      // 사진 줌인 및 위치 이동 기능
                      transformationController: widget.transformationController,
                      minScale: 1,
                      maxScale: 5,
                      child: RotatedBox(
                        quarterTurns: widget.quarterTurns,
                        child: Image.file(
                          File(widget.imagePath),
                          fit: BoxFit.cover,
                          frameBuilder: (context, child, frame, synchronous) {
                            if (synchronous || frame != null) {
                              _reportImageReady(true);
                            }
                            return child;
                          },
                          errorBuilder: (context, error, stackTrace) {
                            _reportImageReady(false);
                            return ColoredBox(
                              color: DalmColors.photoEditorSurface,
                              child: Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: DalmColors.textInverse.withValues(
                                    alpha: 0.54,
                                  ),
                                  size: 42,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const IgnorePointer(
                    child: CustomPaint(painter: _CropGridPainter()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 크롭 영역의 3분할 가이드와 흰색 테두리
class _CropGridPainter extends CustomPainter {
  const _CropGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = DalmColors.textInverse.withValues(alpha: 0.42)
      ..strokeWidth = 0.7;

    for (var index = 1; index < 3; index++) {
      final x = size.width * index / 3;
      final y = size.height * index / 3;
      canvas
        ..drawLine(Offset(x, 1), Offset(x, size.height - 1), gridPaint)
        ..drawLine(Offset(1, y), Offset(size.width - 1, y), gridPaint);
    }

    final borderPaint = Paint()
      ..color = DalmColors.textInverse
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRect(
      Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
