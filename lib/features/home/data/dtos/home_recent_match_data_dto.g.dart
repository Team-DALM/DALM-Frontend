// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_recent_match_data_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeRecentMatchDataDto _$HomeRecentMatchDataDtoFromJson(
  Map<String, dynamic> json,
) => HomeRecentMatchDataDto(
  match: json['match'] == null
      ? null
      : HomeRecentMatchDto.fromJson(json['match'] as Map<String, dynamic>),
  unviewedMatchCount: (json['unviewed_match_count'] as num).toInt(),
);
