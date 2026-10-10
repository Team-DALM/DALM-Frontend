import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'app/app.dart';
import 'core/config/app_config.dart';
import 'features/home/data/providers/home_data_providers.dart';
import 'features/home/domain/entities/home_overview.dart';
import 'features/home/domain/entities/home_recent_match.dart';
import 'features/home/domain/entities/home_searching_moment.dart';
import 'features/home/domain/entities/home_today_photo.dart';
import 'features/home/domain/repositories/home_repository.dart';

// false: 오늘 사진 탐색 화면 / true: 최근 매칭 아래의 compact 탐색 화면
const _showRecentMatch = false;

enum _TodayPreviewState { validating, rejected, searching, matched }

const _todayPreviewState = _TodayPreviewState.rejected;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await KakaoSdk.init(nativeAppKey: AppConfig.kakaoNativeAppKey);

  runApp(
    ProviderScope(
      overrides: [
        homeRepositoryProvider.overrideWithValue(_FakeHomeRepository()),
      ],
      child: const DalmApp(),
    ),
  );
}

final class _FakeHomeRepository implements HomeRepository {
  @override
  Future<HomeOverview> getHomeOverview() async {
    // 로딩 상태도 잠깐 확인할 수 있도록 지연시킨다.
    await Future<void>.delayed(const Duration(milliseconds: 500));

    return HomeOverview(
      canRegister: _todayPreviewState == _TodayPreviewState.rejected,
      todayPhoto: _fakeTodayPhoto(),
      searchingMoments: [
        HomeSearchingMoment(
          id: 'fake-searching-moment-1',
          imageUrl: 'https://picsum.photos/id/1011/800/1000',
          aiTitle: '3일 전의 빛을\n아직 찾고 있어요.',
          registeredAt: DateTime.utc(2026, 8, 3),
          searchExpiresAt: DateTime.utc(2026, 8, 10),
          remainingDays: 4,
        ),
        HomeSearchingMoment(
          id: 'fake-searching-moment-2',
          imageUrl: 'https://picsum.photos/id/1039/800/1000',
          aiTitle: '비가 머문 골목의\n닮은 장면을 찾고 있어요.',
          registeredAt: DateTime.utc(2026, 8, 5),
          searchExpiresAt: DateTime.utc(2026, 8, 12),
          remainingDays: 6,
        ),
      ],
      recentMatch: _showRecentMatch
          ? HomeRecentMatch(
              matchId: 'fake-recent-match-1',
              myPhotoId: 'fake-my-photo-1',
              myImageUrl: 'https://picsum.photos/id/1060/800/1000',
              partnerImageUrl: 'https://picsum.photos/id/1040/800/1000',
              aiTitle: '3일 전 남긴 장면이\n오늘 누군가와 이어졌어요.',
              matchedAt: DateTime.now().subtract(const Duration(days: 3)),
            )
          : null,
      unviewedMatchCount: _showRecentMatch ? 2 : 0,
    );
  }
}

HomeTodayPhoto _fakeTodayPhoto() {
  final now = DateTime.now();

  return switch (_todayPreviewState) {
    _TodayPreviewState.validating => HomeTodayPhoto(
      id: 'fake-today-photo-1',
      imageUrl: 'https://picsum.photos/id/1060/800/1000',
      status: HomeTodayPhotoStatus.validating,
      registeredAt: now.subtract(const Duration(minutes: 1)),
    ),
    _TodayPreviewState.rejected => HomeTodayPhoto(
      id: 'fake-today-photo-1',
      imageUrl: 'https://picsum.photos/id/1060/800/1000',
      status: HomeTodayPhotoStatus.rejected,
      registeredAt: now.subtract(const Duration(minutes: 2)),
      rejectionCode: 'TOO_DARK',
      rejectionMessage: '사진이 너무 어두워 장면을 확인하기 어려워요.',
    ),
    _TodayPreviewState.searching => HomeTodayPhoto(
      id: 'fake-today-photo-1',
      imageUrl: 'https://picsum.photos/id/1060/800/1000',
      status: HomeTodayPhotoStatus.searching,
      registeredAt: now.subtract(const Duration(hours: 2)),
      aiTitle: '가장 가까운 장면부터 살펴보고 있어요.',
      searchExpiresAt: now.add(const Duration(days: 7)),
      remainingDays: 7,
    ),
    _TodayPreviewState.matched => HomeTodayPhoto(
      id: 'fake-today-photo-1',
      imageUrl: 'https://picsum.photos/id/1060/800/1000',
      status: HomeTodayPhotoStatus.matched,
      registeredAt: now.subtract(const Duration(hours: 2)),
      aiTitle: '오늘 남긴 장면과 닮은\n시선이 벌써 도착했어요.',
      match: HomeTodayMatch(
        matchId: 'fake-today-match-1',
        partnerImageUrl: 'https://picsum.photos/id/1040/800/1000',
        matchedAt: now,
      ),
    ),
  };
}
