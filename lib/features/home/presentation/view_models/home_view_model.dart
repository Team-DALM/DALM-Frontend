import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/home_data_providers.dart';
import '../../domain/entities/home_overview.dart';

final homeViewModelProvider =
    AsyncNotifierProvider<HomeViewModel, HomeOverview>(HomeViewModel.new);

final class HomeViewModel extends AsyncNotifier<HomeOverview> {
  @override
  Future<HomeOverview> build() {
    final repository = ref.watch(homeRepositoryProvider);

    return repository.getHomeOverview();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      final repository = ref.read(homeRepositoryProvider);

      return repository.getHomeOverview();
    });
  }
}
