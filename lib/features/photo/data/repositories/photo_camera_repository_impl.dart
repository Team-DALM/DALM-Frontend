import '../../domain/entities/photo_camera_permission_status.dart';
import '../../domain/repositories/photo_camera_repository.dart';
import '../datasources/photo_camera_data_source.dart';

import 'package:permission_handler/permission_handler.dart';

final class PhotoCameraRepositoryImpl implements PhotoCameraRepository {
  const PhotoCameraRepositoryImpl(this._dataSource);

  final PhotoCameraDataSource _dataSource;

  @override
  Future<PhotoCameraPermissionStatus> requestPermission() async {
    final status = await _dataSource.requestPermission();

    if (status.isGranted) {
      return PhotoCameraPermissionStatus.granted;
    }
    if (status.isPermanentlyDenied) {
      return PhotoCameraPermissionStatus.permanentlyDenied;
    }
    if (status.isRestricted) {
      return PhotoCameraPermissionStatus.restricted;
    }

    return PhotoCameraPermissionStatus.denied;
  }

  @override
  Future<String?> takePhoto() async {
    final photo = await _dataSource.takePhoto();

    return photo?.path;
  }

  @override
  Future<bool> openSettings() {
    return _dataSource.openSettings();
  }
}
