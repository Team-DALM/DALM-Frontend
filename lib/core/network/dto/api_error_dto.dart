final class ApiErrorDto {
  const ApiErrorDto({
    required this.code,
    required this.message,
    this.requestId,
  });

  final String code;
  final String message;
  final String? requestId;

  factory ApiErrorDto.fromJson(Map<String, dynamic> json) {
    return ApiErrorDto(
      code: json['code'] as String? ?? 'UNKNOWN_ERROR',
      message: json['message'] as String? ?? '알 수 없는 오류가 발생했습니다.',
      requestId: json['request_id'] as String?,
    );
  }
}
