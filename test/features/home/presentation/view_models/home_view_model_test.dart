import 'package:dalm/features/home/data/providers/home_data_providers.dart';
import 'package:dalm/features/home/domain/entities/home_overview.dart';
import 'package:dalm/features/home/domain/repositories/home_repository.dart';
import 'package:dalm/features/home/presentation/view_models/home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeViewModel', () {
    test('최초 조회에 성공하면 HomeOverview를 상태로 저장한다', () async {
      final expected = _createHomeOverview(canRegister: true);
      final repository = _FakeHomeRepository(result: expected);
      final container = _createContainer(repository);
      addTearDown(container.dispose);

      final result = await container.read(homeViewModelProvider.future);

      expect(result, same(expected));
      expect(repository.callCount, 1);
      expect(
        container.read(homeViewModelProvider).requireValue,
        same(expected),
      );
    });

    test('최초 조회에 실패하면 AsyncError 상태가 된다', () async {
      final failure = StateError('홈 조회 실패');
      final repository = _FakeHomeRepository(error: failure);
      final container = _createContainer(repository);
      addTearDown(container.dispose);

      await expectLater(
        container.read(homeViewModelProvider.future),
        throwsA(same(failure)),
      );

      final state = container.read(homeViewModelProvider);

      expect(state.hasError, isTrue);
      expect(state.error, same(failure));
      expect(repository.callCount, 1);
    });

    test('refresh를 호출하면 홈 데이터를 다시 조회해 상태를 갱신한다', () async {
      final initial = _createHomeOverview(canRegister: true);
      final refreshed = _createHomeOverview(canRegister: false);
      final repository = _FakeHomeRepository(result: initial);
      final container = _createContainer(repository);
      addTearDown(container.dispose);

      await container.read(homeViewModelProvider.future);
      repository.result = refreshed;

      await container.read(homeViewModelProvider.notifier).refresh();

      expect(repository.callCount, 2);
      expect(
        container.read(homeViewModelProvider).requireValue,
        same(refreshed),
      );
    });
  });
}

ProviderContainer _createContainer(HomeRepository repository) {
  return ProviderContainer(
    overrides: [homeRepositoryProvider.overrideWithValue(repository)],
  );
}

HomeOverview _createHomeOverview({required bool canRegister}) {
  return HomeOverview(
    canRegister: canRegister,
    todayPhoto: null,
    searchingMoments: const [],
    recentMatch: null,
    unviewedMatchCount: 0,
  );
}

final class _FakeHomeRepository implements HomeRepository {
  _FakeHomeRepository({this.result, this.error});

  HomeOverview? result;
  Object? error;
  int callCount = 0;

  @override
  Future<HomeOverview> getHomeOverview() async {
    callCount++;

    final currentError = error;

    if (currentError != null) {
      throw currentError;
    }

    return result!;
  }
}
