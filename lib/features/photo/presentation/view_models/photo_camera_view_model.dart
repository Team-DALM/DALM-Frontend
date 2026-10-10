import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/photo_camera_providers.dart';
import '../../domain/entities/photo_camera_permission_status.dart';
import '../../domain/repositories/photo_camera_repository.dart';

/// 카메라 촬영 요청의 최종 결과
enum PhotoCameraCaptureOutcome {
  captured,
  cancelled,
  permissionDenied,
  permissionPermanentlyDenied,
  permissionRestricted,
  failed,
}

/// 촬영 결과와 성공 시 사진 경로
final class PhotoCameraCaptureResult {
  const PhotoCameraCaptureResult(this.outcome, {this.photoPath});

  final PhotoCameraCaptureOutcome outcome;
  final String? photoPath;
}

final photoCameraViewModelProvider = Provider.autoDispose<PhotoCameraViewModel>(
  (ref) => PhotoCameraViewModel(ref.watch(photoCameraRepositoryProvider)),
);

/// 카메라 권한 요청과 촬영 흐름 제어
final class PhotoCameraViewModel {
  const PhotoCameraViewModel(this._repository);

  final PhotoCameraRepository _repository;

  Future<PhotoCameraPermissionStatus> checkPermission() {
    return _repository.checkPermission();
  }

  Future<PhotoCameraCaptureResult> requestPermissionAndTakePhoto() async {
    // 시스템 권한 결과에 따라 촬영 또는 안내 상태 반환
    try {
      final permission = await _repository.requestPermission();

      switch (permission) {
        case PhotoCameraPermissionStatus.denied:
          return const PhotoCameraCaptureResult(
            PhotoCameraCaptureOutcome.permissionDenied,
          );
        case PhotoCameraPermissionStatus.permanentlyDenied:
          return const PhotoCameraCaptureResult(
            PhotoCameraCaptureOutcome.permissionPermanentlyDenied,
          );
        case PhotoCameraPermissionStatus.restricted:
          return const PhotoCameraCaptureResult(
            PhotoCameraCaptureOutcome.permissionRestricted,
          );
        case PhotoCameraPermissionStatus.granted:
          return await _takePhoto();
      }
    } catch (_) {
      return const PhotoCameraCaptureResult(PhotoCameraCaptureOutcome.failed);
    }
  }

  Future<PhotoCameraCaptureResult> takePhoto() async {
    try {
      return await _takePhoto();
    } catch (_) {
      return const PhotoCameraCaptureResult(PhotoCameraCaptureOutcome.failed);
    }
  }

  Future<PhotoCameraCaptureResult> _takePhoto() async {
    final photoPath = await _repository.takePhoto();

    if (photoPath == null) {
      return const PhotoCameraCaptureResult(
        PhotoCameraCaptureOutcome.cancelled,
      );
    }

    return PhotoCameraCaptureResult(
      PhotoCameraCaptureOutcome.captured,
      photoPath: photoPath,
    );
  }

  Future<bool> openSettings() {
    return _repository.openSettings();
  }
}
