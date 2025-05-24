import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  get baseUrl => null;

  // Method untuk mendapatkan data user yang sedang login
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      // Implementasi sesuai dengan sistem auth Anda
      // Contoh jika menggunakan SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      
      if (userId != null) {
        // Fetch user data dari API atau database
        final response = await http.get(
          Uri.parse('$baseUrl/user/$userId'),
          headers: {'Authorization': 'Bearer ${prefs.getString('token')}'},
        );
        
        if (response.statusCode == 200) {
          return json.decode(response.body);
        }
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }
}