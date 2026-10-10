import 'package:dio/dio.dart';

import '../../storage/token_storage.dart';
import '../auth/token_refresher.dart';

final class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required Dio dio,
    required TokenStorage tokenStorage,
    required TokenRefresher tokenRefresher,
  }) : _dio = dio,
       _tokenStorage = tokenStorage,
       _tokenRefresher = tokenRefresher;

  final Dio _dio;
  final TokenStorage _tokenStorage;
  final TokenRefresher _tokenRefresher;

  static const requiresAuthKey = 'requiresAuth';
  static const retryAttemptedKey = 'authRetryAttempted';

  static const _accessTokenExpiredCode = 'ACCESS_TOKEN_EXPIRED';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final requiresAuth = options.extra[requiresAuthKey] as bool? ?? true;

    if (!requiresAuth) {
      handler.next(options);
      return;
    }

    try {
      final accessToken = await _tokenStorage.readAccessToken();

      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }

      handler.next(options);
    } catch (error, stackTrace) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          error: error,
          stackTrace: stackTrace,
          message: 'Access Token을 읽지 못했습니다.',
        ),
      );
    }
  }

  @override
  void onError(DioException exception, ErrorInterceptorHandler handler) async {
    final requestOptions = exception.requestOptions;

    if (!_shouldRefresh(exception)) {
      handler.next(exception);
      return;
    }

    try {
      final tokenPair = await _tokenRefresher.refreshTokens();

      requestOptions.extra[retryAttemptedKey] = true;

      requestOptions.headers['Authorization'] =
          'Bearer ${tokenPair.accessToken}';

      final requestData = requestOptions.data;

      if (requestData is FormData) {
        requestOptions.data = requestData.clone();
      }

      final response = await _dio.fetch<dynamic>(requestOptions);

      handler.resolve(response);
    } catch (refreshError, stackTrace) {
      if (_shouldClearTokens(refreshError)) {
        await _tokenStorage.clearTokens();
      }

      if (refreshError is DioException) {
        handler.reject(refreshError);
        return;
      }

      handler.reject(
        DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.unknown,
          error: refreshError,
          stackTrace: stackTrace,
          message: '토큰 재발급에 실패했습니다.',
        ),
      );
    }
  }

  bool _shouldRefresh(DioException exception) {
    final requestOptions = exception.requestOptions;

    final requiresAuth = requestOptions.extra[requiresAuthKey] as bool? ?? true;

    final retryAttempted =
        requestOptions.extra[retryAttemptedKey] as bool? ?? false;

    final isUnauthorized = exception.response?.statusCode == 401;
    final errorCode = _readErrorCode(exception.response?.data);

    final isRefreshableError =
        errorCode == null || errorCode == _accessTokenExpiredCode;

    return requiresAuth &&
        !retryAttempted &&
        isUnauthorized &&
        isRefreshableError;
  }

  String? _readErrorCode(dynamic data) {
    if (data is! Map) {
      return null;
    }

    final error = data['error'];

    if (error is! Map) {
      return null;
    }

    final code = error['code'];

    return code is String ? code : null;
  }

  bool _shouldClearTokens(Object error) {
    if (error is StateError) {
      return true;
    }

    if (error is DioException) {
      final statusCode = error.response?.statusCode;

      return statusCode == 401 || statusCode == 403;
    }

    return false;
  }
}
