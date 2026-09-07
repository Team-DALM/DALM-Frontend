import 'package:dalm/features/home/data/dtos/home_recent_match_data_dto.dart';
import 'package:dalm/features/home/data/dtos/home_recent_match_dto.dart';
import 'package:dalm/features/home/data/dtos/home_searching_moment_dto.dart';
import 'package:dalm/features/home/data/dtos/home_searching_moment_list_dto.dart';
import 'package:dalm/features/home/data/dtos/home_today_data_dto.dart';
import 'package:dalm/features/home/data/dtos/home_today_photo_dto.dart';
import 'package:dalm/features/home/data/mappers/home_mapper.dart';
import 'package:dalm/features/home/domain/entities/home_today_photo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeMapper', () {
    group('toTodayPhotoEntity', () {
      test('DTO가 null이면 null을 반환한다', () {
        final result = HomeMapper.toTodayPhotoEntity(null);

        expect(result, isNull);
      });

      test('SEARCHING DTO를 탐색 중 오늘 사진 Entity로 변환한다', () {
        final dto = _createTodayPhotoDto(status: 'searching');

        final result = HomeMapper.toTodayPhotoEntity(dto);

        expect(result, isNotNull);
        expect(result!.id, dto.id);
        expect(result.imageUrl, dto.imageUrl);
        expect(result.status, HomeTodayPhotoStatus.searching);
        expect(result.registeredAt, dto.registeredAt);
        expect(result.aiTitle, dto.aiTitle);
        expect(result.searchExpiresAt, dto.searchExpiresAt);
        expect(result.remainingDays, dto.remainingDays);
        expect(result.match, isNull);
      });

      test('MATCHED DTO에 포함된 매칭 정보를 HomeTodayMatch로 변환한다', () {
        final matchedAt = DateTime.utc(2026, 9, 5, 10, 5);
        final dto = _createTodayPhotoDto(
          status: 'MATCHED',
          matchId: 'match-1',
          partnerImageUrl: 'https://example.com/partner.jpg',
          matchedAt: matchedAt,
        );

        final result = HomeMapper.toTodayPhotoEntity(dto);

        expect(result, isNotNull);
        expect(result!.status, HomeTodayPhotoStatus.matched);
        expect(result.match, isNotNull);
        expect(result.match!.matchId, 'match-1');
        expect(
          result.match!.partnerImageUrl,
          'https://example.com/partner.jpg',
        );
        expect(result.match!.matchedAt, matchedAt);
      });

      test('MATCHED DTO에 필수 매칭 정보가 없으면 FormatException을 던진다', () {
        final dto = _createTodayPhotoDto(status: 'MATCHED');

        expect(
          () => HomeMapper.toTodayPhotoEntity(dto),
          throwsA(isA<FormatException>()),
        );
      });

      test('지원하지 않는 사진 상태이면 FormatException을 던진다', () {
        final dto = _createTodayPhotoDto(status: 'UNKNOWN');

        expect(
          () => HomeMapper.toTodayPhotoEntity(dto),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('toSearchingMomentEntity', () {
      test('SEARCHING DTO를 과거 탐색 사진 Entity로 변환한다', () {
        final dto = _createSearchingMomentDto(status: 'searching');

        final result = HomeMapper.toSearchingMomentEntity(dto);

        expect(result.id, dto.photoId);
        expect(result.imageUrl, dto.imageUrl);
        expect(result.aiTitle, dto.aiTitle);
        expect(result.registeredAt, dto.registeredAt);
        expect(result.searchExpiresAt, dto.searchExpiresAt);
        expect(result.remainingDays, dto.remainingDays);
      });

      test('SEARCHING이 아닌 DTO이면 FormatException을 던진다', () {
        final dto = _createSearchingMomentDto(status: 'MATCHED');

        expect(
          () => HomeMapper.toSearchingMomentEntity(dto),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('toRecentMatchEntity', () {
      test('DTO가 null이면 null을 반환한다', () {
        final result = HomeMapper.toRecentMatchEntity(null);

        expect(result, isNull);
      });

      test('미확인 매칭 DTO를 Entity로 변환한다', () {
        final dto = _createRecentMatchDto();

        final result = HomeMapper.toRecentMatchEntity(dto);

        expect(result, isNotNull);
        expect(result!.matchId, dto.matchId);
        expect(result.myPhotoId, dto.myPhotoId);
        expect(result.myImageUrl, dto.myImageUrl);
        expect(result.partnerImageUrl, dto.partnerImageUrl);
        expect(result.aiTitle, dto.aiTitle);
        expect(result.matchedAt, dto.matchedAt);
      });
    });

    group('toHomeOverview', () {
      test('세 API의 Data DTO를 하나의 HomeOverview로 변환한다', () {
        final todayPhoto = _createTodayPhotoDto(status: 'SEARCHING');
        final searchingMoment = _createSearchingMomentDto();
        final recentMatch = _createRecentMatchDto();

        final result = HomeMapper.toHomeOverview(
          todayData: HomeTodayDataDto(canRegister: false, photo: todayPhoto),
          searchingData: HomeSearchingMomentListDto(items: [searchingMoment]),
          recentMatchData: HomeRecentMatchDataDto(
            match: recentMatch,
            unviewedMatchCount: 2,
          ),
        );

        expect(result.canRegister, isFalse);
        expect(result.todayPhoto?.id, todayPhoto.id);
        expect(result.searchingMoments, hasLength(1));
        expect(result.searchingMoments.single.id, searchingMoment.photoId);
        expect(result.recentMatch?.matchId, recentMatch.matchId);
        expect(result.unviewedMatchCount, 2);
      });

      test('변환된 탐색 중 사진 목록은 외부에서 수정할 수 없다', () {
        final result = HomeMapper.toHomeOverview(
          todayData: const HomeTodayDataDto(canRegister: true, photo: null),
          searchingData: HomeSearchingMomentListDto(
            items: [_createSearchingMomentDto()],
          ),
          recentMatchData: const HomeRecentMatchDataDto(
            match: null,
            unviewedMatchCount: 0,
          ),
        );

        expect(
          () => result.searchingMoments.add(result.searchingMoments.first),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('미확인 매칭 개수가 음수이면 FormatException을 던진다', () {
        expect(
          () => HomeMapper.toHomeOverview(
            todayData: const HomeTodayDataDto(canRegister: true, photo: null),
            searchingData: const HomeSearchingMomentListDto(items: []),
            recentMatchData: const HomeRecentMatchDataDto(
              match: null,
              unviewedMatchCount: -1,
            ),
          ),
          throwsA(isA<FormatException>()),
        );
      });

      test('미확인 매칭이 없지만 매칭 데이터가 있으면 FormatException을 던진다', () {
        expect(
          () => HomeMapper.toHomeOverview(
            todayData: const HomeTodayDataDto(canRegister: true, photo: null),
            searchingData: const HomeSearchingMomentListDto(items: []),
            recentMatchData: HomeRecentMatchDataDto(
              match: _createRecentMatchDto(),
              unviewedMatchCount: 0,
            ),
          ),
          throwsA(isA<FormatException>()),
        );
      });

      test('미확인 매칭이 있지만 매칭 데이터가 없으면 FormatException을 던진다', () {
        expect(
          () => HomeMapper.toHomeOverview(
            todayData: const HomeTodayDataDto(canRegister: true, photo: null),
            searchingData: const HomeSearchingMomentListDto(items: []),
            recentMatchData: const HomeRecentMatchDataDto(
              match: null,
              unviewedMatchCount: 1,
            ),
          ),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });
}

HomeTodayPhotoDto _createTodayPhotoDto({
  required String status,
  String? matchId,
  String? partnerImageUrl,
  DateTime? matchedAt,
}) {
  return HomeTodayPhotoDto(
    id: 'today-photo-1',
    imageUrl: 'https://example.com/today.jpg',
    status: status,
    registeredAt: DateTime.utc(2026, 9, 5, 10),
    aiTitle: '비가 그친 골목',
    searchExpiresAt: DateTime.utc(2026, 9, 12, 10),
    remainingDays: 7,
    matchId: matchId,
    partnerImageUrl: partnerImageUrl,
    matchedAt: matchedAt,
  );
}

HomeSearchingMomentDto _createSearchingMomentDto({
  String status = 'SEARCHING',
}) {
  return HomeSearchingMomentDto(
    photoId: 'past-photo-1',
    imageUrl: 'https://example.com/past.jpg',
    aiTitle: '햇빛이 머문 창가',
    status: status,
    registeredAt: DateTime.utc(2026, 9, 3, 10),
    searchExpiresAt: DateTime.utc(2026, 9, 10, 10),
    remainingDays: 5,
  );
}

HomeRecentMatchDto _createRecentMatchDto() {
  return HomeRecentMatchDto(
    matchId: 'match-1',
    myPhotoId: 'past-photo-2',
    myImageUrl: 'https://example.com/my-photo.jpg',
    partnerImageUrl: 'https://example.com/partner-photo.jpg',
    aiTitle: '서로 다른 날에 머문 같은 빛',
    matchedAt: DateTime.utc(2026, 9, 5, 10, 5),
  );
}
