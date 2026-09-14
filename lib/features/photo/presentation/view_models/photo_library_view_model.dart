import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/photo_library_providers.dart';
import '../../domain/entities/photo_library_permission_status.dart';
import '../../domain/repositories/photo_library_repository.dart';

enum PhotoLibrarySelectionOutcome {
  selected,
  cancelled,
  permissionDenied,
  permissionPermanentlyDenied,
  permissionRestricted,
  failed,
}

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

  Future<PhotoLibraryPermissionStatus> checkPermission() {
    return _repository.checkPermission();
  }

  Future<PhotoLibrarySelectionResult> requestAllAndSelectPhoto() async {
    try {
      final permission = await _repository.requestPermission();
      return switch (permission) {
        PhotoLibraryPermissionStatus.granted ||
        PhotoLibraryPermissionStatus.limited => await _selectPhoto(),
        PhotoLibraryPermissionStatus.denied =>
          const PhotoLibrarySelectionResult(
            PhotoLibrarySelectionOutcome.permissionDenied,
          ),
        PhotoLibraryPermissionStatus.permanentlyDenied =>
          const PhotoLibrarySelectionResult(
            PhotoLibrarySelectionOutcome.permissionPermanentlyDenied,
          ),
        PhotoLibraryPermissionStatus.restricted =>
          const PhotoLibrarySelectionResult(
            PhotoLibrarySelectionOutcome.permissionRestricted,
          ),
      };
    } catch (_) {
      return const PhotoLibrarySelectionResult(
        PhotoLibrarySelectionOutcome.failed,
      );
    }
  }

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

  Future<bool> openSettings() => _repository.openSettings();
}
