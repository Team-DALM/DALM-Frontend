import 'package:json_annotation/json_annotation.dart';

import 'home_recent_match_dto.dart';

part 'home_recent_match_data_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
final class HomeRecentMatchDataDto {
  const HomeRecentMatchDataDto({
    required this.match,
    required this.unviewedMatchCount,
  });

  // 홈에 표시할 아직 확인하지 않은 매칭 한 건
  final HomeRecentMatchDto? match;

  // 아직 결과 화면을 확인하지 않은 매칭 전체 개수
  final int unviewedMatchCount;

  factory HomeRecentMatchDataDto.fromJson(Map<String, dynamic> json) {
    return _$HomeRecentMatchDataDtoFromJson(json);
  }
}
