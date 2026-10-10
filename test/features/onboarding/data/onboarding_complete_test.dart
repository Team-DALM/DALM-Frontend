import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dalm/features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import 'package:dalm/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('온보딩 완료 시 랜덤 닉네임과 필수 동의값을 multipart로 전달한다', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com/v1/'));

    dio.httpClientAdapter = _FakeHttpClientAdapter((options) async {
      expect(options.method, 'POST');
      expect(options.uri.path, '/v1/users/onboarding');

      final formData = options.data as FormData;
      final fields = Map<String, String>.fromEntries(formData.fields);

      expect(OnboardingRepositoryImpl.nicknames, contains(fields['nickname']));
      expect(fields['service_terms_agreed'], 'true');
      expect(fields['privacy_policy_agreed'], 'true');
      expect(fields['age_14_confirmed'], 'true');
      expect(fields['marketing_agreed'], 'false');
      expect(fields['service_terms_version'], '1.0');
      expect(fields['privacy_policy_version'], '1.0');

      return _jsonResponse(201, {
        'data': {
          'id': 'user-id',
          'nickname': fields['nickname'],
          'profile_image_url': null,
          'bio': null,
          'status': 'ACTIVE',
          'stats': {},
          'created_at': '2026-10-10T00:00:00Z',
        },
        'error': null,
      });
    });

    final repository = OnboardingRepositoryImpl(
      DioOnboardingRemoteDataSource(dio),
      random: Random(0),
    );

    await repository.complete();
    dio.close(force: true);
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

ResponseBody _jsonResponse(int statusCode, Map<String, dynamic> body) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}
