/// 사진 등록 API가 반환하는 처리 상태입니다.
///
/// 서버가 새 상태를 먼저 배포해도 구버전 앱이 파싱 중 종료되지 않도록
/// 알 수 없는 값은 [unknown]으로 보존합니다.
enum PhotoUploadStatus {
  validating,
  searching,
  rejected,
  unknown;

  factory PhotoUploadStatus.fromWireValue(String value) {
    return switch (value.toUpperCase()) {
      'VALIDATING' => PhotoUploadStatus.validating,
      'SEARCHING' => PhotoUploadStatus.searching,
      'REJECTED' => PhotoUploadStatus.rejected,
      _ => PhotoUploadStatus.unknown,
    };
  }
}
