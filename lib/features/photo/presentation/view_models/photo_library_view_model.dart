import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/photo_library_providers.dart';
import '../../domain/repositories/photo_library_repository.dart';

enum PhotoLibrarySelectionOutcome { selected, cancelled, failed }

final class PhotoLibrarySelectionResult {
  const PhotoLibrarySelectionResult(this.outcome, {this.photoPath});

  final PhotoLibrarySelectionOutcome outcome;
  final String? photoPath;
}

final photoLibraryViewModelProvider =
    Provider.autoDispose<PhotoLibraryViewModel>(
      (ref) => PhotoLibraryViewModel(ref.watch(photoLibraryRepositoryProvider)),
    );

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
