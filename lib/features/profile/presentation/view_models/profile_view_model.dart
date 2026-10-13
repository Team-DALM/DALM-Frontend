import 'package:dalm/features/profile/data/providers/profile_data_providers.dart';
import 'package:dalm/features/profile/domain/entities/profile_overview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileViewModelProvider =
    AsyncNotifierProvider<ProfileViewModel, ProfileOverview>(
      ProfileViewModel.new,
    );

final class ProfileViewModel extends AsyncNotifier<ProfileOverview> {
  @override
  Future<ProfileOverview> build() {
    return ref.watch(profileRepositoryProvider).getMyProfile();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider).getMyProfile(),
    );
  }
}
