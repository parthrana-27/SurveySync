import 'package:hive_flutter/hive_flutter.dart';
import '../models/household.dart';
import '../models/member.dart';

class DatabaseService {
  static const String householdBoxName = 'households';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    Hive.registerAdapter(HouseholdAdapter());
    Hive.registerAdapter(MemberAdapter());
    
    // Open Boxes
    await Hive.openBox<Household>(householdBoxName);
  }

  Box<Household> get householdBox => Hive.box<Household>(householdBoxName);

  List<Household> getAllHouseholds() {
    return householdBox.values.toList();
  }

  Future<void> addHousehold(Household household) async {
    await householdBox.put(household.id, household);
  }

  Future<void> updateHousehold(Household household) async {
    await household.save();
  }

  Future<void> deleteHousehold(String id) async {
    await householdBox.delete(id);
  }

  Future<void> clearAll() async {
    await householdBox.clear();
  }
}
