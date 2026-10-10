import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class AppConfig {
  static String get kakaoNativeAppKey {
    final value = dotenv.env['KAKAO_NATIVE_APP_KEY']?.trim();

    if (value == null || value.isEmpty) {
      throw StateError('KAKAO_NATIVE_APP_KEY가 설정되지 않았습니다.');
    }

    return value;
  }

  static String get apiBaseUrl {
    final value = dotenv.env['API_BASE_URL']?.trim();

    if (value == null || value.isEmpty) {
      throw StateError('API_BASE_URL이 설정되지 않았습니다.');
    }

    final uri = Uri.tryParse(value);

    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      throw StateError('API_BASE_URL 형식이 올바르지 않습니다: $value');
    }

    return value.endsWith('/') ? value : '$value/';
  }

  static final termsOfServiceUri = Uri.parse(
    'https://app.notion.com/p/DALM-3d4cb76aa8eb80ab821be73c75ceb66f'
    '?source=copy_link',
  );

  static final privacyPolicyUri = Uri.parse(
    'https://app.notion.com/p/DALM-3d4cb76aa8eb800f990fc47505de6767'
    '?source=copy_link',
  );
}
