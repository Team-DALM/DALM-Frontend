import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/photo_upload_providers.dart';
import '../../domain/entities/photo_upload_result.dart';
import '../../domain/repositories/photo_upload_repository.dart';

final photoUploadViewModelProvider = Provider.autoDispose<PhotoUploadViewModel>(
  (ref) => PhotoUploadViewModel(ref.watch(photoUploadRepositoryProvider)),
);

/// 크롭 사진 업로드 흐름 제어
final class PhotoUploadViewModel {
  const PhotoUploadViewModel(this._repository);

  final PhotoUploadRepository _repository;

  Future<PhotoUploadResult> uploadPhoto(String imagePath) {
    return _repository.uploadPhoto(imagePath);
  }
}
