import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// 기기의 카메라 권한과 촬영 기능 접근 규격
abstract interface class PhotoCameraDataSource {
  Future<PermissionStatus> checkPermission();

  Future<PermissionStatus> requestPermission();

  Future<XFile?> takePhoto();

  Future<bool> openSettings();
}

/// 시스템 권한 창과 기본 카메라 앱을 사용하는 데이터 소스
final class DevicePhotoCameraDataSource implements PhotoCameraDataSource {
  DevicePhotoCameraDataSource({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  @override
  Future<PermissionStatus> checkPermission() {
    return Permission.camera.status;
  }

  @override
  Future<PermissionStatus> requestPermission() {
    return Permission.camera.request();
  }

  @override
  Future<XFile?> takePhoto() {
    return _imagePicker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 90,
    );
  }

  @override
  Future<bool> openSettings() {
    return openAppSettings();
  }
}
