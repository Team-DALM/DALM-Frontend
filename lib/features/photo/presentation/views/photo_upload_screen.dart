import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/widgets/dalm_app_bar.dart';
import 'package:dalm/features/photo/presentation/widgets/photo_empty_placeholder.dart';
import 'package:dalm/features/photo/presentation/widgets/photo_permission_dialog.dart';
import 'package:dalm/features/photo/presentation/widgets/photo_source_action_card.dart';
import 'package:flutter/material.dart';

class PhotoUploadScreen extends StatelessWidget {
  const PhotoUploadScreen({
    super.key,
    this.onCameraPressed,
    this.onGalleryPressed,
    this.onAllowAllPhotos,
    this.onAllowSelectedPhotos,
    this.onDenyPhotoPermission,
  });

  final VoidCallback? onCameraPressed;
  final VoidCallback? onGalleryPressed;
  final VoidCallback? onAllowAllPhotos;
  final VoidCallback? onAllowSelectedPhotos;
  final VoidCallback? onDenyPhotoPermission;

  Future<void> _openGallery(BuildContext context) async {
    if (onGalleryPressed != null) {
      onGalleryPressed!();
      return;
    }

    // 앨범 접근 전 사용자에게 권한 사용 목적 안내
    await PhotoPermissionDialog.show(
      context,
      onAllowAll: onAllowAllPhotos ?? () {},
      onAllowSelected: onAllowSelectedPhotos ?? () {},
      onDeny: onDenyPhotoPermission ?? () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DalmAppBar(
        title: '오늘의 사진',
        showBackButton: true,
        leadingWidth: 44,
        dividerIndent: 20,
        dividerColor: DalmColors.warmBorder,
        titleStyle: TextStyle(
          fontFamily: DalmTypography.inter,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: DalmColors.textInk,
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 125),
                      const Align(
                        alignment: Alignment(0.04, 0),
                        child: PhotoEmptyPlaceholder(),
                      ),
                      const SizedBox(height: 47),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            PhotoSourceActionCard(
                              icon: Icons.photo_camera_outlined,
                              iconBackgroundColor: DalmColors.primaryAction,
                              title: '카메라로 촬영하기',
                              description: '지금 마주한 장면을 바로 남겨요.',
                              onPressed: onCameraPressed ?? () {},
                            ),
                            const SizedBox(height: 12),
                            PhotoSourceActionCard(
                              icon: Icons.photo_outlined,
                              iconBackgroundColor: DalmColors.secondaryAction,
                              title: '앨범에서 선택하기',
                              description: '최근 사진에서 한 장을 골라요.',
                              onPressed: () => _openGallery(context),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '사진은 공개 피드에 게시되지 않아요.',
                        style: DalmTypography.caption.copyWith(
                          fontSize: 9,
                          height: 1.2,
                          color: DalmColors.textWarm,
                        ),
                      ),
                      const SizedBox(height: 90),
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
