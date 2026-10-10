import 'api_error_dto.dart';

final class ApiResponseDto<T> {
  const ApiResponseDto({required this.data, required this.error});

  final T? data;
  final ApiErrorDto? error;

  factory ApiResponseDto.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final data = json['data'];
    final error = json['error'];

    return ApiResponseDto<T>(
      data: data == null ? null : fromJsonT(data),
      error: error is Map
          ? ApiErrorDto.fromJson(Map<String, dynamic>.from(error))
          : null,
    );
  }

  bool get isSuccess => error == null;
}
