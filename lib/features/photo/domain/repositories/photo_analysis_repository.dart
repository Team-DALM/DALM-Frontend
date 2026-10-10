import '../entities/photo_analysis_progress.dart';

abstract interface class PhotoAnalysisRepository {
  Stream<PhotoAnalysisProgress> watchProgress(String photoId);
}
