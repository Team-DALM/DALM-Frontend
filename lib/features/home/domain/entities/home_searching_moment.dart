final class HomeSearchingMoment {
  const HomeSearchingMoment({
    required this.id,
    required this.imageUrl,
    required this.aiTitle,
    required this.registeredAt,
    required this.searchExpiresAt,
    required this.remainingDays,
  });

  // 사진 기본 정보
  final String id;
  final String imageUrl;
  final String aiTitle;
  final DateTime registeredAt;

  // 매칭 탐색 진행 정보
  final DateTime searchExpiresAt;
  final int remainingDays;
}
