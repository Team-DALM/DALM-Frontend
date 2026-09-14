import 'dart:async';

import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/widgets/dalm_app_bar.dart';
import 'package:dalm/features/photo/domain/entities/photo_camera_permission_status.dart';
import 'package:dalm/features/photo/presentation/view_models/photo_camera_view_model.dart';
import 'package:dalm/features/photo/presentation/widgets/camera_permission_dialog.dart';
import 'package:dalm/features/photo/presentation/widgets/camera_settings_dialog.dart';
import 'package:dalm/features/photo/presentation/widgets/photo_empty_placeholder.dart';
import 'package:dalm/features/photo/presentation/widgets/photo_permission_dialog.dart';
import 'package:dalm/features/photo/presentation/widgets/photo_source_action_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhotoUploadScreen extends ConsumerWidget {
  const PhotoUploadScreen({
    super.key,
    this.onCameraPressed,
    this.onGalleryPressed,
    this.onAllowAllPhotos,
    this.onAllowSelectedPhotos,
    this.onDenyPhotoPermission,
    this.onAllowCamera,
    this.onDenyCameraPermission,
    this.onPhotoCaptured,
  });

  final VoidCallback? onCameraPressed;
  final VoidCallback? onGalleryPressed;
  final VoidCallback? onAllowAllPhotos;
  final VoidCallback? onAllowSelectedPhotos;
  final VoidCallback? onDenyPhotoPermission;
  final VoidCallback? onAllowCamera;
  final VoidCallback? onDenyCameraPermission;
  final ValueChanged<String>? onPhotoCaptured;

  Future<void> _openCamera(BuildContext context, WidgetRef ref) async {
    if (onCameraPressed != null) {
      onCameraPressed!();
      return;
    }

    final viewModel = ref.read(photoCameraViewModelProvider);
    late final PhotoCameraPermissionStatus permission;

    try {
      permission = await viewModel.checkPermission();
    } catch (_) {
      if (context.mounted) {
        _showMessage(context, '카메라 권한을 확인하지 못했어요. 잠시 후 다시 시도해 주세요.');
      }
      return;
    }

    if (!context.mounted) {
      return;
    }

    switch (permission) {
      case PhotoCameraPermissionStatus.granted:
        final result = await viewModel.takePhoto();
        if (context.mounted) {
          await _handleCameraResult(context, viewModel, result);
        }
        return;
      case PhotoCameraPermissionStatus.permanentlyDenied:
        await _showCameraSettingsDialog(context, viewModel);
        return;
      case PhotoCameraPermissionStatus.restricted:
        _showMessage(context, '이 기기에서는 카메라 권한을 변경할 수 없어요.');
        return;
      case PhotoCameraPermissionStatus.denied:
        break;
    }

    if (!context.mounted) {
      return;
    }

    // 카메라 실행 전 사용자에게 권한 사용 목적 안내
    await CameraPermissionDialog.show(
      context,
      onAllow:
          onAllowCamera ??
          () {
            unawaited(_requestPermissionAndTakePhoto(context, ref));
          },
      onDeny: onDenyCameraPermission ?? () {},
    );
  }

  Future<void> _requestPermissionAndTakePhoto(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final viewModel = ref.read(photoCameraViewModelProvider);
    final result = await viewModel.requestPermissionAndTakePhoto();

    if (!context.mounted) {
      return;
    }

    await _handleCameraResult(context, viewModel, result);
  }

  Future<void> _handleCameraResult(
    BuildContext context,
    PhotoCameraViewModel viewModel,
    PhotoCameraCaptureResult result,
  ) async {
    switch (result.outcome) {
      case PhotoCameraCaptureOutcome.captured:
        onPhotoCaptured?.call(result.photoPath!);
        return;
      case PhotoCameraCaptureOutcome.cancelled:
        return;
      case PhotoCameraCaptureOutcome.permissionDenied:
        _showMessage(context, '카메라 권한이 허용되지 않았어요.');
        return;
      case PhotoCameraCaptureOutcome.permissionPermanentlyDenied:
        await _showCameraSettingsDialog(context, viewModel);
        return;
      case PhotoCameraCaptureOutcome.permissionRestricted:
        _showMessage(context, '이 기기에서는 카메라 권한을 변경할 수 없어요.');
        return;
      case PhotoCameraCaptureOutcome.failed:
        _showMessage(context, '카메라를 열지 못했어요. 잠시 후 다시 시도해 주세요.');
        return;
    }
  }

  Future<void> _showCameraSettingsDialog(
    BuildContext context,
    PhotoCameraViewModel viewModel,
  ) {
    return CameraSettingsDialog.show(
      context,
      onOpenSettings: () {
        unawaited(viewModel.openSettings());
      },
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

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
  Widget build(BuildContext context, WidgetRef ref) {
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
                              onPressed: () => _openCamera(context, ref),
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
