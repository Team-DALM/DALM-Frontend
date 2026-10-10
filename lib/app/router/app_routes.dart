abstract final class AppRoutes {
  // 인증 및 앱 진입
  static const splash = '/splash'; // 스플래시 화면
  static const onboarding = '/onboarding'; // 온보딩 화면
  static const login = '/login'; // 로그인 화면

  // 바텀 네비게이션
  static const home = '/home'; // 홈 화면
  static const moments = '/moments'; // 순간들 화면
  static const postcards = '/postcards'; // 엽서함 화면
  static const profile = '/profile'; // 프로필 화면

  // 바텀 네비게이션 없이 열리는 독립 화면
  static const photoUpload = '/photo/upload'; // 사진 업로드 화면
  static const photoCrop = '/photo/crop'; // 사진 4:5 맞추기 화면
  static const photoAnalysis = '/photo/analysis'; // 사진 AI 분석 진행 화면
  static const photoRecord = '/photo/record'; // 사진 분석 완료 화면
  static const photoUploadFailure = '/photo/upload/failure'; // 사진 업로드 실패 화면
  static const photoRejected = '/photo/rejected'; // 사진 AI 검증 실패 화면
  static const matching = '/matching'; // 매칭 화면
}
