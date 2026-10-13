import 'package:dalm/features/profile/domain/entities/profile_overview.dart';

abstract interface class ProfileRepository {
  Future<ProfileOverview> getMyProfile();
}
