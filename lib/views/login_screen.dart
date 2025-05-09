import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import '../utils/auth_manager.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Inisialisasi API Service
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  // Fungsi untuk memeriksa koneksi server
  Future<bool> _checkServerConnection() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      final isConnected = await _apiService.checkServerConnection();
      
      if (!isConnected && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tidak dapat terhubung ke server. Pastikan server berjalan."),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
      
      return isConnected;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Title
                  Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[500],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Email Field
                  _buildInputLabel("Email"),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Masukkan email",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  _buildInputLabel("Password"),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: "Masukkan password",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () async {
                        if (_formKey.currentState!.validate()) {
                          // Periksa koneksi server terlebih dahulu
                          final isConnected = await _checkServerConnection();
                          if (!isConnected) {
                            return; // Berhenti jika tidak terhubung
                          }
                          
                          // Tampilkan loading
                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            // Gunakan API Service untuk login
                            final response = await _apiService.login(
                              _emailController.text,
                              _passwordController.text,
                            );

                            if (!mounted) return;
                            
                            setState(() {
                              _isLoading = false;
                            });

                            if (response['success'] == true) {
                              // Login berhasil
                              final userData = response['data'];
                              
                              // Simpan data user
                              await AuthManager.saveUserData(userData);

                              // Navigasi ke halaman home
                              Navigator.pushReplacementNamed(context, '/home_with_data');
                            } else {
                              // Login gagal
                              String errorMessage = response['message'] ?? 'Login gagal';
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(errorMessage)),
                              );
                            }
                          } catch (e) {
                            if (!mounted) return;
                            
                            setState(() {
                              _isLoading = false;
                            });
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "atau",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Social Login Buttons
                  _buildSocialLoginButton(
                    icon: "assets/google_icon.png",
                    text: "Login dengan Google",
                    onPressed: () {
                      // Handle Google login
                    },
                  ),

                  const SizedBox(height: 12),

                  _buildSocialLoginButton(
                    icon: "assets/facebook_icon.png",
                    text: "Login dengan Facebook",
                    onPressed: () {
                      // Handle Facebook login
                    },
                  ),

                  const SizedBox(height: 12),

                  _buildSocialLoginButton(
                    icon: "assets/apple_icon.png",
                    text: "Login dengan Apple ID",
                    onPressed: () {
                      // Handle Apple login
                    },
                  ),

                  const SizedBox(height: 24),

                  // Register Link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum memiliki akun? ",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            "Daftar",
                            style: TextStyle(
                              color: Colors.blue[500],
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton({
    required String icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
