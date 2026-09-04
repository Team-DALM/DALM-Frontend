enum HomeTodayPhotoStatus { validating, rejected, searching, matched }

final class HomeTodayPhoto {
  const HomeTodayPhoto({
    required this.id,
    required this.imageUrl,
    required this.status,
    required this.registeredAt,
    this.aiTitle,
    this.searchExpiresAt,
    this.remainingDays,
    this.match,
    this.rejectionCode,
    this.rejectionMessage,
  }) : assert(
         status != HomeTodayPhotoStatus.matched || match != null,
         '매칭 완료 상태에서는 매칭 정보가 필요합니다.',
       );

  // 모든 사진 상태에서 사용하는 기본 정보
  final String id;
  final String imageUrl;
  final HomeTodayPhotoStatus status;
  final DateTime registeredAt;

  // AI 검사 완료 후 생성되는 정보
  final String? aiTitle;

  // 탐색 중(SEARCHING)일 때 사용하는 정보
  final DateTime? searchExpiresAt;
  final int? remainingDays;

  // 매칭 완료(MATCHED)일 때 사용하는 정보
  final HomeTodayMatch? match;

  // 사진 거절(REJECTED)일 때 사용하는 정보
  final String? rejectionCode;
  final String? rejectionMessage;
}

final class HomeTodayMatch {
  const HomeTodayMatch({
    required this.matchId,
    required this.partnerImageUrl,
    required this.matchedAt,
  });

  final String matchId;
  final String partnerImageUrl;
  final DateTime matchedAt;
}
