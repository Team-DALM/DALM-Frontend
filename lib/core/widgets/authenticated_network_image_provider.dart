import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/app_config.dart';
import '../storage/secure_token_storage.dart';
import '../storage/token_storage.dart';

/// API의 상대 이미지 경로를 해석하고 현재 액세스 토큰으로 요청하는 이미지 제공자입니다.
final class AuthenticatedNetworkImageProvider
    extends ImageProvider<NetworkImage> {
  AuthenticatedNetworkImageProvider(this.imageUrl, {TokenStorage? tokenStorage})
    : _tokenStorage =
          tokenStorage ?? const SecureTokenStorage(FlutterSecureStorage());

  final String imageUrl;
  final TokenStorage _tokenStorage;

  @override
  Future<NetworkImage> obtainKey(ImageConfiguration configuration) async {
    final accessToken = await _tokenStorage.readAccessToken();

    return NetworkImage(
      resolveImageUrl(imageUrl),
      headers: accessToken == null || accessToken.isEmpty
          ? null
          : {'Authorization': 'Bearer $accessToken'},
    );
  }

  @override
  ImageStreamCompleter loadImage(
    NetworkImage key,
    ImageDecoderCallback decode,
  ) {
    return key.loadImage(key, decode);
  }

  static String resolveImageUrl(String imageUrl) {
    return Uri.parse(AppConfig.apiBaseUrl).resolve(imageUrl).toString();
  }
}
