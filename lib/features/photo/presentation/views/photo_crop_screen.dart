import 'dart:io';
import 'dart:ui' as ui;

import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/error/network_exception.dart';
import 'package:dalm/features/photo/presentation/routes/photo_analysis_route_args.dart';
import 'package:dalm/features/photo/presentation/view_models/photo_upload_view_model.dart';
import 'package:dalm/features/photo/presentation/widgets/crop/photo_crop_toolbar.dart';
import 'package:dalm/features/photo/presentation/widgets/crop/photo_crop_viewport.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 선택한 사진을 4:5 비율로 맞추는 화면
class PhotoCropScreen extends ConsumerStatefulWidget {
  const PhotoCropScreen({super.key, required this.imagePath, this.onCompleted});

  final String imagePath;
  final ValueChanged<String>? onCompleted;

  @override
  ConsumerState<PhotoCropScreen> createState() => _PhotoCropScreenState();
}

class _PhotoCropScreenState extends ConsumerState<PhotoCropScreen> {
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

    try {
      late final String outputPath;
      try {
        outputPath = await _exportCroppedPhoto();
      } catch (_) {
        if (mounted) _showExportFailure();
        return;
      }

      if (!mounted) return;
      if (widget.onCompleted case final callback?) {
        callback(outputPath);
        return;
      }

      try {
        final result = await ref
            .read(photoUploadViewModelProvider)
            .uploadPhoto(outputPath);

        if (!mounted) {
          await _deleteTemporaryFile(outputPath);
          return;
        }

        context.pushReplacement(
          AppRoutes.photoAnalysis,
          extra: PhotoAnalysisRouteArgs(
            imagePath: outputPath,
            uploadResult: result,
          ),
        );
      } on NetworkException catch (error, stackTrace) {
        _logUploadFailure(error, stackTrace);
        if (mounted) _showUploadFailure(_uploadFailureMessage(error));
        await _deleteTemporaryFile(outputPath);
      } on Object catch (error, stackTrace) {
        _logUploadFailure(error, stackTrace);
        if (mounted) {
          _showUploadFailure('사진을 처리하지 못했어요. 다시 시도해 주세요.');
        }
        await _deleteTemporaryFile(outputPath);
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _deleteTemporaryFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } on FileSystemException {
      // 임시 파일 삭제 실패는 업로드 결과에 영향 없음
    }
  }

  Future<String> _exportCroppedPhoto() async {
    // 화면에 보이는 크롭 영역을 PNG 파일로 저장
    await WidgetsBinding.instance.endOfFrame;
    final boundary =
        _cropBoundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) throw StateError('Crop boundary is unavailable.');

    // 330 x 412.5 영역을 1320 x 1650의 정확한 4:5 비율로 출력
    final image = await boundary.toImage(pixelRatio: 4);
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

  String _uploadFailureMessage(NetworkException error) {
    if (error.statusCode == 401 || error.statusCode == 403) {
      return '로그인 정보가 만료됐어요. 다시 로그인해 주세요.';
    }
    if (error.statusCode == 422) {
      return error.message;
    }

    return switch (error.type) {
      NetworkExceptionType.connection ||
      NetworkExceptionType.connectionTimeout ||
      NetworkExceptionType.sendTimeout ||
      NetworkExceptionType.receiveTimeout => '네트워크 연결을 확인한 후 다시 시도해 주세요.',
      NetworkExceptionType.cancelled => '사진 등록이 취소됐어요.',
      _ => error.message,
    };
  }

  void _logUploadFailure(Object error, StackTrace stackTrace) {
    if (error is NetworkException) {
      debugPrint(
        '[PhotoUpload] failed '
        'type=${error.type.name} '
        'status=${error.statusCode} '
        'code=${error.code} '
        'requestId=${error.requestId} '
        'message=${error.message}',
      );
    } else {
      debugPrint('[PhotoUpload] unexpected error: $error');
    }
    debugPrintStack(stackTrace: stackTrace);
  }

  void _showUploadFailure(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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
                          const SizedBox(height: 37),
                          SizedBox(
                            width: (cropAreaWidth - 44).clamp(0.0, 346.0),
                            child: Divider(
                              key: const Key('photoCropToolbarDivider'),
                              height: 1,
                              thickness: 1,
                              color: DalmColors.textInverse.withValues(
                                alpha: 0.18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
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
