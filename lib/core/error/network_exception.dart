import 'package:dio/dio.dart';

import '../network/dto/api_error_dto.dart';

enum NetworkExceptionType {
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  transformTimeout,
  connection,
  badCertificate,
  cancelled,
  badResponse,
  unknown,
}

final class NetworkException implements Exception {
  const NetworkException({
    required this.type,
    required this.message,
    this.statusCode,
    this.code,
    this.requestId,
  });

  final NetworkExceptionType type;
  final String message;
  final int? statusCode;
  final String? code;
  final String? requestId;

  factory NetworkException.fromDioException(DioException exception) {
    return switch (exception.type) {
      DioExceptionType.connectionTimeout => const NetworkException(
        type: NetworkExceptionType.connectionTimeout,
        message: '서버 연결 시간이 초과되었습니다.',
      ),
      DioExceptionType.sendTimeout => const NetworkException(
        type: NetworkExceptionType.sendTimeout,
        message: '요청 전송 시간이 초과되었습니다.',
      ),
      DioExceptionType.transformTimeout => const NetworkException(
        type: NetworkExceptionType.transformTimeout,
        message: '응답 데이터 처리 시간이 초과되었습니다.',
      ),
      DioExceptionType.receiveTimeout => const NetworkException(
        type: NetworkExceptionType.receiveTimeout,
        message: '서버 응답 시간이 초과되었습니다.',
      ),
      DioExceptionType.connectionError => const NetworkException(
        type: NetworkExceptionType.connection,
        message: '네트워크 연결을 확인해주세요.',
      ),
      DioExceptionType.badCertificate => const NetworkException(
        type: NetworkExceptionType.badCertificate,
        message: '서버의 보안 인증서를 확인할 수 없습니다.',
      ),
      DioExceptionType.cancel => const NetworkException(
        type: NetworkExceptionType.cancelled,
        message: '요청이 취소되었습니다.',
      ),
      DioExceptionType.badResponse => _fromBadResponse(exception),
      DioExceptionType.unknown => const NetworkException(
        type: NetworkExceptionType.unknown,
        message: '알 수 없는 오류가 발생했습니다.',
      ),
    };
  }

  static NetworkException _fromBadResponse(DioException exception) {
    final response = exception.response;
    final errorDto = _parseApiError(response?.data);

    return NetworkException(
      type: NetworkExceptionType.badResponse,
      message: errorDto?.message ?? '서버 요청에 실패했습니다.',
      statusCode: response?.statusCode,
      code: errorDto?.code,
      requestId: errorDto?.requestId,
    );
  }

  static ApiErrorDto? _parseApiError(dynamic data) {
    if (data is! Map) {
      return null;
    }

    final error = data['error'];

    if (error is! Map) {
      return null;
    }

    return ApiErrorDto.fromJson(Map<String, dynamic>.from(error));
  }

  @override
  String toString() => message;
}
