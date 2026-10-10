import 'dart:io';

import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/widgets/dalm_app_bar.dart';
import 'package:dalm/features/photo/data/providers/photo_analysis_providers.dart';
import 'package:dalm/features/photo/domain/entities/photo_analysis_progress.dart';
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
                      SizedBox(
                        key: const Key('photoAnalysisImage'),
                        width: imageWidth,
                        child: AspectRatio(
                          aspectRatio: 4 / 5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(
                                  File(widget.imagePath),
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
                                const ColoredBox(color: Color(0x26000000)),
                                Center(
                                  child: _AnalysisProgressBadge(
                                    progress: analysis.progress,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                      _AnalysisSteps(activeStep: analysis.activeStep),
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

class _AnalysisProgressBadge extends StatelessWidget {
  const _AnalysisProgressBadge({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final normalizedProgress = progress.clamp(0.0, 1.0);

    return Container(
      key: const Key('photoAnalysisProgressBadge'),
      width: 84,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: DalmColors.primaryAction.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox.square(
            dimension: 19,
            child: CircularProgressIndicator(
              value: normalizedProgress,
              strokeWidth: 2,
              backgroundColor: DalmColors.textInverse.withValues(alpha: 0.25),
              color: DalmColors.emotionalAccent,
            ),
          ),
          const SizedBox(width: 9),
          Text(
            '${(normalizedProgress * 100).round()}%',
            style: DalmTypography.caption.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: DalmColors.textInverse,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalysisSteps extends StatelessWidget {
  const _AnalysisSteps({required this.activeStep});

  final int activeStep;

  static const _labels = ['장면 이해', '빛과 색', '구도', '안전 확인'];

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('photoAnalysisSteps'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: List.generate(_labels.length * 2 - 1, (index) {
              if (index.isOdd) {
                final lineIndex = index ~/ 2;
                return Expanded(
                  child: Container(
                    height: 1,
                    color: lineIndex < activeStep
                        ? DalmColors.emotionalAccent
                        : DalmColors.border,
                  ),
                );
              }

              final step = index ~/ 2;
              final color = step < activeStep
                  ? DalmColors.secondaryAction
                  : step == activeStep
                  ? DalmColors.emotionalAccent
                  : DalmColors.border;

              return Container(
                width: step == 1 ? 10 : 8,
                height: step == 1 ? 10 : 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              );
            }),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _labels
              .map(
                (label) => SizedBox(
                  width: 58,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: DalmTypography.caption.copyWith(
                      fontSize: 9,
                      color: DalmColors.textSecondary,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
