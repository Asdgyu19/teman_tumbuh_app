import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthManager {
  static const String _userKey = 'user_data';
  static final _secureStorage = FlutterSecureStorage();
  
  // Menyimpan data user setelah login
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _secureStorage.write(key: _userKey, value: jsonEncode(userData));
  }
  
  // Mendapatkan data user yang tersimpan
  static Future<Map<String, dynamic>?> getUserData() async {
    final userString = await _secureStorage.read(key: _userKey);
    
    if (userString == null) {
      return null;
    }
    
    return jsonDecode(userString) as Map<String, dynamic>;
  }
  
  // Cek apakah user sudah login
  static Future<bool> isLoggedIn() async {
    final userData = await getUserData();
    return userData != null;
  }
  
  // Logout
  static Future<void> logout() async {
    await _secureStorage.delete(key: _userKey);
  }
}
