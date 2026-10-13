import 'package:dalm/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:dalm/features/profile/domain/entities/profile_overview.dart';
import 'package:dalm/features/profile/domain/repositories/profile_repository.dart';

final class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<ProfileOverview> getMyProfile() async {
    final dto = await _remoteDataSource.getMyProfile();

    return ProfileOverview(
      id: dto.id,
      nickname: dto.nickname,
      createdAt: dto.createdAt,
      photoCount: dto.photoCount,
      matchCount: dto.matchCount,
      receivedPostcardCount: dto.receivedPostcardCount,
    );
  }
}
