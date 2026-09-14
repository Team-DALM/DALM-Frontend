import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/photo_camera_repository.dart';
import '../datasources/photo_camera_data_source.dart';
import '../repositories/photo_camera_repository_impl.dart';

final photoCameraDataSourceProvider = Provider<PhotoCameraDataSource>((ref) {
  return DevicePhotoCameraDataSource();
});

final photoCameraRepositoryProvider = Provider<PhotoCameraRepository>((ref) {
  return PhotoCameraRepositoryImpl(ref.watch(photoCameraDataSourceProvider));
});
