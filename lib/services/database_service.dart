import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/household.dart';
import '../models/member.dart';

class DatabaseService {
  // Singleton Pattern
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static const String householdBoxName = 'households';
  static const String authBoxName = 'auth';
  static const String usersBoxName = 'users';

  static Future<void> init() async {
    if (kIsWeb) {
      // On Web, Hive uses IndexedDB. initFlutter handles this automatically.
      await Hive.initFlutter();
    } else {
      // On Mobile/Desktop, explicitly set the path to ensure persistence
      final directory = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(directory.path);
    }
    
    // Register Adapters
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(HouseholdAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(MemberAdapter());
    
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

  // Getters for boxes
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

  // Household CRUD
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

  // Diagnostics
  String get storagePath {
    if (kIsWeb) return 'Web Browser (IndexedDB)';
    try {
      return Hive.box(authBoxName).path ?? 'Path missing in box';
    } catch (e) {
      return 'Error getting path: $e';
    }
  }
}
