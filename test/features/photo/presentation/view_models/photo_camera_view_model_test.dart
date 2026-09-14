import 'package:dalm/features/photo/domain/entities/photo_camera_permission_status.dart';
import 'package:dalm/features/photo/domain/repositories/photo_camera_repository.dart';
import 'package:dalm/features/photo/presentation/view_models/photo_camera_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('권한이 허용되면 카메라를 열고 촬영 경로를 반환한다', () async {
    final repository = _FakePhotoCameraRepository(
      permissionStatus: PhotoCameraPermissionStatus.granted,
      photoPath: '/tmp/today-photo.jpg',
    );
    final viewModel = PhotoCameraViewModel(repository);

    final result = await viewModel.requestPermissionAndTakePhoto();

    expect(result.outcome, PhotoCameraCaptureOutcome.captured);
    expect(result.photoPath, '/tmp/today-photo.jpg');
    expect(repository.takePhotoCount, 1);
  });

  test('촬영을 취소하면 취소 결과를 반환한다', () async {
    final repository = _FakePhotoCameraRepository(
      permissionStatus: PhotoCameraPermissionStatus.granted,
    );
    final viewModel = PhotoCameraViewModel(repository);

    final result = await viewModel.requestPermissionAndTakePhoto();

    expect(result.outcome, PhotoCameraCaptureOutcome.cancelled);
  });

  test('권한이 거부되면 카메라를 열지 않는다', () async {
    final repository = _FakePhotoCameraRepository(
      permissionStatus: PhotoCameraPermissionStatus.denied,
    );
    final viewModel = PhotoCameraViewModel(repository);

    final result = await viewModel.requestPermissionAndTakePhoto();

    expect(result.outcome, PhotoCameraCaptureOutcome.permissionDenied);
    expect(repository.takePhotoCount, 0);
  });

  test('카메라 처리 중 예외가 발생하면 실패 결과를 반환한다', () async {
    final repository = _FakePhotoCameraRepository(
      permissionStatus: PhotoCameraPermissionStatus.granted,
      shouldThrowWhenTakingPhoto: true,
    );
    final viewModel = PhotoCameraViewModel(repository);

    final result = await viewModel.requestPermissionAndTakePhoto();

    expect(result.outcome, PhotoCameraCaptureOutcome.failed);
  });
}

final class _FakePhotoCameraRepository implements PhotoCameraRepository {
  _FakePhotoCameraRepository({
    required this.permissionStatus,
    this.photoPath,
    this.shouldThrowWhenTakingPhoto = false,
  });

  final PhotoCameraPermissionStatus permissionStatus;
  final String? photoPath;
  final bool shouldThrowWhenTakingPhoto;

  int takePhotoCount = 0;

  @override
  Future<PhotoCameraPermissionStatus> requestPermission() async {
    return permissionStatus;
  }

  @override
  Future<String?> takePhoto() async {
    takePhotoCount += 1;
    if (shouldThrowWhenTakingPhoto) {
      throw StateError('camera failed');
    }
    return photoPath;
  }

  @override
  Future<bool> openSettings() async {
    return true;
  }
}
