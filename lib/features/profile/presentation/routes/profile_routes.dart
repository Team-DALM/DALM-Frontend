import 'package:dalm/app/router/app_placeholder_page.dart';
import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/features/profile/presentation/views/profile_screen.dart';
import 'package:go_router/go_router.dart';

abstract final class ProfileRouteLocations {
  static const insight = '${AppRoutes.profile}/insight';
  static const notificationSettings =
      '${AppRoutes.profile}/settings/notifications';
  static const privacySettings = '${AppRoutes.profile}/settings/privacy';
  static const accountSettings = '${AppRoutes.profile}/settings/account';
}

final profileShellRoutes = <RouteBase>[
  GoRoute(
    path: AppRoutes.profile,
    builder: (context, state) {
      return const ProfileScreen();
    },
  ),
];

final profileRootRoutes = <RouteBase>[
  GoRoute(
    path: ProfileRouteLocations.insight,
    builder: (context, state) {
      return const AppPlaceholderPage(title: '나의 시선 분석');
    },
  ),
  GoRoute(
    path: ProfileRouteLocations.notificationSettings,
    builder: (context, state) {
      return const AppPlaceholderPage(title: '알림 설정');
    },
  ),
  GoRoute(
    path: ProfileRouteLocations.privacySettings,
    builder: (context, state) {
      return const AppPlaceholderPage(title: '개인정보 및 안전');
    },
  ),
  GoRoute(
    path: ProfileRouteLocations.accountSettings,
    builder: (context, state) {
      return const AppPlaceholderPage(title: '계정 관리');
    },
  ),
];
