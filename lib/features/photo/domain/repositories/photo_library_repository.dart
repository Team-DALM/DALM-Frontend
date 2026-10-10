/// 앨범 사진 선택과 중단 결과 복구 규격
abstract interface class PhotoLibraryRepository {
  Future<String?> selectPhoto();

  Future<String?> retrieveLostPhoto();
}
