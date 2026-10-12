import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/features/photo/presentation/routes/photo_analysis_route_args.dart';
import 'package:dalm/features/photo/presentation/routes/photo_flow_coordinator.dart';
import 'package:dalm/features/photo/presentation/routes/photo_record_route_args.dart';
import 'package:dalm/features/photo/presentation/routes/photo_rejected_route_args.dart';
import 'package:dalm/features/photo/presentation/routes/photo_upload_failure_route_args.dart';
import 'package:dalm/features/photo/presentation/views/photo_analysis_screen.dart';
import 'package:dalm/features/photo/presentation/views/photo_crop_screen.dart';
import 'package:dalm/features/photo/presentation/views/photo_record_screen.dart';
import 'package:dalm/features/photo/presentation/views/photo_rejected_screen.dart';
import 'package:dalm/features/photo/presentation/views/photo_upload_failure_screen.dart';
import 'package:dalm/features/photo/presentation/views/photo_upload_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

void _openPhotoCrop(BuildContext context, String imagePath) {
  PhotoFlowCoordinator.openCrop(context, imagePath);
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
  GoRoute(
    path: AppRoutes.photoAnalysis,
    redirect: (context, state) {
      return state.extra is PhotoAnalysisRouteArgs
          ? null
          : AppRoutes.photoUpload;
    },
    builder: (context, state) {
      final args = state.extra! as PhotoAnalysisRouteArgs;
      return PhotoAnalysisScreen(
        imagePath: args.imagePath,
        photoId: args.uploadResult.photoId,
      );
    },
  ),
  GoRoute(
    path: AppRoutes.photoUploadFailure,
    redirect: (context, state) {
      return state.extra is PhotoUploadFailureRouteArgs
          ? null
          : AppRoutes.photoUpload;
    },
    builder: (context, state) {
      final args = state.extra! as PhotoUploadFailureRouteArgs;
      return PhotoUploadFailureScreen(imagePath: args.imagePath);
    },
  ),
  GoRoute(
    path: AppRoutes.photoRejected,
    redirect: (context, state) {
      return state.extra is PhotoRejectedRouteArgs
          ? null
          : AppRoutes.photoUpload;
    },
    builder: (context, state) {
      final args = state.extra! as PhotoRejectedRouteArgs;
      return PhotoRejectedScreen(
        imagePath: args.imagePath,
        photoId: args.photoId,
      );
    },
  ),
  GoRoute(
    path: AppRoutes.photoRecord,
    redirect: (context, state) {
      return state.extra is PhotoRecordRouteArgs ? null : AppRoutes.photoUpload;
    },
    builder: (context, state) {
      final args = state.extra! as PhotoRecordRouteArgs;
      return PhotoRecordScreen(
        imagePath: args.imagePath,
        photoId: args.photoId,
      );
    },
  ),
];
