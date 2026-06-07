import 'package:hive/hive.dart';
import 'member.dart';

part 'household.g.dart';

@HiveType(typeId: 0)
class Household extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String houseNumber;

  @HiveField(2)
  String address;

  @HiveField(3)
  String locality;

  @HiveField(4)
  String headName;

  @HiveField(5)
  String phoneNumber;

  @HiveField(6)
  double latitude;

  @HiveField(7)
  double longitude;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  List<Member> members;

  Household({
    required this.id,
    required this.houseNumber,
    required this.address,
    required this.locality,
    required this.headName,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.members,
  });
}
