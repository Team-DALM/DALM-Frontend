import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dalm/core/network/auth/token_refresher.dart';
import 'package:dalm/core/network/interceptors/auth_interceptor.dart';
import 'package:dalm/core/storage/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthInterceptor', () {
    late _MemoryTokenStorage tokenStorage;
    late Dio dio;
    late Dio refreshDio;

    setUp(() {
      tokenStorage = _MemoryTokenStorage(
        accessToken: 'expired-access-token',
        refreshToken: 'valid-refresh-token',
      );

      dio = Dio(BaseOptions(baseUrl: 'https://example.com/v1/'));
      refreshDio = Dio(BaseOptions(baseUrl: 'https://example.com/v1/'));

      final tokenRefresher = TokenRefresher(
        dio: refreshDio,
        tokenStorage: tokenStorage,
      );

      dio.interceptors.add(
        AuthInterceptor(
          dio: dio,
          tokenStorage: tokenStorage,
          tokenRefresher: tokenRefresher,
        ),
      );
    });

    tearDown(() {
      dio.close(force: true);
      refreshDio.close(force: true);
    });

    test('Access Token 만료 시 토큰을 재발급하고 원래 요청을 재시도한다', () async {
      var apiCallCount = 0;
      var refreshCallCount = 0;

      refreshDio.httpClientAdapter = _FakeHttpClientAdapter((options) {
        refreshCallCount++;

        expect(options.uri.path, '/v1/auth/refresh');
        expect(options.data, {'refresh_token': 'valid-refresh-token'});

        return _jsonResponse(200, {
          'data': {
            'access_token': 'new-access-token',
            'refresh_token': 'new-refresh-token',
          },
          'error': null,
        });
      });

      dio.httpClientAdapter = _FakeHttpClientAdapter((options) {
        apiCallCount++;

        final authorization = options.headers['Authorization'];

        if (authorization == 'Bearer expired-access-token') {
          return _accessTokenExpiredResponse();
        }

        expect(authorization, 'Bearer new-access-token');

        return _jsonResponse(200, {
          'data': {'photo_id': 'photo-1'},
          'error': null,
        });
      });

      final response = await dio.get<Map<String, dynamic>>('/photos/today');

      expect(response.statusCode, 200);
      expect(response.data?['data'], {'photo_id': 'photo-1'});
      expect(apiCallCount, 2);
      expect(refreshCallCount, 1);
      expect(tokenStorage.accessToken, 'new-access-token');
      expect(tokenStorage.refreshToken, 'new-refresh-token');
      expect(tokenStorage.clearCount, 0);
    });

    test('인증이 필요 없는 요청은 401이어도 토큰을 재발급하지 않는다', () async {
      var refreshCallCount = 0;

      refreshDio.httpClientAdapter = _FakeHttpClientAdapter((options) {
        refreshCallCount++;
        return _jsonResponse(500, {});
      });

      dio.httpClientAdapter = _FakeHttpClientAdapter((options) {
        return _accessTokenExpiredResponse();
      });

      final request = dio.get<void>(
        '/auth/kakao',
        options: Options(extra: {AuthInterceptor.requiresAuthKey: false}),
      );

      await expectLater(request, throwsA(isA<DioException>()));
      expect(refreshCallCount, 0);
    });

    test('Access Token 만료가 아닌 401은 토큰을 재발급하지 않는다', () async {
      var refreshCallCount = 0;

      refreshDio.httpClientAdapter = _FakeHttpClientAdapter((options) {
        refreshCallCount++;
        return _jsonResponse(500, {});
      });

      dio.httpClientAdapter = _FakeHttpClientAdapter((options) {
        return _jsonResponse(401, {
          'data': null,
          'error': {'code': 'ACCOUNT_RESTRICTED', 'message': '이용이 제한된 계정입니다.'},
        });
      });

      await expectLater(
        dio.get<void>('/users/me'),
        throwsA(isA<DioException>()),
      );

      expect(refreshCallCount, 0);
      expect(tokenStorage.clearCount, 0);
    });

    test('재시도한 요청도 401이면 추가 재발급 없이 토큰을 삭제한다', () async {
      var apiCallCount = 0;
      var refreshCallCount = 0;

      refreshDio.httpClientAdapter = _FakeHttpClientAdapter((options) {
        refreshCallCount++;

        return _jsonResponse(200, {
          'data': {
            'access_token': 'new-access-token',
            'refresh_token': 'new-refresh-token',
          },
          'error': null,
        });
      });

      dio.httpClientAdapter = _FakeHttpClientAdapter((options) {
        apiCallCount++;
        return _accessTokenExpiredResponse();
      });

      await expectLater(
        dio.get<void>('/photos/today'),
        throwsA(isA<DioException>()),
      );

      expect(apiCallCount, 2);
      expect(refreshCallCount, 1);
      expect(tokenStorage.clearCount, 1);
      expect(tokenStorage.accessToken, isNull);
      expect(tokenStorage.refreshToken, isNull);
    });

    test('Refresh Token이 거부되면 저장된 토큰을 삭제한다', () async {
      var apiCallCount = 0;
      var refreshCallCount = 0;

      refreshDio.httpClientAdapter = _FakeHttpClientAdapter((options) {
        refreshCallCount++;

        return _jsonResponse(401, {
          'data': null,
          'error': {
            'code': 'REFRESH_TOKEN_EXPIRED',
            'message': 'Refresh Token이 만료되었습니다.',
          },
        });
      });

      dio.httpClientAdapter = _FakeHttpClientAdapter((options) {
        apiCallCount++;
        return _accessTokenExpiredResponse();
      });

      await expectLater(
        dio.get<void>('/photos/today'),
        throwsA(isA<DioException>()),
      );

      expect(apiCallCount, 1);
      expect(refreshCallCount, 1);
      expect(tokenStorage.clearCount, 1);
      expect(tokenStorage.accessToken, isNull);
      expect(tokenStorage.refreshToken, isNull);
    });

    test('여러 요청이 동시에 401이어도 토큰 재발급은 한 번만 수행한다', () async {
      var apiCallCount = 0;
      var refreshCallCount = 0;

      refreshDio.httpClientAdapter = _FakeHttpClientAdapter((options) async {
        refreshCallCount++;

        await Future<void>.delayed(const Duration(milliseconds: 20));

        return _jsonResponse(200, {
          'data': {
            'access_token': 'new-access-token',
            'refresh_token': 'new-refresh-token',
          },
          'error': null,
        });
      });

      dio.httpClientAdapter = _FakeHttpClientAdapter((options) {
        apiCallCount++;

        if (options.headers['Authorization'] == 'Bearer expired-access-token') {
          return _accessTokenExpiredResponse();
        }

        return _jsonResponse(200, {
          'data': {'path': options.path},
          'error': null,
        });
      });

      final responses = await Future.wait([
        dio.get<Map<String, dynamic>>('/photos/today'),
        dio.get<Map<String, dynamic>>('/notifications'),
        dio.get<Map<String, dynamic>>('/users/me'),
      ]);

      expect(responses, hasLength(3));
      expect(responses.every((response) => response.statusCode == 200), isTrue);
      expect(apiCallCount, 6);
      expect(refreshCallCount, 1);
      expect(tokenStorage.accessToken, 'new-access-token');
      expect(tokenStorage.refreshToken, 'new-refresh-token');
    });
  });
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
  _MemoryTokenStorage({required this.accessToken, required this.refreshToken});

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

ResponseBody _accessTokenExpiredResponse() {
  return _jsonResponse(401, {
    'data': null,
    'error': {
      'code': 'ACCESS_TOKEN_EXPIRED',
      'message': 'Access Token이 만료되었습니다.',
    },
  });
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
