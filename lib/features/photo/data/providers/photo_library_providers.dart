import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/photo_library_repository.dart';
import '../datasources/photo_library_data_source.dart';
import '../repositories/photo_library_repository_impl.dart';

/// 기기 Photo Picker 제공자
final photoLibraryDataSourceProvider = Provider<PhotoLibraryDataSource>((ref) {
  return DevicePhotoLibraryDataSource();
});

/// 앨범 저장소 제공자
final photoLibraryRepositoryProvider = Provider<PhotoLibraryRepository>((ref) {
  return PhotoLibraryRepositoryImpl(ref.watch(photoLibraryDataSourceProvider));
});
