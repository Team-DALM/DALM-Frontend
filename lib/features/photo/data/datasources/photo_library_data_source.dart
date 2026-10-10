import 'dart:io';

import 'package:image_picker/image_picker.dart';

/// 기기의 사진 선택 기능 접근 규격
abstract interface class PhotoLibraryDataSource {
  Future<XFile?> selectPhoto();

  Future<XFile?> retrieveLostPhoto();
}

/// 시스템 Photo Picker를 사용하는 데이터 소스
final class DevicePhotoLibraryDataSource implements PhotoLibraryDataSource {
  DevicePhotoLibraryDataSource({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  @override
  Future<XFile?> selectPhoto() {
    return _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
      requestFullMetadata: false,
    );
  }

  @override
  Future<XFile?> retrieveLostPhoto() async {
    // Android가 앱을 종료한 동안 보관한 선택 결과 복구
    if (!Platform.isAndroid) return null;

    final response = await _imagePicker.retrieveLostData();
    if (response.isEmpty) return null;

    return response.file ??
        (response.files == null || response.files!.isEmpty
            ? null
            : response.files!.first);
  }
}
