import 'package:dalm/features/auth/presentation/routes/auth_routes.dart';
import 'package:dalm/features/home/presentation/routes/home_routes.dart';
import 'package:dalm/features/match/presentation/routes/match_routes.dart';
import 'package:dalm/features/moment/presentation/routes/moment_routes.dart';
import 'package:dalm/features/photo/presentation/routes/photo_routes.dart';
import 'package:dalm/features/postcard/presentation/routes/postcard_routes.dart';
import 'package:dalm/features/profile/presentation/routes/profile_routes.dart';
import 'package:dalm/features/safety/presentation/routes/safety_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import 'dalm_navigation_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      // 바텀 네비게이션 없이 열리는 화면
      ...authRootRoutes,
      ...momentRootRoutes,
      ...postcardRootRoutes,
      ...profileRootRoutes,
      ...photoRootRoutes,
      ...matchRootRoutes,
      ...safetyRootRoutes,

      // 바텀 네비게이션이 있는 화면
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return DalmNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: homeShellRoutes),
          StatefulShellBranch(routes: momentShellRoutes),
          StatefulShellBranch(routes: postcardShellRoutes),
          StatefulShellBranch(routes: profileShellRoutes),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);

  return router;
});
