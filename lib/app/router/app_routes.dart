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
  static const matching = '/matching'; // 매칭 화면
}
