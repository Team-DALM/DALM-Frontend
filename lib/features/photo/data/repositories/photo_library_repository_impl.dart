import '../../domain/repositories/photo_library_repository.dart';
import '../datasources/photo_library_data_source.dart';

/// 선택된 사진 파일을 앱에서 사용할 경로로 변환하는 저장소
final class PhotoLibraryRepositoryImpl implements PhotoLibraryRepository {
  const PhotoLibraryRepositoryImpl(this._dataSource);

  final PhotoLibraryDataSource _dataSource;

  @override
  Future<String?> selectPhoto() async {
    return (await _dataSource.selectPhoto())?.path;
  }

  @override
  Future<String?> retrieveLostPhoto() async {
    return (await _dataSource.retrieveLostPhoto())?.path;
  }
}
