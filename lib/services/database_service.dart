import 'package:hive_flutter/hive_flutter.dart';
import '../models/household.dart';
import '../models/member.dart';

class DatabaseService {
  static const String householdBoxName = 'households';
  static const String authBoxName = 'auth';
  static const String usersBoxName = 'users';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    Hive.registerAdapter(HouseholdAdapter());
    Hive.registerAdapter(MemberAdapter());
    
    // Open Boxes
    await Hive.openBox<Household>(householdBoxName);
    await Hive.openBox(authBoxName);
    await Hive.openBox(usersBoxName);

    // Add default admin if not exists
    final users = Hive.box(usersBoxName);
    if (users.isEmpty) {
      await users.put('admin', 'admin123');
    }
  }

  Box<Household> get householdBox => Hive.box<Household>(householdBoxName);
  Box get authBox => Hive.box(authBoxName);
  Box get usersBox => Hive.box(usersBoxName);

  // User management
  Future<bool> registerUser(String id, String password) async {
    if (usersBox.containsKey(id)) return false;
    await usersBox.put(id, password);
    return true;
  }

  bool validateUser(String id, String password) {
    return usersBox.get(id) == password;
  }

  // Auth methods
  Future<void> saveLogin(String enumeratorId) async {
    await authBox.put('isLoggedIn', true);
    await authBox.put('enumeratorId', enumeratorId);
  }

  Future<void> logout() async {
    await authBox.put('isLoggedIn', false);
    await authBox.put('enumeratorId', null);
  }

  bool get isLoggedIn => authBox.get('isLoggedIn', defaultValue: false);
  String? get enumeratorId => authBox.get('enumeratorId');

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
