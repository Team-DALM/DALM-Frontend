import 'dart:io';

import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/widgets/dalm_app_bar.dart';
import 'package:dalm/features/photo/data/providers/photo_analysis_providers.dart';
import 'package:dalm/features/photo/domain/entities/photo_analysis_progress.dart';
import 'package:dalm/features/photo/presentation/widgets/analysis/photo_analysis_image.dart';
import 'package:dalm/features/photo/presentation/widgets/analysis/photo_analysis_steps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhotoAnalysisScreen extends ConsumerStatefulWidget {
  const PhotoAnalysisScreen({
    super.key,
    required this.imagePath,
    required this.photoId,
    this.deleteImageOnDispose = true,
  });

  final String imagePath;
  final String photoId;
  final bool deleteImageOnDispose;

  @override
  ConsumerState<PhotoAnalysisScreen> createState() =>
      _PhotoAnalysisScreenState();
}

class _PhotoAnalysisScreenState extends ConsumerState<PhotoAnalysisScreen> {
  @override
  void dispose() {
    if (widget.deleteImageOnDispose) _deleteTemporaryImage();
    super.dispose();
  }

  Future<void> _deleteTemporaryImage() async {
    try {
      final file = File(widget.imagePath);
      if (await file.exists()) await file.delete();
    } on FileSystemException {
      // 임시 이미지 정리 실패는 화면 흐름에 영향을 주지 않는다.
    }
  }

  @override
  Widget build(BuildContext context) {
    final analysisState = ref.watch(
      photoAnalysisProgressProvider(widget.photoId),
    );
    final analysis = switch (analysisState) {
      AsyncData(:final value) => value,
      _ => const PhotoAnalysisProgress(
        status: PhotoAnalysisStatus.validating,
        progress: 0,
        activeStep: 0,
      ),
    };
    final isRejected = analysis.status == PhotoAnalysisStatus.rejected;
    final isCompleted = analysis.isComplete;

    return Scaffold(
      backgroundColor: DalmColors.background,
      appBar: DalmAppBar(
        title: isCompleted ? '사진 확인 완료' : '장면을 읽는 중',
        showBackButton: true,
        leadingWidth: 44,
        dividerIndent: 20,
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final imageWidth = (constraints.maxWidth - 112).clamp(220.0, 280.0);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (constraints.maxHeight - 60).clamp(
                    0,
                    double.infinity,
                  ),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      PhotoAnalysisImage(
                        width: imageWidth,
                        imagePath: widget.imagePath,
                        progress: analysis.progress,
                      ),
                      const SizedBox(height: 28),
                      Text(
                        isRejected
                            ? '사진을 충분히 읽지 못했어요.'
                            : isCompleted
                            ? '오늘의 장면을 모두 읽었어요.'
                            : '사진 속 빛과 구도를 읽고 있어요.',
                        textAlign: TextAlign.center,
                        style: DalmTypography.serifHeadline.copyWith(
                          fontSize: 18,
                          color: DalmColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isRejected
                            ? '다른 사진으로 다시 시도해 주세요.'
                            : isCompleted
                            ? '닮은 순간을 찾을 준비가 됐어요.'
                            : '잠시만 기다리면 오늘의 탐색이 시작돼요.',
                        textAlign: TextAlign.center,
                        style: DalmTypography.caption.copyWith(
                          fontSize: 10,
                          color: DalmColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 38),
                      PhotoAnalysisSteps(activeStep: analysis.activeStep),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 60, bottom: 18),
                        child: Text(
                          '앱을 닫아도 업로드는 계속 진행돼요.',
                          style: DalmTypography.caption.copyWith(
                            fontSize: 10,
                            color: DalmColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
