import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/features/photo/presentation/views/photo_crop_screen.dart';
import 'package:dalm/features/photo/presentation/views/photo_upload_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

void _openPhotoCrop(BuildContext context, String imagePath) {
  // 선택한 원본 사진 경로를 크롭 화면에 전달
  context.push(AppRoutes.photoCrop, extra: imagePath);
}

final photoRootRoutes = <RouteBase>[
  GoRoute(
    path: AppRoutes.photoUpload,
    builder: (context, state) {
      return PhotoUploadScreen(
        onPhotoCaptured: (path) => _openPhotoCrop(context, path),
        onPhotoSelected: (path) => _openPhotoCrop(context, path),
      );
    },
  ),
  GoRoute(
    path: AppRoutes.photoCrop,
    redirect: (context, state) {
      // 사진 경로 없이 직접 진입하면 사진 등록 화면으로 이동
      final imagePath = state.extra;
      return imagePath is String && imagePath.isNotEmpty
          ? null
          : AppRoutes.photoUpload;
    },
    builder: (context, state) {
      return PhotoCropScreen(imagePath: state.extra! as String);
    },
  ),
];
