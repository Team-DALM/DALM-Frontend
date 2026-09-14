import '../entities/photo_library_permission_status.dart';

abstract interface class PhotoLibraryRepository {
  Future<PhotoLibraryPermissionStatus> checkPermission();

  Future<PhotoLibraryPermissionStatus> requestPermission();

  Future<String?> selectPhoto();

  Future<bool> openSettings();
}
