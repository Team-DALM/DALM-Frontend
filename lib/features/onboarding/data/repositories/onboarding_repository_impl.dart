import 'dart:math';

import 'package:dalm/features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import 'package:dalm/features/onboarding/domain/repositories/onboarding_repository.dart';

final class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._remoteDataSource, {Random? random})
    : _random = random ?? Random.secure();

  final OnboardingRemoteDataSource _remoteDataSource;
  final Random _random;

  static const nicknames = ['노을빛우체통', '새벽산책자', '구름수집가', '햇살기록자', '달빛여행자'];

  @override
  Future<void> complete() {
    final nickname = nicknames[_random.nextInt(nicknames.length)];
    return _remoteDataSource.complete(nickname: nickname);
  }
}
