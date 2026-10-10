import 'package:dalm/app/router/app_placeholder_page.dart';
import 'package:dalm/app/router/app_routes.dart';
import 'package:go_router/go_router.dart';

abstract final class MatchRouteLocations {
  static const _matches = '/matches';
  static const detailPattern = '$_matches/:matchId';

  static String detail(String matchId) => '$_matches/$matchId';

  static String similarity(String matchId) => '${detail(matchId)}/similarity';

  static String postcardWrite(String matchId) {
    return '${detail(matchId)}/postcard/write';
  }

  static String evaluation(String matchId) => '${detail(matchId)}/evaluation';

  static String report(String matchId) => '${detail(matchId)}/report';
}

final matchRootRoutes = <RouteBase>[
  GoRoute(
    path: AppRoutes.matching,
    builder: (context, state) {
      return const AppPlaceholderPage(title: '매칭 진행');
    },
  ),
  GoRoute(
    path: MatchRouteLocations.detailPattern,
    builder: (context, state) {
      final matchId = state.pathParameters['matchId']!;

      return AppPlaceholderPage(title: '닮은 순간 발견: $matchId');
    },
    routes: [
      GoRoute(
        path: 'similarity',
        builder: (context, state) {
          return const AppPlaceholderPage(title: '두 사진이 닮은 이유');
        },
      ),
      GoRoute(
        path: 'postcard/write',
        builder: (context, state) {
          return const AppPlaceholderPage(title: '익명 엽서 쓰기');
        },
      ),
      GoRoute(
        path: 'evaluation',
        builder: (context, state) {
          return const AppPlaceholderPage(title: '매칭 평가');
        },
      ),
      GoRoute(
        path: 'report',
        builder: (context, state) {
          return const AppPlaceholderPage(title: '사진 신고');
        },
      ),
    ],
  ),
];
