final class ProfileDto {
  const ProfileDto({
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

  factory ProfileDto.fromJson(Map<String, dynamic> json) {
    final stats = json['stats'];

    if (stats is! Map) {
      throw const FormatException('프로필 통계 형식이 올바르지 않습니다.');
    }

    return ProfileDto(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      photoCount: stats['photo_count'] as int,
      matchCount: stats['match_count'] as int,
      receivedPostcardCount: (stats['received_postcard_count'] as int?) ?? 0,
    );
  }
}
