import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/core/storage/token_storage.dart';
import 'package:dalm/core/storage/token_storage_provider.dart';
import 'package:dalm/features/profile/presentation/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('로그아웃 버튼을 누르면 토큰을 삭제하고 로그인 화면으로 이동한다', (tester) async {
    final tokenStorage = _MemoryTokenStorage();
    final router = GoRouter(
      initialLocation: AppRoutes.profile,
      routes: [
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const Scaffold(body: Text('LOGIN')),
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

    await tester.tap(find.text('로그아웃'));
    await tester.pumpAndSettle();

    expect(tokenStorage.clearCount, 1);
    expect(tokenStorage.accessToken, isNull);
    expect(tokenStorage.refreshToken, isNull);
    expect(find.text('LOGIN'), findsOneWidget);
  });
}

final class _MemoryTokenStorage implements TokenStorage {
  String? accessToken = 'access-token';
  String? refreshToken = 'refresh-token';
  int clearCount = 0;

  @override
  Future<String?> readAccessToken() async => accessToken;

  @override
  Future<String?> readRefreshToken() async => refreshToken;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }

  @override
  Future<void> clearTokens() async {
    clearCount++;
    accessToken = null;
    refreshToken = null;
  }
}
