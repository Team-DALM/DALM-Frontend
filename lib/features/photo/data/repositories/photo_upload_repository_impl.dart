import '../../domain/entities/photo_upload_result.dart';
import '../../domain/repositories/photo_upload_repository.dart';
import '../datasources/photo_remote_data_source.dart';

/// 사진 등록 API 응답을 도메인 결과로 변환하는 저장소
final class PhotoUploadRepositoryImpl implements PhotoUploadRepository {
  const PhotoUploadRepositoryImpl(this._remoteDataSource);

  final PhotoRemoteDataSource _remoteDataSource;

  @override
  Future<PhotoUploadResult> uploadPhoto(String imagePath) async {
    final data = await _remoteDataSource.uploadPhoto(imagePath);

    return PhotoUploadResult(
      photoId: data.photoId,
      status: data.status,
      registeredAt: data.registeredAt,
    );
  }
}
