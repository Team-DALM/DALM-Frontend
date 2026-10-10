import 'package:dalm/core/config/app_config.dart';
import 'package:dalm/features/photo/data/repositories/fake_photo_analysis_repository.dart';
import 'package:dalm/features/photo/data/repositories/pending_photo_analysis_repository.dart';
import 'package:dalm/features/photo/domain/entities/photo_analysis_progress.dart';
import 'package:dalm/features/photo/domain/repositories/photo_analysis_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final photoAnalysisRepositoryProvider = Provider<PhotoAnalysisRepository>((
  ref,
) {
  if (kDebugMode && AppConfig.useFakePhotoAnalysis) {
    final result = AppConfig.fakePhotoAnalysisResult == 'REJECTED'
        ? PhotoAnalysisStatus.rejected
        : PhotoAnalysisStatus.searching;
    return FakePhotoAnalysisRepository(result: result);
  }

  return const PendingPhotoAnalysisRepository();
});

final photoAnalysisProgressProvider = StreamProvider.autoDispose
    .family<PhotoAnalysisProgress, String>((ref, photoId) {
      return ref.watch(photoAnalysisRepositoryProvider).watchProgress(photoId);
    });
