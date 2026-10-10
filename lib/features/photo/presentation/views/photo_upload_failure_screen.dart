import 'dart:io';

import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/widgets/dalm_app_bar.dart';
import 'package:dalm/core/widgets/dalm_button.dart';
import 'package:dalm/features/photo/presentation/routes/photo_analysis_route_args.dart';
import 'package:dalm/features/photo/presentation/view_models/photo_upload_view_model.dart';
import 'package:dalm/features/photo/presentation/widgets/upload/photo_upload_failure_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PhotoUploadFailureScreen extends ConsumerStatefulWidget {
  const PhotoUploadFailureScreen({
    super.key,
    required this.imagePath,
    this.deleteImageOnDispose = true,
  });

  final String imagePath;
  final bool deleteImageOnDispose;

  @override
  ConsumerState<PhotoUploadFailureScreen> createState() =>
      _PhotoUploadFailureScreenState();
}

class _PhotoUploadFailureScreenState
    extends ConsumerState<PhotoUploadFailureScreen> {
  bool _isRetrying = false;
  bool _transferredImage = false;

  @override
  void dispose() {
    if (widget.deleteImageOnDispose && !_transferredImage) {
      _deleteTemporaryImage();
    }
    super.dispose();
  }

  Future<void> _deleteTemporaryImage() async {
    try {
      final file = File(widget.imagePath);
      if (await file.exists()) await file.delete();
    } on FileSystemException {
      // 임시 이미지 정리 실패는 화면 이동을 막지 않는다.
    }
  }

  Future<void> _retry() async {
    if (_isRetrying) return;
    setState(() => _isRetrying = true);

    try {
      final result = await ref
          .read(photoUploadViewModelProvider)
          .uploadPhoto(widget.imagePath);
      if (!mounted) return;

      _transferredImage = true;
      context.pushReplacement(
        AppRoutes.photoAnalysis,
        extra: PhotoAnalysisRouteArgs(
          imagePath: widget.imagePath,
          uploadResult: result,
        ),
      );
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('업로드에 다시 실패했어요. 잠시 후 시도해 주세요.')),
        );
    } finally {
      if (mounted) setState(() => _isRetrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DalmColors.background,
      appBar: const DalmAppBar(
        title: '업로드하지 못했어요',
        showBackButton: true,
        leadingWidth: 44,
        dividerIndent: 20,
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 70,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/icons/photo_upload_failure.png',
                      width: 76,
                      height: 76,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '사진을 남기지 못했어요.',
                      style: DalmTypography.serifHeadline.copyWith(
                        fontSize: 23,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '연결이 불안정해 업로드가 멈췄어요.\n선택한 사진은 기기에 안전하게 남아 있어요.',
                      textAlign: TextAlign.center,
                      style: DalmTypography.caption.copyWith(
                        fontSize: 10,
                        color: DalmColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 45),
                    PhotoUploadFailureImage(imagePath: widget.imagePath),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DalmButton(
                            label: '다시 시도하기',
                            onPressed: _retry,
                            isLoading: _isRetrying,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DalmButton(
                            label: '나중에',
                            variant: DalmButtonVariant.secondary,
                            onPressed: _isRetrying
                                ? null
                                : () => context.go(AppRoutes.home),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
