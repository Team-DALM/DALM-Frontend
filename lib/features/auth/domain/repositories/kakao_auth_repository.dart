abstract interface class KakaoAuthRepository {
  Future<String> login();
}

//카카오에서 토큰 받기
final class KakaoLoginCancelledException implements Exception {
  const KakaoLoginCancelledException();
}

final class KakaoLoginFailedException implements Exception {
  const KakaoLoginFailedException();
}
