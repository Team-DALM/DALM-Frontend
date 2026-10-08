import 'dart:io';
import 'dart:ui' as ui;

import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/features/photo/presentation/widgets/photo_crop_toolbar.dart';
import 'package:dalm/features/photo/presentation/widgets/photo_crop_viewport.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 선택한 사진을 4:5 비율로 맞추는 화면
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
  bool _isImageReady = false;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _reset() {
    // 사진 확대, 이동, 회전 상태 초기화
    _transformationController.value = Matrix4.identity();
    setState(() => _quarterTurns = 0);
  }

  void _rotate() {
    // 사진을 시계 방향으로 90도 회전
    _transformationController.value = Matrix4.identity();
    setState(() => _quarterTurns = (_quarterTurns + 1) % 4);
  }

  Future<void> _complete() async {
    // 이미지 로드 전 또는 저장 중 중복 실행 방지
    if (_isExporting || !_isImageReady) return;

    setState(() => _isExporting = true);

    String? outputPath;
    try {
      outputPath = await _exportCroppedPhoto();
    } catch (_) {
      if (mounted) _showExportFailure();
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }

    if (!mounted || outputPath == null) return;
    if (widget.onCompleted case final callback?) {
      callback(outputPath);
    } else {
      Navigator.of(context).pop(outputPath);
    }
  }

  Future<String> _exportCroppedPhoto() async {
    // 화면에 보이는 크롭 영역을 PNG 파일로 저장
    await WidgetsBinding.instance.endOfFrame;
    final boundary =
        _cropBoundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) throw StateError('Crop boundary is unavailable.');

    final image = await boundary.toImage(pixelRatio: 3);
    try {
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw StateError('Crop image encoding failed.');

      final outputFile = File(
        '${Directory.systemTemp.path}${Platform.pathSeparator}'
        'dalm_photo_${DateTime.now().microsecondsSinceEpoch}.png',
      );
      await outputFile.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
      return outputFile.path;
    } finally {
      image.dispose();
    }
  }

  void _showExportFailure() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('사진을 저장하지 못했어요. 다시 시도해 주세요.')),
      );
  }

  void _setImageReady(bool isReady) {
    if (_isImageReady == isReady) return;
    setState(() => _isImageReady = isReady);
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
              canProceed: _isImageReady,
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
                          PhotoCropViewport(
                            imagePath: widget.imagePath,
                            boundaryKey: _cropBoundaryKey,
                            transformationController: _transformationController,
                            quarterTurns: _quarterTurns,
                            areaWidth: cropAreaWidth,
                            areaHeight: cropAreaHeight,
                            cropWidth: cropWidth,
                            onImageReadyChanged: _setImageReady,
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
                            child: PhotoCropToolbar(
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

/// 사진 크롭 화면의 뒤로 가기와 완료 헤더
class _CropHeader extends StatelessWidget {
  const _CropHeader({
    required this.isExporting,
    required this.canProceed,
    required this.onBack,
    required this.onNext,
  });

  final bool isExporting;
  final bool canProceed;
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
              onPressed: isExporting || !canProceed ? null : onNext,
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
