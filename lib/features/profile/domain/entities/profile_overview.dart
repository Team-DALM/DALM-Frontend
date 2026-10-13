final class ProfileOverview {
  const ProfileOverview({
    required this.id,
    required this.nickname,
    required this.createdAt,
    required this.photoCount,
    required this.matchCount,
    required this.receivedPostcardCount,
  });

  final String id;
  final String nickname;
  final DateTime createdAt;
  final int photoCount;
  final int matchCount;
  final int receivedPostcardCount;
}
