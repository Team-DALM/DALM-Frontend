import 'dart:io';

import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/widgets/dalm_app_bar.dart';
import 'package:dalm/core/widgets/dalm_button.dart';
import 'package:dalm/core/widgets/dalm_photo_frame.dart';
import 'package:dalm/features/photo/data/services/photo_temporary_file_manager.dart';
import 'package:dalm/features/photo/presentation/widgets/analysis/photo_search_progress_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PhotoRecordScreen extends StatefulWidget {
  const PhotoRecordScreen({
    super.key,
    required this.imagePath,
    required this.photoId,
    this.deleteImageOnDispose = true,
  });

  final String imagePath;
  final String photoId;
  final bool deleteImageOnDispose;

  @override
  State<PhotoRecordScreen> createState() => _PhotoRecordScreenState();
}

class _PhotoRecordScreenState extends State<PhotoRecordScreen> {
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
        title: '오늘의 기록',
        showBackButton: true,
        leadingWidth: 44,
        dividerIndent: 20,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            children: [
              Image.asset(
                'assets/icons/photo_analysis_success.png',
                width: 42,
                height: 42,
              ),
              const SizedBox(height: 18),
              Text(
                '오늘의 장면을 남겼어요.',
                style: DalmTypography.serifHeadline.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 6),
              Text(
                '이제 닮은 시선이 도착할 때까지 천천히 기다려요.',
                style: DalmTypography.caption.copyWith(
                  fontSize: 10,
                  color: DalmColors.textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                key: const Key('photoRecordImage'),
                width: 200,
                child: DalmPhotoFrame(
                  image: FileImage(File(widget.imagePath)),
                  borderRadius: BorderRadius.circular(6),
                  semanticLabel: '오늘 기록으로 남긴 장면',
                ),
              ),
              const SizedBox(height: 38),
              const PhotoSearchProgressCard(),
              const SizedBox(height: 44),
              DalmButton(
                label: '오늘 화면으로 돌아가기',
                onPressed: () => context.go(AppRoutes.home),
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: () => context.go(AppRoutes.moments),
                child: Text(
                  '내 순간 자세히 보기',
                  style: DalmTypography.caption.copyWith(
                    fontSize: 11,
                    color: DalmColors.secondaryAction,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
