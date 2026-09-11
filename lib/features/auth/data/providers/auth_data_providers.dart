import 'package:dalm/core/network/dio_provider.dart';
import 'package:dalm/core/storage/token_storage_provider.dart';
import 'package:dalm/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dalm/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dalm/features/auth/data/repositories/kakao_auth_repository_impl.dart';
import 'package:dalm/features/auth/domain/repositories/auth_repository.dart';
import 'package:dalm/features/auth/domain/repositories/kakao_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return DioAuthRemoteDataSource(ref.watch(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(tokenStorageProvider),
  );
});

final kakaoAuthRepositoryProvider = Provider<KakaoAuthRepository>((ref) {
  return KakaoAuthRepositoryImpl();
});
