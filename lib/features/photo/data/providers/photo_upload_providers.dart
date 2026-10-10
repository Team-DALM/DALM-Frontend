import 'package:dalm/core/network/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/photo_upload_repository.dart';
import '../datasources/photo_remote_data_source.dart';
import '../repositories/photo_upload_repository_impl.dart';

/// 사진 등록 API 데이터 소스 제공자
final photoRemoteDataSourceProvider = Provider<PhotoRemoteDataSource>((ref) {
  return DioPhotoRemoteDataSource(ref.watch(dioProvider));
});

/// 사진 업로드 저장소 제공자
final photoUploadRepositoryProvider = Provider<PhotoUploadRepository>((ref) {
  return PhotoUploadRepositoryImpl(ref.watch(photoRemoteDataSourceProvider));
});
