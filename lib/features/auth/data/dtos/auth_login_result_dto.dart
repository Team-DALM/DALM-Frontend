import 'package:dalm/core/network/dto/token_pair_dto.dart';

final class AuthLoginResultDto {
  const AuthLoginResultDto({
    required this.tokens,
    required this.onboardingRequired,
  });

  final TokenPairDto tokens;
  final bool onboardingRequired;

  factory AuthLoginResultDto.fromJson(Map<String, dynamic> json) {
    final tokens = json['tokens'];

    if (tokens is! Map || json['onboarding_required'] is! bool) {
      throw const FormatException('로그인 응답 형식이 올바르지 않습니다.');
    }

    return AuthLoginResultDto(
      tokens: TokenPairDto.fromJson(Map<String, dynamic>.from(tokens)),
      onboardingRequired: json['onboarding_required'] as bool,
    );
  }
}
