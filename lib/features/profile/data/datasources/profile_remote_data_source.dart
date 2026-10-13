import 'package:dalm/core/network/dto/api_response_dto.dart';
import 'package:dalm/core/network/execute_api_call.dart';
import 'package:dalm/features/profile/data/dtos/profile_dto.dart';
import 'package:dio/dio.dart';

abstract interface class ProfileRemoteDataSource {
  Future<ProfileDto> getMyProfile();
}

final class DioProfileRemoteDataSource implements ProfileRemoteDataSource {
  const DioProfileRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<ProfileDto> getMyProfile() {
    return executeApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('users/me');
      final responseBody = response.data;

      if (responseBody == null) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: '서버 응답이 비어 있습니다.',
        );
      }

      final apiResponse = ApiResponseDto<ProfileDto>.fromJson(
        responseBody,
        (json) {
          if (json is! Map) {
            throw const FormatException('프로필 응답 형식이 올바르지 않습니다.');
          }

          return ProfileDto.fromJson(Map<String, dynamic>.from(json));
        },
      );

      final data = apiResponse.data;
      if (data == null) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: apiResponse.error?.message ?? '프로필을 불러오지 못했습니다.',
        );
      }

      return data;
    });
  }
}
