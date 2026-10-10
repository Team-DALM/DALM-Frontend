import 'package:dalm/app/router/app_placeholder_page.dart';
import 'package:go_router/go_router.dart';

abstract final class SafetyRouteLocations {
  static const _safety = '/safety';
  static const hiddenPostcards = '$_safety/hidden-postcards';
  static const blockedUsers = '$_safety/blocked-users';
  static const reports = '$_safety/reports';
  static const reportDetailPattern = '$reports/:reportId';

  static String reportDetail(String reportId) => '$reports/$reportId';
}

final safetyRootRoutes = <RouteBase>[
  GoRoute(
    path: SafetyRouteLocations.hiddenPostcards,
    builder: (context, state) {
      return const AppPlaceholderPage(title: '숨긴 엽서');
    },
  ),
  GoRoute(
    path: SafetyRouteLocations.blockedUsers,
    builder: (context, state) {
      return const AppPlaceholderPage(title: '차단된 익명 사용자');
    },
  ),
  GoRoute(
    path: SafetyRouteLocations.reports,
    builder: (context, state) {
      return const AppPlaceholderPage(title: '신고 내역');
    },
  ),
  GoRoute(
    path: SafetyRouteLocations.reportDetailPattern,
    builder: (context, state) {
      final reportId = state.pathParameters['reportId']!;

      return AppPlaceholderPage(title: '신고 내역 상세: $reportId');
    },
  ),
];
