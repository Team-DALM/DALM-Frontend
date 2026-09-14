import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/photo_library_permission_status.dart';
import '../../domain/repositories/photo_library_repository.dart';
import '../datasources/photo_library_data_source.dart';

final class PhotoLibraryRepositoryImpl implements PhotoLibraryRepository {
  const PhotoLibraryRepositoryImpl(this._dataSource);

  final PhotoLibraryDataSource _dataSource;

  @override
  Future<PhotoLibraryPermissionStatus> checkPermission() async {
    return _mapPermissionStatus(await _dataSource.checkPermission());
  }

  @override
  Future<PhotoLibraryPermissionStatus> requestPermission() async {
    return _mapPermissionStatus(await _dataSource.requestPermission());
  }

  PhotoLibraryPermissionStatus _mapPermissionStatus(PermissionStatus status) {
    if (status.isGranted) return PhotoLibraryPermissionStatus.granted;
    if (status.isLimited) return PhotoLibraryPermissionStatus.limited;
    if (status.isPermanentlyDenied) {
      return PhotoLibraryPermissionStatus.permanentlyDenied;
    }
    if (status.isRestricted) return PhotoLibraryPermissionStatus.restricted;
    return PhotoLibraryPermissionStatus.denied;
  }

  @override
  Future<String?> selectPhoto() async {
    return (await _dataSource.selectPhoto())?.path;
  }

  @override
  Future<bool> openSettings() => _dataSource.openSettings();
}
