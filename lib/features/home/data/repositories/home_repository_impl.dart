import '../../domain/entities/home_overview.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';
import '../mappers/home_mapper.dart';

final class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<HomeOverview> getHomeOverview() async {
    // 세 요청을 먼저 시작한다.
    final todayFuture = _remoteDataSource.getToday();
    final searchingFuture = _remoteDataSource.getSearchingMoments();
    final recentMatchFuture = _remoteDataSource.getRecentMatch();

    // 각 API 응답을 기다린다.
    final todayData = await todayFuture;
    final searchingData = await searchingFuture;
    final recentMatchData = await recentMatchFuture;

    // DTO 3개를 화면에서 사용할 HomeOverview로 변환한다.
    return HomeMapper.toHomeOverview(
      todayData: todayData,
      searchingData: searchingData,
      recentMatchData: recentMatchData,
    );
  }
}
