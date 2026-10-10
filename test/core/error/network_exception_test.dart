import 'package:dalm/core/error/network_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NetworkException', () {
    test('연결 시간 초과 오류를 변환한다', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      final result = NetworkException.fromDioException(dioException);

      expect(result.type, NetworkExceptionType.connectionTimeout);
      expect(result.message, '서버 연결 시간이 초과되었습니다.');
    });

    test('서버 오류 응답에서 오류 정보를 추출한다', () {
      final requestOptions = RequestOptions(path: '/photos/today');
      final dioException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 404,
          data: {
            'data': null,
            'error': {
              'code': 'PHOTO_NOT_FOUND',
              'message': '사진을 찾을 수 없습니다.',
              'request_id': 'request-uuid',
            },
          },
        ),
      );

      final result = NetworkException.fromDioException(dioException);

      expect(result.type, NetworkExceptionType.badResponse);
      expect(result.statusCode, 404);
      expect(result.code, 'PHOTO_NOT_FOUND');
      expect(result.message, '사진을 찾을 수 없습니다.');
      expect(result.requestId, 'request-uuid');
    });

    test('서버 오류 형식이 잘못되면 기본 메시지를 사용한다', () {
      final requestOptions = RequestOptions(path: '/test');
      final dioException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 500,
          data: 'Internal Server Error',
        ),
      );

      final result = NetworkException.fromDioException(dioException);

      expect(result.type, NetworkExceptionType.badResponse);
      expect(result.statusCode, 500);
      expect(result.code, isNull);
      expect(result.message, '서버 요청에 실패했습니다.');
      expect(result.requestId, isNull);
    });
  });
}
