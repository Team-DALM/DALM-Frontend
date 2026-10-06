import 'package:dio/dio.dart';

import '../../storage/token_storage.dart';
import '../dto/api_response_dto.dart';
import '../dto/token_pair_dto.dart';

final class TokenRefresher {
  TokenRefresher({required Dio dio, required TokenStorage tokenStorage})
    : _dio = dio,
      _tokenStorage = tokenStorage;

  final Dio _dio;
  final TokenStorage _tokenStorage;

  Future<TokenPairDto>? _refreshingFuture;

  Future<TokenPairDto> refreshTokens() {
    final refreshingFuture = _refreshingFuture;

    if (refreshingFuture != null) {
      return refreshingFuture;
    }

    final future = _performRefresh().whenComplete(() {
      _refreshingFuture = null;
    });

    _refreshingFuture = future;

    return future;
  }

  Future<TokenPairDto> _performRefresh() async {
    final refreshToken = await _tokenStorage.readRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      throw StateError('저장된 Refresh Token이 없습니다.');
    }

    final response = await _dio.post<Map<String, dynamic>>(
      'auth/refresh',
      data: {'refresh_token': refreshToken},
    );

    final responseBody = response.data;

    if (responseBody == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: '토큰 재발급 응답이 비어 있습니다.',
      );
    }

    final apiResponse = ApiResponseDto<TokenPairDto>.fromJson(responseBody, (
      json,
    ) {
      if (json is! Map) {
        throw const FormatException('토큰 재발급 응답의 data 형식이 올바르지 않습니다.');
      }

      return TokenPairDto.fromJson(Map<String, dynamic>.from(json));
    });

    final tokenPair = apiResponse.data;

    if (tokenPair == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: apiResponse.error?.message ?? '토큰 재발급에 실패했습니다.',
      );
    }

    await _tokenStorage.saveTokens(
      accessToken: tokenPair.accessToken,
      refreshToken: tokenPair.refreshToken,
    );

    return tokenPair;
  }
}
