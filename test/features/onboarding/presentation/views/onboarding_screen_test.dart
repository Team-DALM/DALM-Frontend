import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/core/storage/token_storage.dart';
import 'package:dalm/core/storage/token_storage_provider.dart';
import 'package:dalm/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('로그인 상태이면 소개 온보딩 완료 후 홈으로 이동한다', (tester) async {
    await _pumpOnboarding(
      tester,
      tokenStorage: _MemoryTokenStorage(refreshToken: 'refresh-token'),
    );

    await _finishOnboarding(tester);

    expect(find.text('HOME'), findsOneWidget);
  });

  testWidgets('로그인 상태가 아니면 소개 온보딩 완료 후 로그인으로 이동한다', (tester) async {
    await _pumpOnboarding(tester, tokenStorage: _MemoryTokenStorage());

    await _finishOnboarding(tester);

    expect(find.text('LOGIN'), findsOneWidget);
  });
}

Future<void> _pumpOnboarding(
  WidgetTester tester, {
  required TokenStorage tokenStorage,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(390, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  final router = GoRouter(
    initialLocation: AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const Scaffold(body: Text('LOGIN')),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const Scaffold(body: Text('HOME')),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [tokenStorageProvider.overrideWithValue(tokenStorage)],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _finishOnboarding(WidgetTester tester) async {
  await tester.tap(find.text('다음'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('다음'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('DALM 시작하기'));
  await tester.pumpAndSettle();
}

final class _MemoryTokenStorage implements TokenStorage {
  _MemoryTokenStorage({this.refreshToken});

  final String? refreshToken;

  @override
  Future<String?> readAccessToken() async => null;

  @override
  Future<String?> readRefreshToken() async => refreshToken;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {}

  @override
  Future<void> clearTokens() async {}
}
