import 'database_service.dart';

class AuthService {
  static final DatabaseService _dbService = DatabaseService();

  // Login
  static Future<bool> login(String id, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    if (_dbService.validateUser(id, password)) {
      await _dbService.saveLogin(id);
      return true;
    }
    return false;
  }

  // Sign Up
  static Future<bool> signUp(String id, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    return await _dbService.registerUser(id, password);
  }

  static Future<void> logout() async {
    await _dbService.logout();
  }

  static bool get isLoggedIn => _dbService.isLoggedIn;
  static String? get enumeratorId => _dbService.enumeratorId;
}
