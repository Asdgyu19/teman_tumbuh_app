import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  // Base URL dari API Go
  final String baseUrl;
  
  // Tambahkan timeout yang lebih lama
  final Duration timeout;
  
  // Constructor dengan deteksi platform
  ApiService({String? baseUrl, this.timeout = const Duration(seconds: 30)}) 
      : baseUrl = baseUrl ?? _getDefaultBaseUrl();
  
  // Method untuk mendapatkan base URL default berdasarkan platform
  static String _getDefaultBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:8080'; // Web
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080'; // Emulator Android
    } else if (Platform.isIOS) {
      return 'http://localhost:8080'; // Simulator iOS
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return 'http://localhost:8080'; // Desktop
    } else {
      return 'http://localhost:8080'; // Default
    }
  }
  
  // Method untuk register
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      print('Attempting to register with URL: $baseUrl/api/register');
      final response = await http.post(
        Uri.parse('$baseUrl/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      ).timeout(timeout);
      
      print('Register response status: ${response.statusCode}');
      print('Register response body: ${response.body}');
      
      return jsonDecode(response.body);
    } catch (e) {
      // Tangani error dengan lebih baik
      print('Error during registration: $e');
      return {
        'success': false,
        'message': 'Gagal terhubung ke server: ${e.toString()}',
      };
    }
  }
  
  // Method untuk login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Attempting to login with URL: $baseUrl/api/login');
      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(timeout);
      
      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');
      
      return jsonDecode(response.body);
    } catch (e) {
      // Tangani error dengan lebih baik
      print('Error during login: $e');
      return {
        'success': false,
        'message': 'Gagal terhubung ke server: ${e.toString()}',
      };
    }
  }
  
  // Method untuk mendapatkan data user
  Future<Map<String, dynamic>> getUser() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/user'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);
      
      return jsonDecode(response.body);
    } catch (e) {
      // Tangani error dengan lebih baik
      print('Error getting user data: $e');
      return {
        'success': false,
        'message': 'Gagal terhubung ke server: ${e.toString()}',
      };
    }
  }
  
  // Method untuk memeriksa koneksi server
  Future<bool> checkServerConnection() async {
    try {
      print('Checking server connection at: $baseUrl');
      final response = await http.get(
        Uri.parse(baseUrl),
      ).timeout(const Duration(seconds: 5));
      
      print('Server check response status: ${response.statusCode}');
      print('Server check response body: ${response.body}');
      
      return response.statusCode == 200;
    } catch (e) {
      print('Server connection check failed: $e');
      return false;
    }
  }

  getPopularQuestions() {}

  getRecommendedArticles() {}
}
