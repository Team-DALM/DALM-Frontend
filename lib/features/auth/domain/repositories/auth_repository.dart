abstract interface class AuthRepository {
  Future<void> loginWithApple(String identityToken);

  Future<void> loginWithKakao(String kakaoAccessToken);
}
