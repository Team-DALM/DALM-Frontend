import 'package:dalm/app/router/app_placeholder_page.dart';
import 'package:dalm/app/router/app_routes.dart';
import 'package:go_router/go_router.dart';

final photoRootRoutes = <RouteBase>[
  GoRoute(
    path: AppRoutes.photoUpload,
    builder: (context, state) {
      return const AppPlaceholderPage(title: '사진 등록');
    },
  ),
];
