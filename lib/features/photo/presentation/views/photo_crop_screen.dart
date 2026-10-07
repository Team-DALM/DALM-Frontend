import 'dart:io';
import 'dart:ui' as ui;

import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PhotoCropScreen extends StatefulWidget {
  const PhotoCropScreen({super.key, required this.imagePath, this.onCompleted});

  final String imagePath;
  final ValueChanged<String>? onCompleted;

  @override
  State<PhotoCropScreen> createState() => _PhotoCropScreenState();
}

class _PhotoCropScreenState extends State<PhotoCropScreen> {
  final _cropBoundaryKey = GlobalKey();
  final _transformationController = TransformationController();

  int _quarterTurns = 0;
  bool _isExporting = false;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _reset() {
    _transformationController.value = Matrix4.identity();
    setState(() => _quarterTurns = 0);
  }

  void _rotate() {
    _transformationController.value = Matrix4.identity();
    setState(() => _quarterTurns = (_quarterTurns + 1) % 4);
  }

  Future<void> _complete() async {
    if (_isExporting) return;

    setState(() => _isExporting = true);

    try {
      await WidgetsBinding.instance.endOfFrame;
      final boundary =
          _cropBoundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (byteData == null) return;

      final outputFile = File(
        '${Directory.systemTemp.path}${Platform.pathSeparator}'
        'dalm_photo_${DateTime.now().microsecondsSinceEpoch}.png',
      );
      await outputFile.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

      if (!mounted) return;
      if (widget.onCompleted case final callback?) {
        callback(outputFile.path);
      } else {
        Navigator.of(context).pop(outputFile.path);
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DalmColors.photoEditorBackground,
      body: SafeArea(
        child: Column(
          children: [
            _CropHeader(
              isExporting: _isExporting,
              onBack: () => Navigator.of(context).maybePop(),
              onNext: _complete,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cropAreaWidth = constraints.maxWidth.clamp(0.0, 390.0);
                  final designScale = cropAreaWidth / 390;
                  final cropAreaHeight = 490 * designScale;
                  final cropWidth = (cropAreaWidth - 60).clamp(0.0, 330.0);

                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            key: const Key('photoCropArea'),
                            width: cropAreaWidth,
                            height: cropAreaHeight,
                            child: Center(
                              child: SizedBox(
                                key: const Key('photoCropViewport'),
                                width: cropWidth,
                                child: AspectRatio(
                                  aspectRatio: 4 / 5,
                                  child: ClipRect(
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        RepaintBoundary(
                                          key: _cropBoundaryKey,
                                          child: InteractiveViewer(
                                            transformationController:
                                                _transformationController,
                                            minScale: 1,
                                            maxScale: 5,
                                            child: RotatedBox(
                                              quarterTurns: _quarterTurns,
                                              child: Image.file(
                                                File(widget.imagePath),
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => ColoredBox(
                                                      color: DalmColors
                                                          .photoEditorSurface,
                                                      child: Center(
                                                        child: Icon(
                                                          Icons
                                                              .broken_image_outlined,
                                                          color: DalmColors
                                                              .textInverse
                                                              .withValues(
                                                                alpha: 0.54,
                                                              ),
                                                          size: 42,
                                                        ),
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const IgnorePointer(
                                          child: CustomPaint(
                                            painter: _CropGridPainter(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '손가락으로 확대하고 움직여 장면을 맞춰주세요.',
                            style: DalmTypography.caption.copyWith(
                              fontSize: 10,
                              color: DalmColors.photoEditorTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 54),
                          SizedBox(
                            width: cropAreaWidth,
                            child: _CropToolbar(
                              onReset: _reset,
                              onRotate: _rotate,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CropHeader extends StatelessWidget {
  const _CropHeader({
    required this.isExporting,
    required this.onBack,
    required this.onNext,
  });

  final bool isExporting;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key('photoCropHeader'),
      height: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            IconButton(
              tooltip: '뒤로 가기',
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: DalmColors.textInverse,
              ),
            ),
            Text(
              '사진 맞추기',
              style: DalmTypography.bodyBold.copyWith(
                color: DalmColors.textInverse,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: isExporting ? null : onNext,
              child: isExporting
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: DalmColors.emotionalAccent,
                      ),
                    )
                  : Text(
                      '다음',
                      style: DalmTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: DalmColors.emotionalAccent,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CropToolbar extends StatelessWidget {
  const _CropToolbar({required this.onReset, required this.onRotate});

  final VoidCallback onReset;
  final VoidCallback onRotate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CropToolButton(
          icon: Icons.refresh_rounded,
          label: '초기화',
          tooltip: '사진 위치 초기화',
          onPressed: onReset,
        ),
        const _AspectRatioIndicator(),
        _CropToolButton(
          icon: Icons.crop_free_rounded,
          label: '회전',
          tooltip: '사진 90도 회전',
          onPressed: onRotate,
        ),
      ],
    );
  }
}

class _CropToolButton extends StatelessWidget {
  const _CropToolButton({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: InkResponse(
        onTap: onPressed,
        radius: 32,
        child: SizedBox(
          width: 72,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: DalmColors.textInverse, size: 26),
              const SizedBox(height: 9),
              Text(
                label,
                style: DalmTypography.caption.copyWith(
                  fontSize: 10,
                  color: DalmColors.photoEditorTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AspectRatioIndicator extends StatelessWidget {
  const _AspectRatioIndicator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: DalmColors.photoEditorSurface,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '4 : 5',
              style: DalmTypography.caption.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: DalmColors.emotionalAccent,
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '고정 비율',
            style: DalmTypography.caption.copyWith(
              fontSize: 10,
              color: DalmColors.photoEditorTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

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
