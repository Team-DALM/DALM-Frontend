abstract interface class KakaoAuthRepository {
  Future<String> login();
}

final class KakaoLoginCancelledException implements Exception {
  const KakaoLoginCancelledException();
}

final class KakaoLoginFailedException implements Exception {
  const KakaoLoginFailedException();
}
