import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/features/photo/presentation/views/photo_upload_screen.dart';
import 'package:go_router/go_router.dart';

final photoRootRoutes = <RouteBase>[
  GoRoute(
    path: AppRoutes.photoUpload,
    builder: (context, state) {
      return const PhotoUploadScreen();
    },
  ),
];
