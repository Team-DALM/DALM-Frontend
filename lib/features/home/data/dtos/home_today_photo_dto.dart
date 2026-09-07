import 'package:json_annotation/json_annotation.dart';

part 'home_today_photo_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
final class HomeTodayPhotoDto {
  const HomeTodayPhotoDto({
    required this.id,
    required this.imageUrl,
    required this.status,
    required this.registeredAt,
    this.aiTitle,
    this.searchExpiresAt,
    this.remainingDays,
    this.matchId,
    this.partnerImageUrl,
    this.matchedAt,
    this.rejectionCode,
    this.rejectionMessage,
  });

  // 사진 기본 정보
  final String id;
  final String imageUrl;
  final String status;
  final DateTime registeredAt;

  // AI 검사 완료 후 생성되는 정보
  final String? aiTitle;

  // 탐색 중일 때 사용하는 정보
  final DateTime? searchExpiresAt;
  final int? remainingDays;

  // 매칭 완료일 때 사용하는 정보
  final String? matchId;
  final String? partnerImageUrl;
  final DateTime? matchedAt;

  // 사진 거절일 때 사용하는 정보
  final String? rejectionCode;
  final String? rejectionMessage;

  factory HomeTodayPhotoDto.fromJson(Map<String, dynamic> json) {
    return _$HomeTodayPhotoDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$HomeTodayPhotoDtoToJson(this);
  }
}
