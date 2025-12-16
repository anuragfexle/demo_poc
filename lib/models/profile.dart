import 'package:hive/hive.dart';

part 'profile.g.dart';

@HiveType(typeId: 2)
class Profile extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String age;

  @HiveField(2)
  final String gender;

  @HiveField(3)
  final String mobileNumber;

  @HiveField(4)
  final String? profilePhotoPath;

  Profile({
    required this.name,
    required this.age,
    required this.gender,
    required this.mobileNumber,
    this.profilePhotoPath,
  });

  Profile copyWith({
    String? name,
    String? age,
    String? gender,
    String? mobileNumber,
    String? profilePhotoPath,
  }) {
    return Profile(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
    );
  }
}
