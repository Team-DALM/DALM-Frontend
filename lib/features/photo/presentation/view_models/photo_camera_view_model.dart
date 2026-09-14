import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/photo_camera_providers.dart';
import '../../domain/entities/photo_camera_permission_status.dart';
import '../../domain/repositories/photo_camera_repository.dart';

enum PhotoCameraCaptureOutcome {
  captured,
  cancelled,
  permissionDenied,
  permissionPermanentlyDenied,
  permissionRestricted,
  failed,
}

final class PhotoCameraCaptureResult {
  const PhotoCameraCaptureResult(this.outcome, {this.photoPath});

  final PhotoCameraCaptureOutcome outcome;
  final String? photoPath;
}

final photoCameraViewModelProvider = Provider.autoDispose<PhotoCameraViewModel>(
  (ref) => PhotoCameraViewModel(ref.watch(photoCameraRepositoryProvider)),
);

final class PhotoCameraViewModel {
  const PhotoCameraViewModel(this._repository);

  final PhotoCameraRepository _repository;

  Future<PhotoCameraPermissionStatus> checkPermission() {
    return _repository.checkPermission();
  }

  Future<PhotoCameraCaptureResult> requestPermissionAndTakePhoto() async {
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
