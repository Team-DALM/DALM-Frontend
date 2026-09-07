// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_searching_moment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeSearchingMomentDto _$HomeSearchingMomentDtoFromJson(
  Map<String, dynamic> json,
) => HomeSearchingMomentDto(
  photoId: json['photo_id'] as String,
  imageUrl: json['image_url'] as String,
  aiTitle: json['ai_title'] as String,
  status: json['status'] as String,
  registeredAt: DateTime.parse(json['registered_at'] as String),
  searchExpiresAt: DateTime.parse(json['search_expires_at'] as String),
  remainingDays: (json['remaining_days'] as num).toInt(),
);
