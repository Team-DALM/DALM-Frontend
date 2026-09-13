final class AppleLoginCredential {
  const AppleLoginCredential({
    required this.authorizationCode,
    this.userIdentifier,
    this.identityToken,
    this.email,
    this.givenName,
    this.familyName,
  });

  final String authorizationCode;
  final String? userIdentifier;
  final String? identityToken;
  final String? email;
  final String? givenName;
  final String? familyName;
}

abstract interface class AppleAuthRepository {
  Future<AppleLoginCredential> login();
}

final class AppleLoginCancelledException implements Exception {
  const AppleLoginCancelledException();
}

final class AppleLoginFailedException implements Exception {
  const AppleLoginFailedException();
}
