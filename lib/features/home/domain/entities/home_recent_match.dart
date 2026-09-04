final class HomeRecentMatch {
  const HomeRecentMatch({
    required this.matchId,
    required this.myPhotoId,
    required this.myImageUrl,
    required this.partnerImageUrl,
    required this.aiTitle,
    required this.matchedAt,
  });

  // 매칭 및 사진 정보
  final String matchId;
  final String myPhotoId;
  final String myImageUrl;
  final String partnerImageUrl;

  // 매칭 결과 정보
  final String aiTitle;
  final DateTime matchedAt;
}
