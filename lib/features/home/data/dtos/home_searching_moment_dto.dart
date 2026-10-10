import 'package:json_annotation/json_annotation.dart';

part 'home_searching_moment_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
final class HomeSearchingMomentDto {
  const HomeSearchingMomentDto({
    required this.photoId,
    required this.imageUrl,
    required this.aiTitle,
    required this.status,
    required this.registeredAt,
    required this.searchExpiresAt,
    required this.remainingDays,
  });

  // 사진 기본 정보
  final String photoId;
  final String imageUrl;
  final String aiTitle;
  final String status;
  final DateTime registeredAt;

  // 매칭 탐색 진행 정보
  final DateTime searchExpiresAt;
  final int remainingDays;

  factory HomeSearchingMomentDto.fromJson(Map<String, dynamic> json) {
    return _$HomeSearchingMomentDtoFromJson(json);
  }
}
