import 'package:json_annotation/json_annotation.dart';

import 'home_today_photo_dto.dart';

part 'home_today_data_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
final class HomeTodayDataDto {
  const HomeTodayDataDto({required this.canRegister, required this.photo});

  // 오늘 새로운 사진을 등록할 수 있는지 여부
  final bool canRegister;

  // 오늘 사진이 없으면 null
  final HomeTodayPhotoDto? photo;

  factory HomeTodayDataDto.fromJson(Map<String, dynamic> json) {
    return _$HomeTodayDataDtoFromJson(json);
  }
}
