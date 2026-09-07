// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_searching_moment_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeSearchingMomentListDto _$HomeSearchingMomentListDtoFromJson(
  Map<String, dynamic> json,
) => HomeSearchingMomentListDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => HomeSearchingMomentDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);
