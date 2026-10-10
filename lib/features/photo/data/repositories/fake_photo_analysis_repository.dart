import 'package:dalm/features/photo/domain/entities/photo_analysis_progress.dart';
import 'package:dalm/features/photo/domain/repositories/photo_analysis_repository.dart';

final class FakePhotoAnalysisRepository implements PhotoAnalysisRepository {
  const FakePhotoAnalysisRepository({
    this.result = PhotoAnalysisStatus.searching,
    this.stepDuration = const Duration(milliseconds: 900),
  });

  final PhotoAnalysisStatus result;
  final Duration stepDuration;

  static const _steps = [
    (progress: 0.16, activeStep: 0),
    (progress: 0.38, activeStep: 1),
    (progress: 0.64, activeStep: 1),
    (progress: 0.86, activeStep: 2),
  ];

  @override
  Stream<PhotoAnalysisProgress> watchProgress(String photoId) async* {
    for (final step in _steps) {
      yield PhotoAnalysisProgress(
        status: PhotoAnalysisStatus.validating,
        progress: step.progress,
        activeStep: step.activeStep,
      );
      await Future<void>.delayed(stepDuration);
    }

    yield PhotoAnalysisProgress(status: result, progress: 1, activeStep: 3);
  }
}
