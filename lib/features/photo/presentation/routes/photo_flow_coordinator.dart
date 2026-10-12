import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/features/photo/domain/entities/photo_analysis_progress.dart';
import 'package:dalm/features/photo/domain/entities/photo_upload_result.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'photo_analysis_route_args.dart';
import 'photo_record_route_args.dart';
import 'photo_rejected_route_args.dart';
import 'photo_upload_failure_route_args.dart';

/// 사진 등록 흐름의 화면 전환과 route 인자 구성을 한곳에서 관리합니다.
abstract final class PhotoFlowCoordinator {
  static void openCrop(BuildContext context, String imagePath) {
    context.push(AppRoutes.photoCrop, extra: imagePath);
  }

  static void openAnalysis(
    BuildContext context, {
    required String imagePath,
    required PhotoUploadResult uploadResult,
  }) {
    context.pushReplacement(
      AppRoutes.photoAnalysis,
      extra: PhotoAnalysisRouteArgs(
        imagePath: imagePath,
        uploadResult: uploadResult,
      ),
    );
  }

  static void openUploadFailure(BuildContext context, String imagePath) {
    context.pushReplacement(
      AppRoutes.photoUploadFailure,
      extra: PhotoUploadFailureRouteArgs(imagePath: imagePath),
    );
  }

  static bool openAnalysisResult(
    BuildContext context, {
    required PhotoAnalysisProgress progress,
    required String imagePath,
    required String photoId,
  }) {
    if (progress.progress < 1) return false;

    switch (progress.status) {
      case PhotoAnalysisStatus.searching:
        context.pushReplacement(
          AppRoutes.photoRecord,
          extra: PhotoRecordRouteArgs(imagePath: imagePath, photoId: photoId),
        );
        return true;
      case PhotoAnalysisStatus.rejected:
        context.pushReplacement(
          AppRoutes.photoRejected,
          extra: PhotoRejectedRouteArgs(imagePath: imagePath, photoId: photoId),
        );
        return true;
      case PhotoAnalysisStatus.validating:
        return false;
    }
  }
}
