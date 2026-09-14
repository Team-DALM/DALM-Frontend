import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/photo_library_repository.dart';
import '../datasources/photo_library_data_source.dart';
import '../repositories/photo_library_repository_impl.dart';

final photoLibraryDataSourceProvider = Provider<PhotoLibraryDataSource>((ref) {
  return DevicePhotoLibraryDataSource();
});

final photoLibraryRepositoryProvider = Provider<PhotoLibraryRepository>((ref) {
  return PhotoLibraryRepositoryImpl(ref.watch(photoLibraryDataSourceProvider));
});
