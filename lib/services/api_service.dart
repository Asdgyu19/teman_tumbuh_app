import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

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
  
  // Method untuk mendapatkan data user yang sedang login
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getString('user_id');
      
      if (token == null || userId == null) {
        print('No token or user_id found');
        return null;
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeout);
      
      print('Get current user response status: ${response.statusCode}');
      print('Get current user response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }
  
  // Method untuk mendapatkan data user (method lama Anda)
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
  
  // Method untuk mendapatkan pertanyaan populer
  Future<List<dynamic>?> getPopularQuestions() async {
    try {
      print('Fetching popular questions from: $baseUrl/api/popular-questions');
      final response = await http.get(
        Uri.parse('$baseUrl/api/popular-questions'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);
      
      print('Popular questions response status: ${response.statusCode}');
      print('Popular questions response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Handle berbagai format response dari backend
        if (data is List) {
          return data;
        } else if (data is Map) {
          // Jika response dalam format {"data": [...]}
          if (data['data'] is List) {
            return data['data'];
          }
          // Jika response dalam format {"questions": [...]}
          else if (data['questions'] is List) {
            return data['questions'];
          }
          // Jika response dalam format {"success": true, "data": [...]}
          else if (data['success'] == true && data['data'] is List) {
            return data['data'];
          }
        }
        
        // Jika format tidak dikenali, return empty list
        print('Unknown response format for popular questions');
        return [];
      } else {
        print('Failed to fetch popular questions: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching popular questions: $e');
      return []; // Return empty list instead of null to prevent the error
    }
  }

  // Method untuk mendapatkan artikel rekomendasi
  Future<List<dynamic>?> getRecommendedArticles() async {
    try {
      print('Fetching recommended articles from: $baseUrl/api/recommended-articles');
      final response = await http.get(
        Uri.parse('$baseUrl/api/recommended-articles'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);
      
      print('Recommended articles response status: ${response.statusCode}');
      print('Recommended articles response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Handle berbagai format response dari backend
        if (data is List) {
          return data;
        } else if (data is Map) {
          // Jika response dalam format {"data": [...]}
          if (data['data'] is List) {
            return data['data'];
          }
          // Jika response dalam format {"articles": [...]}
          else if (data['articles'] is List) {
            return data['articles'];
          }
          // Jika response dalam format {"success": true, "data": [...]}
          else if (data['success'] == true && data['data'] is List) {
            return data['data'];
          }
        }
        
        // Jika format tidak dikenali, return empty list
        print('Unknown response format for recommended articles');
        return [];
      } else {
        print('Failed to fetch recommended articles: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching recommended articles: $e');
      return []; // Return empty list instead of null to prevent the error
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
}