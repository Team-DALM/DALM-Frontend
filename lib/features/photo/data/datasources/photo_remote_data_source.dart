import 'package:dalm/core/network/dto/api_response_dto.dart';
import 'package:dalm/core/network/execute_api_call.dart';
import 'package:dio/dio.dart';

import '../dtos/create_photo_data_dto.dart';

/// 사진 등록 API 접근 규격
abstract interface class PhotoRemoteDataSource {
  Future<CreatePhotoDataDto> uploadPhoto(String imagePath);
}

/// Dio를 사용하는 사진 등록 API 데이터 소스
final class DioPhotoRemoteDataSource implements PhotoRemoteDataSource {
  const DioPhotoRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<CreatePhotoDataDto> uploadPhoto(String imagePath) {
    return executeApiCall(() async {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });
      final response = await _dio.post<Map<String, dynamic>>(
        'photos',
        data: formData,
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

      final apiResponse = ApiResponseDto<CreatePhotoDataDto>.fromJson(
        responseBody,
        (json) {
          if (json is! Map) {
            throw const FormatException('서버 응답의 data 형식이 올바르지 않습니다.');
          }

          return CreatePhotoDataDto.fromJson(Map<String, dynamic>.from(json));
        },
      );
      final data = apiResponse.data;

      if (data == null) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: apiResponse.error?.message ?? '사진을 등록하지 못했습니다.',
        );
      }

      return data;
    });
  }
}
