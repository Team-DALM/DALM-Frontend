import 'package:dalm/features/auth/data/providers/auth_data_providers.dart';
import 'package:dalm/features/auth/domain/repositories/kakao_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginViewModelProvider =
    NotifierProvider.autoDispose<LoginViewModel, bool>(LoginViewModel.new);

enum KakaoLoginResult { authenticated, cancelled, failed }

final class LoginViewModel extends Notifier<bool> {
  @override
  bool build() => false;

  Future<KakaoLoginResult> loginWithKakao() async {
    // 로그인 중 중복 클릭 방지
    if (state) return KakaoLoginResult.cancelled;

    // 로그인 시작 시 로딩 상태로 전환
    state = true;

    try {
      final repository = ref.read(kakaoAuthRepositoryProvider);
      // 카카오톡 또는 웹으로 카카오 인증 요청
      await repository.login();

      return KakaoLoginResult.authenticated;
    } on KakaoLoginCancelledException {
      return KakaoLoginResult.cancelled;
    } on KakaoLoginFailedException {
      return KakaoLoginResult.failed;
    } finally {
      // 로그인 종료 시 로딩 상태 해제
      state = false;
    }
  }
}
