import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

abstract interface class PhotoLibraryDataSource {
  Future<PermissionStatus> checkPermission();

  Future<PermissionStatus> requestPermission();

  Future<XFile?> selectPhoto();

  Future<bool> openSettings();
}

final class DevicePhotoLibraryDataSource implements PhotoLibraryDataSource {
  DevicePhotoLibraryDataSource({
    ImagePicker? imagePicker,
    DeviceInfoPlugin? deviceInfo,
  }) : _imagePicker = imagePicker ?? ImagePicker(),
       _deviceInfo = deviceInfo ?? DeviceInfoPlugin();

  final ImagePicker _imagePicker;
  final DeviceInfoPlugin _deviceInfo;

  Future<Permission> _photoPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        return Permission.storage;
      }
    }

    return Permission.photos;
  }

  @override
  Future<PermissionStatus> checkPermission() async {
    return (await _photoPermission()).status;
  }

  @override
  Future<PermissionStatus> requestPermission() async {
    return (await _photoPermission()).request();
  }

  @override
  Future<XFile?> selectPhoto() {
    return _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
      requestFullMetadata: false,
    );
  }

  @override
  Future<bool> openSettings() {
    return openAppSettings();
  }
}
