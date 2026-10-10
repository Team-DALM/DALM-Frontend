import 'package:dio/dio.dart';

import '../../../../core/network/dto/api_response_dto.dart';
import '../../../../core/network/execute_api_call.dart';
import '../dtos/home_recent_match_data_dto.dart';
import '../dtos/home_searching_moment_list_dto.dart';
import '../dtos/home_today_data_dto.dart';

abstract interface class HomeRemoteDataSource {
  Future<HomeTodayDataDto> getToday();

  Future<HomeSearchingMomentListDto> getSearchingMoments();

  Future<HomeRecentMatchDataDto> getRecentMatch();
}

final class DioHomeRemoteDataSource implements HomeRemoteDataSource {
  DioHomeRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<HomeTodayDataDto> getToday() {
    return _getData(path: 'photos/today', fromJson: HomeTodayDataDto.fromJson);
  }

  @override
  Future<HomeSearchingMomentListDto> getSearchingMoments() {
    return _getData(
      path: 'moments',
      queryParameters: const {
        'status': 'SEARCHING',
        'exclude_today': true,
        'size': 6,
      },
      fromJson: HomeSearchingMomentListDto.fromJson,
    );
  }

  @override
  Future<HomeRecentMatchDataDto> getRecentMatch() {
    return _getData(
      path: 'matches/unviewed/next',
      fromJson: HomeRecentMatchDataDto.fromJson,
    );
  }

  Future<T> _getData<T>({
    required String path,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic>? queryParameters,
  }) {
    return executeApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
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

      final apiResponse = ApiResponseDto<T>.fromJson(responseBody, (json) {
        if (json is! Map) {
          throw const FormatException('서버 응답의 data 형식이 올바르지 않습니다.');
        }

        return fromJson(Map<String, dynamic>.from(json));
      });

      final data = apiResponse.data;

      if (data == null) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: apiResponse.error?.message ?? '홈 데이터를 불러오지 못했습니다.',
        );
      }

      return data;
    });
  }
}
