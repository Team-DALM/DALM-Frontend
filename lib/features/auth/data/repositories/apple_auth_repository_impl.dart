import 'package:dalm/features/auth/domain/repositories/apple_auth_repository.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final class AppleAuthRepositoryImpl implements AppleAuthRepository {
  @override
  Future<AppleLoginCredential> login() async {
    try {
      if (!await SignInWithApple.isAvailable()) {
        throw const AppleLoginFailedException();
      }

      // Apple 로그인 화면에서 이메일과 이름 사용 권한 요청
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // 백엔드 검증에 사용할 Apple 인증 정보 반환
      return AppleLoginCredential(
        authorizationCode: credential.authorizationCode,
        userIdentifier: credential.userIdentifier,
        identityToken: credential.identityToken,
        email: credential.email,
        givenName: credential.givenName,
        familyName: credential.familyName,
      );
    } on SignInWithAppleAuthorizationException catch (error) {
      // Apple 로그인 화면을 닫으면 사용자 취소로 처리
      if (error.code == AuthorizationErrorCode.canceled) {
        throw const AppleLoginCancelledException();
      }

      throw const AppleLoginFailedException();
    } on AppleLoginFailedException {
      rethrow;
    } on Object {
      throw const AppleLoginFailedException();
    }
  }
}
