import 'package:dalm/features/photo/domain/entities/photo_analysis_progress.dart';
import 'package:dalm/features/photo/domain/repositories/photo_analysis_repository.dart';

final class PendingPhotoAnalysisRepository implements PhotoAnalysisRepository {
  const PendingPhotoAnalysisRepository();

  @override
  Stream<PhotoAnalysisProgress> watchProgress(String photoId) {
    return Stream.value(
      const PhotoAnalysisProgress(
        status: PhotoAnalysisStatus.validating,
        progress: 0,
        activeStep: 0,
      ),
    );
  }
}
