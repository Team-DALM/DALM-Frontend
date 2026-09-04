import 'package:json_annotation/json_annotation.dart';

import 'home_searching_moment_dto.dart';

part 'home_searching_moment_list_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
final class HomeSearchingMomentListDto {
  const HomeSearchingMomentListDto({required this.items});

  // 오늘을 제외한 탐색 중인 과거 사진 목록
  final List<HomeSearchingMomentDto> items;

  factory HomeSearchingMomentListDto.fromJson(Map<String, dynamic> json) {
    return _$HomeSearchingMomentListDtoFromJson(json);
  }
}
