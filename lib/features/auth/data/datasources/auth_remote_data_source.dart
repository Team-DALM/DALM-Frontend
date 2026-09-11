import 'package:dio/dio.dart';

import '../../../../core/network/dto/api_response_dto.dart';
import '../../../../core/network/dto/token_pair_dto.dart';
import '../../../../core/network/execute_api_call.dart';
import '../../../../core/network/interceptors/auth_interceptor.dart';

abstract interface class AuthRemoteDataSource {
  Future<TokenPairDto> loginWithKakao(String kakaoAccessToken);
}

final class DioAuthRemoteDataSource implements AuthRemoteDataSource {
  DioAuthRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<TokenPairDto> loginWithKakao(String kakaoAccessToken) {
    return executeApiCall(() async {
      // 카카오 액세스 토큰을 DALM 로그인 API로 전달
      final response = await _dio.post<Map<String, dynamic>>(
        'auth/kakao',
        data: {'access_token': kakaoAccessToken},
        options: Options(extra: const {AuthInterceptor.requiresAuthKey: false}),
      );

      final responseBody = response.data;

      if (responseBody == null) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: '서버 응답이 비어 있습니다.',
        );
      }

      final apiResponse = ApiResponseDto<TokenPairDto>.fromJson(responseBody, (
        json,
      ) {
        if (json is! Map || json['tokens'] is! Map) {
          throw const FormatException('로그인 응답 형식이 올바르지 않습니다.');
        }

        // 로그인 응답에서 DALM 토큰 추출
        return TokenPairDto.fromJson(
          Map<String, dynamic>.from(json['tokens'] as Map),
        );
      });

      final tokens = apiResponse.data;

      if (tokens == null) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: apiResponse.error?.message ?? '로그인에 실패했습니다.',
        );
      }

      return tokens;
    });
  }
}
