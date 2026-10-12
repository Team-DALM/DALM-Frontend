import 'photo_upload_status.dart';

/// 서버에 접수된 사진 정보
final class PhotoUploadResult {
  const PhotoUploadResult({
    required this.photoId,
    required this.status,
    required this.registeredAt,
  });

  final String photoId;
  final PhotoUploadStatus status;
  final DateTime registeredAt;
}
