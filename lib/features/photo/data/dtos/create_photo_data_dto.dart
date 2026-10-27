/// 사진 등록 API 응답 데이터
final class CreatePhotoDataDto {
  const CreatePhotoDataDto({
    required this.photoId,
    required this.status,
    required this.registeredAt,
  });

  final String photoId;
  final String status;
  final DateTime registeredAt;

  factory CreatePhotoDataDto.fromJson(Map<String, dynamic> json) {
    return CreatePhotoDataDto(
      photoId: json['photo_id'] as String,
      status: json['status'] as String,
      registeredAt: DateTime.parse(json['registered_at'] as String),
    );
  }
}
