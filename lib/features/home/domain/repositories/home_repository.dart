import '../entities/home_overview.dart';

abstract interface class HomeRepository {
  Future<HomeOverview> getHomeOverview();
}
