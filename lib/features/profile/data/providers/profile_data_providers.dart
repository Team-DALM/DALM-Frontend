import 'package:dalm/core/network/dio_provider.dart';
import 'package:dalm/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:dalm/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:dalm/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  return DioProfileRemoteDataSource(ref.watch(dioProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(profileRemoteDataSourceProvider));
});
