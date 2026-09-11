import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/core/network/auth/token_refresher.dart';
import 'package:dalm/core/network/dio_provider.dart';
import 'package:dalm/core/storage/token_storage.dart';
import 'package:dalm/core/storage/token_storage_provider.dart';
import 'package:dalm/features/onboarding/presentation/views/splash_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('Refresh Token이 없으면 온보딩 화면으로 이동한다', (tester) async {
    final tokenStorage = _MemoryTokenStorage();

    await _pumpSplash(tester, tokenStorage: tokenStorage);

    expect(find.text('ONBOARDING'), findsOneWidget);
  });

  testWidgets('토큰 재발급에 성공하면 새 토큰을 저장하고 홈으로 이동한다', (tester) async {
    final tokenStorage = _MemoryTokenStorage(refreshToken: 'old-refresh-token');
    final dio = _createRefreshDio((options) {
      expect(options.uri.path, '/v1/auth/refresh');
      expect(options.data, {'refresh_token': 'old-refresh-token'});

      return _jsonResponse(200, {
        'data': {
          'access_token': 'new-access-token',
          'refresh_token': 'new-refresh-token',
        },
        'error': null,
      });
    });

    await _pumpSplash(tester, tokenStorage: tokenStorage, refreshDio: dio);

    expect(find.text('HOME'), findsOneWidget);
    expect(tokenStorage.accessToken, 'new-access-token');
    expect(tokenStorage.refreshToken, 'new-refresh-token');

    dio.close(force: true);
  });

  testWidgets('Refresh Token이 거부되면 토큰을 삭제하고 온보딩으로 이동한다', (tester) async {
    final tokenStorage = _MemoryTokenStorage(
      accessToken: 'old-access-token',
      refreshToken: 'expired-refresh-token',
    );
    final dio = _createRefreshDio((options) {
      return _jsonResponse(401, {
        'data': null,
        'error': {
          'code': 'REFRESH_TOKEN_EXPIRED',
          'message': 'Refresh Token이 만료되었습니다.',
        },
      });
    });

    await _pumpSplash(tester, tokenStorage: tokenStorage, refreshDio: dio);

    expect(find.text('ONBOARDING'), findsOneWidget);
    expect(tokenStorage.accessToken, isNull);
    expect(tokenStorage.refreshToken, isNull);
    expect(tokenStorage.clearCount, 1);

    dio.close(force: true);
  });
}

Future<void> _pumpSplash(
  WidgetTester tester, {
  required _MemoryTokenStorage tokenStorage,
  Dio? refreshDio,
}) async {
  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const Scaffold(body: Text('ONBOARDING')),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const Scaffold(body: Text('HOME')),
      ),
    ],
  );

  final overrides = [tokenStorageProvider.overrideWithValue(tokenStorage)];

  if (refreshDio != null) {
    overrides.add(
      tokenRefresherProvider.overrideWithValue(
        TokenRefresher(dio: refreshDio, tokenStorage: tokenStorage),
      ),
    );
  }

  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();

  addTearDown(router.dispose);
}

Dio _createRefreshDio(_RequestHandler handler) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.com/v1/'));
  dio.httpClientAdapter = _FakeHttpClientAdapter(handler);
  return dio;
}

typedef _RequestHandler = FutureOr<ResponseBody> Function(
  RequestOptions options,
);

final class _FakeHttpClientAdapter implements HttpClientAdapter {
  _FakeHttpClientAdapter(this._handler);

  final _RequestHandler _handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return _handler(options);
  }

  @override
  void close({bool force = false}) {}
}

final class _MemoryTokenStorage implements TokenStorage {
  _MemoryTokenStorage({this.accessToken, this.refreshToken});

  String? accessToken;
  String? refreshToken;
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

ResponseBody _jsonResponse(int statusCode, Map<String, dynamic> body) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}
