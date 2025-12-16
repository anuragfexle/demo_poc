import 'package:demo_poc/dao/profile_hive_dao.dart';
import 'package:demo_poc/models/profile.dart';

class ProfileRepository {
  final ProfileHiveDao _dao;

  ProfileRepository(this._dao);

  Future<Profile?> getProfile() async {
    return _dao.getProfile();
  }

  Future<void> saveProfile(Profile profile) async {
    await _dao.saveProfile(profile);
  }
}
