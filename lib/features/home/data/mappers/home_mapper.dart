import '../../domain/entities/home_today_photo.dart';
import '../dtos/home_today_photo_dto.dart';

import '../../domain/entities/home_searching_moment.dart';
import '../dtos/home_searching_moment_dto.dart';

import '../../domain/entities/home_recent_match.dart';
import '../dtos/home_recent_match_dto.dart';

import '../../domain/entities/home_overview.dart';
import '../dtos/home_recent_match_data_dto.dart';
import '../dtos/home_searching_moment_list_dto.dart';
import '../dtos/home_today_data_dto.dart';

final class HomeMapper {
  const HomeMapper._();

  static HomeTodayPhoto? toTodayPhotoEntity(HomeTodayPhotoDto? dto) {
    if (dto == null) {
      return null;
    }

    final status = _toTodayPhotoStatus(dto.status);

    return HomeTodayPhoto(
      id: dto.id,
      imageUrl: dto.imageUrl,
      status: status,
      registeredAt: dto.registeredAt,
      aiTitle: dto.aiTitle,
      searchExpiresAt: dto.searchExpiresAt,
      remainingDays: dto.remainingDays,
      match: _toTodayMatch(dto, status),
      rejectionCode: dto.rejectionCode,
      rejectionMessage: dto.rejectionMessage,
    );
  }

  static HomeTodayPhotoStatus _toTodayPhotoStatus(String status) {
    return switch (status.toUpperCase()) {
      'VALIDATING' => HomeTodayPhotoStatus.validating,
      'REJECTED' => HomeTodayPhotoStatus.rejected,
      'SEARCHING' => HomeTodayPhotoStatus.searching,
      'MATCHED' => HomeTodayPhotoStatus.matched,
      _ => throw FormatException('지원하지 않는 오늘 사진 상태입니다: $status'),
    };
  }

  static HomeTodayMatch? _toTodayMatch(
    HomeTodayPhotoDto dto,
    HomeTodayPhotoStatus status,
  ) {
    if (status != HomeTodayPhotoStatus.matched) {
      return null;
    }

    final matchId = dto.matchId;
    final partnerImageUrl = dto.partnerImageUrl;
    final matchedAt = dto.matchedAt;

    if (matchId == null || partnerImageUrl == null || matchedAt == null) {
      throw const FormatException('매칭 완료 사진의 매칭 정보가 부족합니다.');
    }

    return HomeTodayMatch(
      matchId: matchId,
      partnerImageUrl: partnerImageUrl,
      matchedAt: matchedAt,
    );
  }

  static HomeSearchingMoment toSearchingMomentEntity(
    HomeSearchingMomentDto dto,
  ) {
    if (dto.status.toUpperCase() != 'SEARCHING') {
      throw FormatException('탐색 중 사진이 아닌 상태입니다: ${dto.status}');
    }

    return HomeSearchingMoment(
      id: dto.photoId,
      imageUrl: dto.imageUrl,
      aiTitle: dto.aiTitle,
      registeredAt: dto.registeredAt,
      searchExpiresAt: dto.searchExpiresAt,
      remainingDays: dto.remainingDays,
    );
  }

  static HomeRecentMatch? toRecentMatchEntity(HomeRecentMatchDto? dto) {
    if (dto == null) {
      return null;
    }

    return HomeRecentMatch(
      matchId: dto.matchId,
      myPhotoId: dto.myPhotoId,
      myImageUrl: dto.myImageUrl,
      partnerImageUrl: dto.partnerImageUrl,
      aiTitle: dto.aiTitle,
      matchedAt: dto.matchedAt,
    );
  }

  static HomeOverview toHomeOverview({
    required HomeTodayDataDto todayData,
    required HomeSearchingMomentListDto searchingData,
    required HomeRecentMatchDataDto recentMatchData,
  }) {
    final recentMatch = toRecentMatchEntity(recentMatchData.match);

    _validateRecentMatchData(
      recentMatch: recentMatch,
      unviewedMatchCount: recentMatchData.unviewedMatchCount,
    );

    return HomeOverview(
      canRegister: todayData.canRegister,
      todayPhoto: toTodayPhotoEntity(todayData.photo),
      searchingMoments: List.unmodifiable(
        searchingData.items.map(toSearchingMomentEntity),
      ),
      recentMatch: recentMatch,
      unviewedMatchCount: recentMatchData.unviewedMatchCount,
    );
  }

  static void _validateRecentMatchData({
    required HomeRecentMatch? recentMatch,
    required int unviewedMatchCount,
  }) {
    if (unviewedMatchCount < 0) {
      throw const FormatException('미확인 매칭 개수는 음수가 될 수 없습니다.');
    }

    if (unviewedMatchCount == 0 && recentMatch != null) {
      throw const FormatException('미확인 매칭이 없지만 매칭 데이터가 존재합니다.');
    }

    if (unviewedMatchCount > 0 && recentMatch == null) {
      throw const FormatException('미확인 매칭이 있지만 표시할 매칭 데이터가 없습니다.');
    }
  }
}
