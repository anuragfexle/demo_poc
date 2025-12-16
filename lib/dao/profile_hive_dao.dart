import 'package:demo_poc/constants/db_store.dart';
import 'package:demo_poc/models/profile.dart';
import 'package:hive/hive.dart';

class ProfileHiveDao {
  Box<Profile> get _box => Hive.box<Profile>(kProfileBoxName);
  final String _profileKey = 'user_profile';

  Profile? getProfile() {
    return _box.get(_profileKey);
  }

  Future<void> saveProfile(Profile profile) async {
    await _box.put(_profileKey, profile);
  }
}
