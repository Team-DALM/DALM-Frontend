import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dalm/features/photo/data/datasources/photo_remote_data_source.dart';
import 'package:dalm/features/photo/data/dtos/create_photo_data_dto.dart';
import 'package:dalm/features/photo/data/repositories/photo_upload_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('4:5 사진을 multipart image 필드로 전송한다', () async {
    final tempDirectory = await Directory.systemTemp.createTemp(
      'dalm_photo_upload_test_',
    );
    addTearDown(() => tempDirectory.delete(recursive: true));
    final image = File(
      '${tempDirectory.path}${Platform.pathSeparator}crop.png',
    );
    await image.writeAsBytes([1, 2, 3]);

    final dio = Dio(BaseOptions(baseUrl: 'https://example.com/v1/'));
    addTearDown(() => dio.close(force: true));
    dio.httpClientAdapter = _FakeHttpClientAdapter((options) {
      expect(options.method, 'POST');
      expect(options.uri.path, '/v1/photos');
      expect(options.data, isA<FormData>());

      final formData = options.data as FormData;
      expect(formData.files.single.key, 'image');
      expect(formData.files.single.value.filename, 'crop.png');

      return _jsonResponse(202, {
        'data': {
          'photo_id': '9e5cd816-69af-4db8-a626-4a723c33fa77',
          'status': 'VALIDATING',
          'registered_at': '2026-10-10T03:20:00Z',
        },
        'error': null,
      });
    });

    final dataSource = DioPhotoRemoteDataSource(dio);
    final result = await dataSource.uploadPhoto(image.path);

    expect(result.photoId, '9e5cd816-69af-4db8-a626-4a723c33fa77');
    expect(result.status, 'VALIDATING');
    expect(result.registeredAt, DateTime.utc(2026, 10, 10, 3, 20));
  });

  test('API DTO를 사진 업로드 결과로 변환한다', () async {
    final repository = PhotoUploadRepositoryImpl(_FakePhotoRemoteDataSource());

    final result = await repository.uploadPhoto('/tmp/crop.png');

    expect(result.photoId, 'photo-id');
    expect(result.status, 'VALIDATING');
    expect(result.registeredAt, DateTime.utc(2026, 10, 10));
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
    await requestStream?.drain<void>();
    return _handler(options);
  }

  @override
  void close({bool force = false}) {}
}

final class _FakePhotoRemoteDataSource implements PhotoRemoteDataSource {
  @override
  Future<CreatePhotoDataDto> uploadPhoto(String imagePath) async {
    expect(imagePath, '/tmp/crop.png');

    return CreatePhotoDataDto(
      photoId: 'photo-id',
      status: 'VALIDATING',
      registeredAt: DateTime.utc(2026, 10, 10),
    );
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
