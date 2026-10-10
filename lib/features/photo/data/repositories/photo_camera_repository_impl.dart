import '../../domain/entities/photo_camera_permission_status.dart';
import '../../domain/repositories/photo_camera_repository.dart';
import '../datasources/photo_camera_data_source.dart';

import 'package:permission_handler/permission_handler.dart';

/// 기기 권한 상태를 앱의 카메라 권한 상태로 변환하는 저장소
final class PhotoCameraRepositoryImpl implements PhotoCameraRepository {
  const PhotoCameraRepositoryImpl(this._dataSource);

  final PhotoCameraDataSource _dataSource;

  @override
  Future<PhotoCameraPermissionStatus> checkPermission() async {
    return _mapPermissionStatus(await _dataSource.checkPermission());
  }

  @override
  Future<PhotoCameraPermissionStatus> requestPermission() async {
    return _mapPermissionStatus(await _dataSource.requestPermission());
  }

  PhotoCameraPermissionStatus _mapPermissionStatus(PermissionStatus status) {
    // 플랫폼별 권한 상태를 화면용 네 가지 상태로 단순화
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
