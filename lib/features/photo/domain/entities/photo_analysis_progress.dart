enum PhotoAnalysisStatus { validating, searching, rejected }

final class PhotoAnalysisProgress {
  const PhotoAnalysisProgress({
    required this.status,
    required this.progress,
    required this.activeStep,
  });

  final PhotoAnalysisStatus status;
  final double progress;
  final int activeStep;

  bool get isComplete => status != PhotoAnalysisStatus.validating;
}
