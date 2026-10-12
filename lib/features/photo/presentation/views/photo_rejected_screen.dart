import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/widgets/dalm_app_bar.dart';
import 'package:dalm/core/widgets/dalm_button.dart';
import 'package:dalm/features/photo/data/services/photo_temporary_file_manager.dart';
import 'package:dalm/features/photo/presentation/widgets/analysis/photo_rejected_image.dart';
import 'package:dalm/features/photo/presentation/widgets/analysis/photo_rejection_reasons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PhotoRejectedScreen extends StatefulWidget {
  const PhotoRejectedScreen({
    super.key,
    required this.imagePath,
    required this.photoId,
    this.deleteImageOnDispose = true,
  });

  final String imagePath;
  final String photoId;
  final bool deleteImageOnDispose;

  @override
  State<PhotoRejectedScreen> createState() => _PhotoRejectedScreenState();
}

class _PhotoRejectedScreenState extends State<PhotoRejectedScreen> {
  @override
  void dispose() {
    if (widget.deleteImageOnDispose) _deleteTemporaryImage();
    super.dispose();
  }

  Future<void> _deleteTemporaryImage() async {
    await PhotoTemporaryFileManager.deleteOwnedFile(widget.imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DalmColors.background,
      appBar: const DalmAppBar(
        title: '사진을 다시 골라주세요',
        showBackButton: true,
        leadingWidth: 44,
        dividerIndent: 20,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 24),
          child: Column(
            children: [
              PhotoRejectedImage(imagePath: widget.imagePath),
              const SizedBox(height: 34),
              Text(
                '장면을 충분히 읽지 못했어요.',
                textAlign: TextAlign.center,
                style: DalmTypography.serifHeadline.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 10),
              Text(
                '빛과 피사체가 너무 흐려 평행한 순간을 찾기 어려워요.\n조금 더 선명한 오늘의 장면을 골라주세요.',
                textAlign: TextAlign.center,
                style: DalmTypography.caption.copyWith(
                  fontSize: 10,
                  color: DalmColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              const PhotoRejectionReasons(),
              const SizedBox(height: 30),
              DalmButton(
                label: '다른 사진 선택하기',
                onPressed: () => context.go(AppRoutes.photoUpload),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go(AppRoutes.home),
                child: Text(
                  '오늘은 나중에 남기기',
                  style: DalmTypography.caption.copyWith(
                    fontSize: 11,
                    color: DalmColors.secondaryAction,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: DalmColors.emotionalAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      '거절된 사진과 AI 분석 정보는 서버에 저장되지 않아요.',
                      style: DalmTypography.caption.copyWith(
                        fontSize: 11,
                        color: DalmColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
