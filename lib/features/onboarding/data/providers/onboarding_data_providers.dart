import 'package:dalm/core/network/dio_provider.dart';
import 'package:dalm/features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import 'package:dalm/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:dalm/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingRemoteDataSourceProvider = Provider<OnboardingRemoteDataSource>(
  (ref) => DioOnboardingRemoteDataSource(ref.watch(dioProvider)),
);

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepositoryImpl(
    ref.watch(onboardingRemoteDataSourceProvider),
  );
});
