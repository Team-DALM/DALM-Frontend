abstract interface class AuthRepository {
  Future<bool> loginWithApple(String identityToken);

  Future<bool> loginWithKakao(String kakaoAccessToken);
}
