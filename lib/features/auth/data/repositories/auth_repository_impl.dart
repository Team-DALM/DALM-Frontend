import '../../../../core/storage/token_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource, this._tokenStorage);

  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  @override
  Future<bool> loginWithApple(String identityToken) async {
    final result = await _remoteDataSource.loginWithApple(identityToken);

    // 백엔드에서 발급한 DALM 토큰 저장
    await _saveTokens(result.tokens.accessToken, result.tokens.refreshToken);
    return result.onboardingRequired;
  }

  @override
  Future<bool> loginWithKakao(String kakaoAccessToken) async {
    final result = await _remoteDataSource.loginWithKakao(kakaoAccessToken);

    // 백엔드에서 발급한 DALM 토큰 저장
    await _saveTokens(result.tokens.accessToken, result.tokens.refreshToken);
    return result.onboardingRequired;
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await _tokenStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
