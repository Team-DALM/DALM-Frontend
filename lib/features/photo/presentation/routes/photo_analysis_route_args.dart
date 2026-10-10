import 'package:dalm/features/photo/domain/entities/photo_upload_result.dart';

final class PhotoAnalysisRouteArgs {
  const PhotoAnalysisRouteArgs({
    required this.imagePath,
    required this.uploadResult,
  });

  final String imagePath;
  final PhotoUploadResult uploadResult;
}
