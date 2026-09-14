import '../entities/photo_camera_permission_status.dart';

abstract interface class PhotoCameraRepository {
  Future<PhotoCameraPermissionStatus> checkPermission();

  Future<PhotoCameraPermissionStatus> requestPermission();

  Future<String?> takePhoto();

  Future<bool> openSettings();
}
