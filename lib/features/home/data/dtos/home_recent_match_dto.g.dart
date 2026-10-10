// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_recent_match_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeRecentMatchDto _$HomeRecentMatchDtoFromJson(Map<String, dynamic> json) =>
    HomeRecentMatchDto(
      matchId: json['match_id'] as String,
      myPhotoId: json['my_photo_id'] as String,
      myImageUrl: json['my_image_url'] as String,
      partnerImageUrl: json['partner_image_url'] as String,
      aiTitle: json['ai_title'] as String,
      matchedAt: DateTime.parse(json['matched_at'] as String),
    );
