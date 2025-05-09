import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:teman_tumbuh/views/KonsultasiPage.dart';
import 'package:teman_tumbuh/views/cari-dokter-page.dart';
import 'package:teman_tumbuh/views/detail_artikel.dart';
import 'package:teman_tumbuh/views/detail_mpasi.dart';
import 'package:teman_tumbuh/views/kebutuhan_mpasi.dart';
import 'package:teman_tumbuh/views/konten_page.dart';
import 'package:teman_tumbuh/views/profil_page.dart';
import 'package:teman_tumbuh/views/splash_screen.dart';
import 'package:teman_tumbuh/views/tumbuh-gigi-page.dart';
import 'views/onboarding_screen.dart';
import 'views/register_screen.dart';
import 'views/login_screen.dart';
import 'views/welcome_screen.dart';
import 'views/home_without_data.dart';
import 'views/home_with_data.dart';
import 'views/add_child_screen.dart';
import 'dart:io' show Platform;
import 'services/api_service.dart';
import 'utils/auth_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Tambahkan ini untuk debugging koneksi
  if (kDebugMode) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      print('Running on desktop: ${Platform.operatingSystem}');
    } else if (Platform.isAndroid) {
      print('Running on Android');
    } else if (Platform.isIOS) {
      print('Running on iOS');
    } else {
      print('Running on unknown platform');
    }
    
    // Cek URL yang digunakan
    final apiService = ApiService();
    print('Using API URL: ${apiService.baseUrl}');
    
    // Cek koneksi server
    try {
      final isConnected = await apiService.checkServerConnection();
      print('Server connection check: ${isConnected ? 'SUCCESS' : 'FAILED'}');
    } catch (e) {
      print('Error checking server connection: $e');
    }
    
    // Cek status login
    try {
      final isLoggedIn = await AuthManager.isLoggedIn();
      print('User login status: ${isLoggedIn ? 'LOGGED IN' : 'NOT LOGGED IN'}');
    } catch (e) {
      print('Error checking login status: $e');
    }
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Teman Tumbuh',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.orange,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.orange,
          secondary: Colors.blue,
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/home_without_data': (context) => HomeWithoutData(),
        '/add_child': (context) => const AddChildScreen(),
        '/home_with_data': (context) => HomeWithData(),
        '/konsultasi': (context) => const KonsultasiPage(),
        '/konten': (context) => const KontenPage(),
        '/profil': (context) => const ProfilPage(),
        '/home': (context) => HomeWithData(),
        '/tumbuh_gigi': (context) => const TumbuhGigiPage(),
        '/cari_dokter': (context) => const CariDokterPage(),
        '/detail_mpasi': (context) => const DetailMPASIPage(),
        '/detail_artikel': (context) => const DetailArtikelPage(),
        '/kebutuhan_mpasi': (context) => const KebutuhanMPASIPage(),
      },
    );
  }
}
