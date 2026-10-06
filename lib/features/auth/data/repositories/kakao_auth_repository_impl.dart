import 'package:dalm/features/auth/domain/repositories/kakao_auth_repository.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

final class KakaoAuthRepositoryImpl implements KakaoAuthRepository {
  @override
  Future<String> login() async {
    try {
      final OAuthToken token;

      // 카카오톡 설치 여부 확인
      if (await isKakaoTalkInstalled()) {
        token = await _loginWithKakaoTalkOrAccount();
      } else {
        // 카카오톡이 없으면 웹 로그인으로 전환
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      // 백엔드 로그인에 사용할 카카오 액세스 토큰 반환
      return token.accessToken;
    } on KakaoLoginCancelledException {
      rethrow;
    } catch (error) {
      if (_isCancelled(error)) {
        throw const KakaoLoginCancelledException();
      }

      throw const KakaoLoginFailedException();
    }
  }

  Future<OAuthToken> _loginWithKakaoTalkOrAccount() async {
    try {
      return await UserApi.instance.loginWithKakaoTalk();
    } catch (error) {
      if (_isCancelled(error)) {
        throw const KakaoLoginCancelledException();
      }

      // 카카오톡 로그인 실패 시 웹 로그인으로 전환
      return UserApi.instance.loginWithKakaoAccount();
    }
  }

  bool _isCancelled(Object error) {
    // 로그인 화면 닫기와 동의 거부를 사용자 취소로 처리
    return switch (error) {
      KakaoClientException(reason: ClientErrorCause.cancelled) => true,
      KakaoAuthException(error: AuthErrorCause.accessDenied) => true,
      _ => false,
    };
  }
}
