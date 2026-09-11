import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dalm/core/network/dto/token_pair_dto.dart';
import 'package:dalm/core/storage/token_storage.dart';
import 'package:dalm/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dalm/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('카카오 액세스 토큰을 서버에 전달하고 DALM 토큰을 파싱한다', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com/v1/'));

    dio.httpClientAdapter = _FakeHttpClientAdapter((options) {
      expect(options.method, 'POST');
      expect(options.uri.path, '/v1/auth/kakao');
      expect(options.data, {'access_token': 'kakao-access-token'});

      return _jsonResponse(201, {
        'data': {
          'is_new_user': true,
          'onboarding_required': true,
          'tokens': {
            'access_token': 'dalm-access-token',
            'refresh_token': 'dalm-refresh-token',
            'token_type': 'Bearer',
            'expires_in': 3600,
          },
          'user': {'id': 'user-id', 'nickname': null, 'status': 'ACTIVE'},
        },
        'error': null,
      });
    });

    final dataSource = DioAuthRemoteDataSource(dio);

    final tokens = await dataSource.loginWithKakao('kakao-access-token');

    expect(tokens.accessToken, 'dalm-access-token');
    expect(tokens.refreshToken, 'dalm-refresh-token');

    dio.close(force: true);
  });

  test('서버 로그인 성공 시 백엔드에서 발급한 토큰을 저장한다', () async {
    final tokenStorage = _MemoryTokenStorage();
    final repository = AuthRepositoryImpl(
      _FakeAuthRemoteDataSource(),
      tokenStorage,
    );

    await repository.loginWithKakao('kakao-access-token');

    expect(tokenStorage.accessToken, 'dalm-access-token');
    expect(tokenStorage.refreshToken, 'dalm-refresh-token');
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

final class _FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<TokenPairDto> loginWithKakao(String kakaoAccessToken) async {
    expect(kakaoAccessToken, 'kakao-access-token');

    return const TokenPairDto(
      accessToken: 'dalm-access-token',
      refreshToken: 'dalm-refresh-token',
    );
  }
}

final class _MemoryTokenStorage implements TokenStorage {
  String? accessToken;
  String? refreshToken;

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
