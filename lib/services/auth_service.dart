class AuthService {
  // Mock login
  static Future<bool> login(String id, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    if (id == 'admin' && password == 'admin123') {
      return true;
    }
    return false;
  }
}
