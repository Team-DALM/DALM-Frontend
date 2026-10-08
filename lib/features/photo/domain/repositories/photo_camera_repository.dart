import '../entities/photo_camera_permission_status.dart';

/// 카메라 권한 확인과 사진 촬영 규격
abstract interface class PhotoCameraRepository {
  Future<PhotoCameraPermissionStatus> checkPermission();

  Future<PhotoCameraPermissionStatus> requestPermission();

  Future<String?> takePhoto();

  Future<bool> openSettings();
}
