import 'package:dalm/app/router/app_routes.dart';
import 'package:go_router/go_router.dart';

import '../pages/home_page.dart';

final homeShellRoutes = <RouteBase>[
  GoRoute(
    path: AppRoutes.home,
    builder: (context, state) {
      return const HomePage();
    },
  ),
];
