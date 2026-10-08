import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/photo_library_providers.dart';
import '../../domain/repositories/photo_library_repository.dart';

/// 앨범 사진 선택의 최종 결과
enum PhotoLibrarySelectionOutcome { selected, cancelled, failed }

/// 앨범 선택 결과와 성공 시 사진 경로
final class PhotoLibrarySelectionResult {
  const PhotoLibrarySelectionResult(this.outcome, {this.photoPath});

  final PhotoLibrarySelectionOutcome outcome;
  final String? photoPath;
}

final photoLibraryViewModelProvider =
    Provider.autoDispose<PhotoLibraryViewModel>(
      (ref) => PhotoLibraryViewModel(ref.watch(photoLibraryRepositoryProvider)),
    );

/// 앨범 사진 선택과 중단된 선택 결과 복구 제어
final class PhotoLibraryViewModel {
  const PhotoLibraryViewModel(this._repository);

  final PhotoLibraryRepository _repository;

  Future<PhotoLibrarySelectionResult> selectPhoto() async {
    try {
      return await _selectPhoto();
    } catch (_) {
      return const PhotoLibrarySelectionResult(
        PhotoLibrarySelectionOutcome.failed,
      );
    }
  }

  Future<PhotoLibrarySelectionResult> recoverLostPhoto() async {
    try {
      final photoPath = await _repository.retrieveLostPhoto();
      if (photoPath == null) {
        return const PhotoLibrarySelectionResult(
          PhotoLibrarySelectionOutcome.cancelled,
        );
      }

      return PhotoLibrarySelectionResult(
        PhotoLibrarySelectionOutcome.selected,
        photoPath: photoPath,
      );
    } catch (_) {
      return const PhotoLibrarySelectionResult(
        PhotoLibrarySelectionOutcome.failed,
      );
    }
  }

  Future<PhotoLibrarySelectionResult> _selectPhoto() async {
    final photoPath = await _repository.selectPhoto();
    if (photoPath == null) {
      return const PhotoLibrarySelectionResult(
        PhotoLibrarySelectionOutcome.cancelled,
      );
    }
    return PhotoLibrarySelectionResult(
      PhotoLibrarySelectionOutcome.selected,
      photoPath: photoPath,
    );
  }
}
