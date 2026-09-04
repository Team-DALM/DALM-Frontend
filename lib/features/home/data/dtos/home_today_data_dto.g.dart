// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_today_data_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeTodayDataDto _$HomeTodayDataDtoFromJson(Map<String, dynamic> json) =>
    HomeTodayDataDto(
      canRegister: json['can_register'] as bool,
      photo: json['photo'] == null
          ? null
          : HomeTodayPhotoDto.fromJson(json['photo'] as Map<String, dynamic>),
    );
