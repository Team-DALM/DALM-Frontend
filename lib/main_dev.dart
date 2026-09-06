import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'features/home/data/providers/home_data_providers.dart';
import 'features/home/domain/entities/home_overview.dart';
import 'features/home/domain/repositories/home_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

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

    return const HomeOverview(
      canRegister: true,
      todayPhoto: null,
      searchingMoments: [],
      recentMatch: null,
      unviewedMatchCount: 0,
    );
  }
}
