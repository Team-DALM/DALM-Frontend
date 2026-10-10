import 'package:dalm/core/network/execute_api_call.dart';
import 'package:dio/dio.dart';

abstract interface class OnboardingRemoteDataSource {
  Future<void> complete({required String nickname});
}

final class DioOnboardingRemoteDataSource
    implements OnboardingRemoteDataSource {
  const DioOnboardingRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<void> complete({required String nickname}) {
    return executeApiCall(() async {
      await _dio.post<void>(
        'users/onboarding',
        data: FormData.fromMap({
          'nickname': nickname,
          'service_terms_agreed': true,
          'privacy_policy_agreed': true,
          'age_14_confirmed': true,
          'marketing_agreed': false,
          'service_terms_version': '1.0',
          'privacy_policy_version': '1.0',
        }),
      );
    });
  }
}
