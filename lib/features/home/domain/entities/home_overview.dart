import 'home_recent_match.dart';
import 'home_searching_moment.dart';
import 'home_today_photo.dart';

final class HomeOverview {
  const HomeOverview({
    required this.canRegister,
    required this.todayPhoto,
    required this.searchingMoments,
    required this.recentMatch,
    required this.unreadMatchCount,
  });

  // 오늘 새로운 사진을 등록할 수 있는지 여부
  final bool canRegister;

  // 오늘 사진이 없으면 null
  final HomeTodayPhoto? todayPhoto;

  // 오늘을 제외한 탐색 중인 과거 사진 목록
  final List<HomeSearchingMoment> searchingMoments;

  // 과거 사진에서 가장 최근에 발생한 매칭
  final HomeRecentMatch? recentMatch;

  // 사용자가 아직 확인하지 않은 과거 매칭 개수
  final int unreadMatchCount;
}
