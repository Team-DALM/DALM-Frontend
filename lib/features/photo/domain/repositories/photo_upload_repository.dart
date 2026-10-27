import '../entities/photo_upload_result.dart';

/// 크롭 사진 업로드 규격
abstract interface class PhotoUploadRepository {
  Future<PhotoUploadResult> uploadPhoto(String imagePath);
}
