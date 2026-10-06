import 'package:image_picker/image_picker.dart';

abstract interface class PhotoLibraryDataSource {
  Future<XFile?> selectPhoto();
}

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
}
