import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/features/profile/presentation/views/profile_account_screen.dart';
import 'package:dalm/features/profile/presentation/views/profile_notification_screen.dart';
import 'package:dalm/features/profile/presentation/views/profile_privacy_screen.dart';
import 'package:dalm/features/profile/presentation/views/profile_screen.dart';
import 'package:dalm/features/profile/presentation/views/profile_vision_detail_screen.dart';
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
      return const ProfileVisionDetailScreen();
    },
  ),
  GoRoute(
    path: ProfileRouteLocations.notificationSettings,
    builder: (context, state) {
      return const ProfileNotificationScreen();
    },
  ),
  GoRoute(
    path: ProfileRouteLocations.privacySettings,
    builder: (context, state) {
      return const ProfilePrivacyScreen();
    },
  ),
  GoRoute(
    path: ProfileRouteLocations.accountSettings,
    builder: (context, state) {
      return const ProfileAccountScreen();
    },
  ),
];
