// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_today_photo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeTodayPhotoDto _$HomeTodayPhotoDtoFromJson(Map<String, dynamic> json) =>
    HomeTodayPhotoDto(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      status: json['status'] as String,
      registeredAt: DateTime.parse(json['registered_at'] as String),
      aiTitle: json['ai_title'] as String?,
      searchExpiresAt: json['search_expires_at'] == null
          ? null
          : DateTime.parse(json['search_expires_at'] as String),
      remainingDays: (json['remaining_days'] as num?)?.toInt(),
      matchId: json['match_id'] as String?,
      partnerImageUrl: json['partner_image_url'] as String?,
      matchedAt: json['matched_at'] == null
          ? null
          : DateTime.parse(json['matched_at'] as String),
      rejectionCode: json['rejection_code'] as String?,
      rejectionMessage: json['rejection_message'] as String?,
    );

Map<String, dynamic> _$HomeTodayPhotoDtoToJson(HomeTodayPhotoDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image_url': instance.imageUrl,
      'status': instance.status,
      'registered_at': instance.registeredAt.toIso8601String(),
      'ai_title': instance.aiTitle,
      'search_expires_at': instance.searchExpiresAt?.toIso8601String(),
      'remaining_days': instance.remainingDays,
      'match_id': instance.matchId,
      'partner_image_url': instance.partnerImageUrl,
      'matched_at': instance.matchedAt?.toIso8601String(),
      'rejection_code': instance.rejectionCode,
      'rejection_message': instance.rejectionMessage,
    };
