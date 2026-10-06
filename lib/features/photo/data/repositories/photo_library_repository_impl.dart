import '../../domain/repositories/photo_library_repository.dart';
import '../datasources/photo_library_data_source.dart';

final class PhotoLibraryRepositoryImpl implements PhotoLibraryRepository {
  const PhotoLibraryRepositoryImpl(this._dataSource);

  final PhotoLibraryDataSource _dataSource;

  @override
  Future<String?> selectPhoto() async {
    return (await _dataSource.selectPhoto())?.path;
  }
}
