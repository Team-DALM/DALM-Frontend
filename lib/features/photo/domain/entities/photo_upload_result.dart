/// 서버에 접수된 사진 정보
final class PhotoUploadResult {
  const PhotoUploadResult({
    required this.photoId,
    required this.status,
    required this.registeredAt,
  });

  final String photoId;
  final String status;
  final DateTime registeredAt;
}
