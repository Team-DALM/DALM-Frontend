import 'package:dalm/core/storage/token_storage.dart';
import 'package:dalm/core/widgets/authenticated_network_image_provider.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    dotenv.loadFromString(
      envString: 'API_BASE_URL=https://api.example.com/v1/',
    );
  });

  test('상대 이미지 경로를 API 서버의 절대 URL로 변환하고 토큰을 추가한다', () async {
    final provider = AuthenticatedNetworkImageProvider(
      '/v1/photos/photo-1/image',
      tokenStorage: _MemoryTokenStorage('access-token'),
    );

    final key = await provider.obtainKey(ImageConfiguration.empty);

    expect(key.url, 'https://api.example.com/v1/photos/photo-1/image');
    expect(key.headers, {'Authorization': 'Bearer access-token'});
  });

  test('이미 완전한 이미지 URL이면 주소를 변경하지 않는다', () async {
    final provider = AuthenticatedNetworkImageProvider(
      'https://cdn.example.com/photo.jpg',
      tokenStorage: _MemoryTokenStorage('access-token'),
    );

    final key = await provider.obtainKey(ImageConfiguration.empty);

    expect(key.url, 'https://cdn.example.com/photo.jpg');
  });
}

final class _MemoryTokenStorage implements TokenStorage {
  const _MemoryTokenStorage(this.accessToken);

  final String? accessToken;

  @override
  Future<String?> readAccessToken() async => accessToken;

  @override
  Future<String?> readRefreshToken() async => null;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {}

  @override
  Future<void> clearTokens() async {}
}
