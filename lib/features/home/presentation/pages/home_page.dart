import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_models/home_view_model.dart';
import '../widgets/home_content.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);

    return SafeArea(
      bottom: false,
      child: homeState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _HomeErrorView(
          message: error.toString(),
          onRetry: () {
            ref.read(homeViewModelProvider.notifier).refresh();
          },
        ),
        data: (home) => HomeContent(
          home: home,
          onRefresh: () {
            return ref.read(homeViewModelProvider.notifier).refresh();
          },
          onPhotoUpload: () {
            // TODO: 사진 등록 화면 이동
          },
          onMatchTap: (matchId) {
            // TODO: 매칭 결과 화면 이동
          },
          onSearchingMomentTap: (photoId) {
            // TODO: 탐색 중인 사진 상세 화면 이동
          },
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('홈 데이터를 불러오지 못했어요.', textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              message,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
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
