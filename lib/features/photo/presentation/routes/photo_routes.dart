import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/features/photo/presentation/views/photo_crop_screen.dart';
import 'package:dalm/features/photo/presentation/views/photo_upload_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

void _openPhotoCrop(BuildContext context, String imagePath) {
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
    builder: (context, state) {
      final imagePath = state.extra;
      if (imagePath is! String || imagePath.isEmpty) {
        return const _MissingPhotoScreen();
      }

      return PhotoCropScreen(imagePath: imagePath);
    },
  ),
];

class _MissingPhotoScreen extends StatelessWidget {
  const _MissingPhotoScreen();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: DalmColors.photoEditorBackground,
      child: Center(
        child: Text(
          '사진을 불러오지 못했어요.',
          textDirection: TextDirection.ltr,
          style: TextStyle(color: DalmColors.textInverse),
        ),
      ),
    );
  }
}
