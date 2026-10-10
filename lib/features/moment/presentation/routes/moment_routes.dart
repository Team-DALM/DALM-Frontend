import 'package:dalm/app/router/app_placeholder_page.dart';
import 'package:dalm/app/router/app_routes.dart';
import 'package:go_router/go_router.dart';

abstract final class MomentRouteLocations {
  static const detailPattern = '${AppRoutes.moments}/:momentId';

  static String detail(String momentId) {
    return '${AppRoutes.moments}/$momentId';
  }
}

final momentShellRoutes = <RouteBase>[
  GoRoute(
    path: AppRoutes.moments,
    builder: (context, state) {
      return const AppPlaceholderPage(title: '순간들');
    },
  ),
];

final momentRootRoutes = <RouteBase>[
  GoRoute(
    path: MomentRouteLocations.detailPattern,
    builder: (context, state) {
      final momentId = state.pathParameters['momentId']!;

      return AppPlaceholderPage(title: '순간 상세: $momentId');
    },
  ),
];
