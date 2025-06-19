import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../models/doctor.dart';

class ChatService {
  static const String baseUrl = 'http://localhost:8081';
  String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080'; // Untuk Android Emulator
      // return 'http://192.168.1.100:8080'; // Ganti dengan IP komputer Anda untuk device fisik
    } else if (Platform.isIOS) {
      return 'http://localhost:8080'; // Untuk iOS Simulator
      // return 'http://192.168.1.100:8080'; // Ganti dengan IP komputer Anda untuk device fisik
    } else {
      return 'http://localhost:8080';
    }
  }

  final uuid = Uuid();
  
  // 🆕 Timeout untuk request
  static const Duration _timeout = Duration(seconds: 30);

  // 🆕 Method untuk test koneksi ke server
  Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);
      
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Connection test failed: $e');
      return false;
    }
  }

  // Mendapatkan respons dari OpenAI melalui backend Go
  Future<ChatMessage> getDoctorResponse(
      String doctorId, String doctorName, String userMessage) async {
    try {
      debugPrint('🔄 Sending request to: $_baseUrl/api/chat/doctor');
      debugPrint('📤 Request data: doctor_id=$doctorId, message=$userMessage');

      final response = await http.post(
        Uri.parse('$_baseUrl/api/chat/doctor'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'doctor_id': doctorId,
          'user_message': userMessage,
        }),
      ).timeout(_timeout);

      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // 🔍 Validasi struktur response
        if (data['success'] == true && data['data'] != null && data['data']['response'] != null) {
          return ChatMessage(
            id: uuid.v4(),
            content: data['data']['response'],
            senderId: doctorId,
            senderName: doctorName,
            senderType: 'doctor',
            timestamp: DateTime.now(),
          );
        } else {
          throw Exception('Invalid response format: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        // 🚨 Handle different error status codes
        final errorData = jsonDecode(response.body);
        String errorMessage = 'Server error';
        
        if (errorData['message'] != null) {
          errorMessage = errorData['message'];
        }
        
        throw Exception('Server error (${response.statusCode}): $errorMessage');
      }
    } on http.ClientException catch (e) {
      debugPrint('❌ Network error: $e');
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } on FormatException catch (e) {
      debugPrint('❌ JSON parsing error: $e');
      throw Exception('Format respons server tidak valid.');
    } on Exception catch (e) {
      debugPrint('❌ General error: $e');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unknown error: $e');
      throw Exception('Terjadi kesalahan yang tidak diketahui: $e');
    }
  }

  // 🆕 Method untuk mendapatkan daftar dokter
  Future<List<Doctor>> getDoctors() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/doctors'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          List<dynamic> doctorsJson = data['data'];
          return doctorsJson.map((json) => Doctor.fromJson(json)).toList();
        }
      }
      
      // Return default doctors jika API belum tersedia
      return _getDefaultDoctors();
    } catch (e) {
      debugPrint('Error getting doctors: $e');
      // Return default doctors jika error
      return _getDefaultDoctors();
    }
  }

  // 🆕 Default doctors (fallback)
  List<Doctor> _getDefaultDoctors() {
    return [
      Doctor(
        id: 'doctor-1',
        name: 'Dr. Aryo Prabowo',
        specialty: 'Dokter Umum',
        rating: 4.8,
        price: 89000,
        imageUrl: 'assets/images/doctor1.jpg',
      ),
      Doctor(
        id: 'doctor-2',
        name: 'Dr. Ricardo',
        specialty: 'Spesialis Anak (Pediatri)',
        rating: 4.7,
        price: 70000,
        imageUrl: 'assets/images/doctor2.jpg',
      ),
      Doctor(
        id: 'doctor-3',
        name: 'Dr. Doktif',
        specialty: 'Dokter Umum',
        rating: 4.5,
        price: 65000,
        imageUrl: 'assets/images/doctor3.jpg',
      ),
    ];
  }

  // Menyimpan riwayat chat ke backend (opsional)
  Future<void> saveChatHistory(String userId, String doctorId, List<ChatMessage> messages) async {
    try {
      debugPrint('💾 Saving chat history for user: $userId, doctor: $doctorId');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/api/chat/history'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'doctor_id': doctorId,
          'messages': messages.map((m) => m.toJson()).toList(),
        }),
      ).timeout(_timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Chat history saved successfully');
      } else {
        debugPrint('⚠️ Failed to save chat history: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error saving chat history: $e');
      // Tidak throw error karena ini optional
    }
  }

  // 🆕 Method untuk mendapatkan riwayat chat
  Future<List<ChatMessage>> getChatHistory(String userId, String doctorId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/chat/history?user_id=$userId&doctor_id=$doctorId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          List<dynamic> messagesJson = data['data'];
          return messagesJson.map((json) => ChatMessage.fromJson(json)).toList();
        }
      }
      
      return [];
    } catch (e) {
      debugPrint('Error getting chat history: $e');
      return [];
    }
  }

  // 🆕 Method untuk validasi input sebelum mengirim
  String? validateMessage(String message) {
    if (message.trim().isEmpty) {
      return 'Pesan tidak boleh kosong';
    }
    
    if (message.trim().length < 3) {
      return 'Pesan terlalu pendek (minimal 3 karakter)';
    }
    
    if (message.trim().length > 500) {
      return 'Pesan terlalu panjang (maksimal 500 karakter)';
    }
    
    return null; // Valid
  }

  // 🆕 Method untuk format error message yang user-friendly
  String getErrorMessage(Exception error) {
    String errorString = error.toString();
    
    if (errorString.contains('Network error') || errorString.contains('ClientException')) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
    } else if (errorString.contains('timeout')) {
      return 'Koneksi timeout. Silakan coba lagi.';
    } else if (errorString.contains('Server error (500)')) {
      return 'Server sedang mengalami gangguan. Silakan coba lagi nanti.';
    } else if (errorString.contains('Server error (404)')) {
      return 'Layanan tidak ditemukan. Hubungi administrator.';
    } else {
      return 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }
}
