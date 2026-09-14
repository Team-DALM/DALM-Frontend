import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

abstract interface class PhotoCameraDataSource {
  Future<PermissionStatus> checkPermission();

  Future<PermissionStatus> requestPermission();

  Future<XFile?> takePhoto();

  Future<bool> openSettings();
}

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
