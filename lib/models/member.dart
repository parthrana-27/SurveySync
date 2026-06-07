import 'package:hive/hive.dart';

part 'member.g.dart';

@HiveType(typeId: 1)
class Member extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int age;

  @HiveField(3)
  String gender;

  @HiveField(4)
  String education;

  @HiveField(5)
  String occupation;

  @HiveField(6)
  String maritalStatus;

  Member({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.education,
    required this.occupation,
    required this.maritalStatus,
  });
}
