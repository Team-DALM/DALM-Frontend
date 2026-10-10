import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../storage/token_storage_provider.dart';
import 'auth/token_refresher.dart';
import 'interceptors/auth_interceptor.dart';

BaseOptions _createBaseOptions() {
  return BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 30),
    headers: const {
      Headers.acceptHeader: Headers.jsonContentType,
      Headers.contentTypeHeader: Headers.jsonContentType,
    },
  );
}

final refreshDioProvider = Provider<Dio>((ref) {
  final dio = Dio(_createBaseOptions());

  ref.onDispose(dio.close);

  return dio;
});

final tokenRefresherProvider = Provider<TokenRefresher>((ref) {
  final refreshDio = ref.watch(refreshDioProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);

  return TokenRefresher(dio: refreshDio, tokenStorage: tokenStorage);
});

final dioProvider = Provider<Dio>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  final tokenRefresher = ref.watch(tokenRefresherProvider);

  final dio = Dio(_createBaseOptions());

  dio.interceptors.add(
    AuthInterceptor(
      dio: dio,
      tokenStorage: tokenStorage,
      tokenRefresher: tokenRefresher,
    ),
  );

  ref.onDispose(dio.close);

  return dio;
});
