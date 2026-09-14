import 'package:dalm/core/error/network_exception.dart';
import 'package:dalm/features/auth/data/providers/auth_data_providers.dart';
import 'package:dalm/features/auth/domain/repositories/apple_auth_repository.dart';
import 'package:dalm/features/auth/domain/repositories/kakao_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginViewModelProvider =
    NotifierProvider.autoDispose<LoginViewModel, bool>(LoginViewModel.new);

enum KakaoLoginResult { authenticated, cancelled, failed }

enum AppleLoginResult { authenticated, cancelled, failed }

final class LoginViewModel extends Notifier<bool> {
  @override
  bool build() => false;

  Future<AppleLoginResult> loginWithApple() async {
    // 로그인 중 중복 클릭 방지
    if (state) return AppleLoginResult.cancelled;

    // 로그인 시작 시 로딩 상태로 전환
    state = true;

    try {
      final appleRepository = ref.read(appleAuthRepositoryProvider);
      final authRepository = ref.read(authRepositoryProvider);

      // Apple 인증 정보 발급
      final credential = await appleRepository.login();

      // identityToken 누락 확인
      final identityToken = credential.identityToken;
      if (identityToken == null || identityToken.isEmpty) {
        throw const AppleLoginFailedException();
      }

      // identityToken으로 DALM 서버 로그인
      await authRepository.loginWithApple(identityToken);

      return AppleLoginResult.authenticated;
    } on AppleLoginCancelledException {
      return AppleLoginResult.cancelled;
    } on AppleLoginFailedException {
      return AppleLoginResult.failed;
    } on NetworkException {
      return AppleLoginResult.failed;
    } on Object {
      return AppleLoginResult.failed;
    } finally {
      // 로그인 종료 시 로딩 상태 해제
      state = false;
    }
  }

  Future<KakaoLoginResult> loginWithKakao() async {
    // 로그인 중 중복 클릭 방지
    if (state) return KakaoLoginResult.cancelled;

    // 로그인 시작 시 로딩 상태로 전환
    state = true;

    try {
      final kakaoRepository = ref.read(kakaoAuthRepositoryProvider);
      final authRepository = ref.read(authRepositoryProvider);

      // 카카오 로그인으로 액세스 토큰 발급
      final kakaoAccessToken = await kakaoRepository.login();

      // 카카오 액세스 토큰으로 DALM 서버 로그인
      await authRepository.loginWithKakao(kakaoAccessToken);

      return KakaoLoginResult.authenticated;
    } on KakaoLoginCancelledException {
      return KakaoLoginResult.cancelled;
    } on KakaoLoginFailedException {
      return KakaoLoginResult.failed;
    } on NetworkException {
      return KakaoLoginResult.failed;
    } on Object {
      return KakaoLoginResult.failed;
    } finally {
      // 로그인 종료 시 로딩 상태 해제
      state = false;
    }
  }
}
