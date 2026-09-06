import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_models/home_view_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);

    return homeState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => _HomeErrorView(
        message: error.toString(),
        onRetry: () {
          ref.read(homeViewModelProvider.notifier).refresh();
        },
      ),
      data: (homeOverview) => RefreshIndicator(
        onRefresh: () {
          return ref.read(homeViewModelProvider.notifier).refresh();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              '홈 데이터 연결 완료',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            Text('오늘 사진 등록 가능: ${homeOverview.canRegister}'),
            const SizedBox(height: 8),
            Text(
              '오늘 사진 상태: '
              '${homeOverview.todayPhoto?.status.name ?? '사진 없음'}',
            ),
            const SizedBox(height: 8),
            Text(
              '과거 탐색 중 사진: '
              '${homeOverview.searchingMoments.length}개',
            ),
            const SizedBox(height: 8),
            Text(
              '미확인 매칭: '
              '${homeOverview.unviewedMatchCount}개',
            ),
            const SizedBox(height: 8),
            Text(
              '표시 중인 미확인 매칭: '
              '${homeOverview.recentMatch?.matchId ?? '없음'}',
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeErrorView extends StatelessWidget {
  const _HomeErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('홈 데이터를 불러오지 못했어요.', textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}
