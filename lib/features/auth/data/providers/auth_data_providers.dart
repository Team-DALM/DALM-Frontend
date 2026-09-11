import 'package:dalm/features/auth/data/repositories/kakao_auth_repository_impl.dart';
import 'package:dalm/features/auth/domain/repositories/kakao_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final kakaoAuthRepositoryProvider = Provider<KakaoAuthRepository>((ref) {
  return KakaoAuthRepositoryImpl();
});
