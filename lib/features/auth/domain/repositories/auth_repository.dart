abstract interface class AuthRepository {
  Future<void> loginWithKakao(String kakaoAccessToken);
} //카카오 토큰으로 DALM 서버 로그인하기
