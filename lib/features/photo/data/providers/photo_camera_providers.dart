import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/photo_camera_repository.dart';
import '../datasources/photo_camera_data_source.dart';
import '../repositories/photo_camera_repository_impl.dart';

/// 기기 카메라 기능 제공자
final photoCameraDataSourceProvider = Provider<PhotoCameraDataSource>((ref) {
  return DevicePhotoCameraDataSource();
});

/// 카메라 저장소 제공자
final photoCameraRepositoryProvider = Provider<PhotoCameraRepository>((ref) {
  return PhotoCameraRepositoryImpl(ref.watch(photoCameraDataSourceProvider));
});
