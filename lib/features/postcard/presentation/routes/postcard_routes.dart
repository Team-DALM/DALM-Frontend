import 'package:dalm/app/router/app_placeholder_page.dart';
import 'package:dalm/app/router/app_routes.dart';
import 'package:go_router/go_router.dart';

abstract final class PostcardRouteLocations {
  static const detailPattern = '${AppRoutes.postcards}/:postcardId';

  static String detail(String postcardId) {
    return '${AppRoutes.postcards}/$postcardId';
  }
}

final postcardShellRoutes = <RouteBase>[
  GoRoute(
    path: AppRoutes.postcards,
    builder: (context, state) {
      return const AppPlaceholderPage(title: '엽서함');
    },
  ),
];

final postcardRootRoutes = <RouteBase>[
  GoRoute(
    path: PostcardRouteLocations.detailPattern,
    builder: (context, state) {
      final postcardId = state.pathParameters['postcardId']!;

      return AppPlaceholderPage(title: '엽서 화면: $postcardId');
    },
  ),
];
