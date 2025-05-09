// main.dart (updated routes)
import 'package:flutter/material.dart';
import 'package:teman_tumbuh/views/KonsultasiPage.dart';
import 'package:teman_tumbuh/views/cari-dokter-page.dart';
import 'package:teman_tumbuh/views/detail_artikel.dart';
import 'package:teman_tumbuh/views/detail_mpasi.dart';
import 'package:teman_tumbuh/views/kebutuhan_mpasi.dart';
import 'package:teman_tumbuh/views/konten_page.dart';
import 'package:teman_tumbuh/views/profil_page.dart';
import 'package:teman_tumbuh/views/splash_screen.dart'; // Import the splash screen
import 'package:teman_tumbuh/views/tumbuh-gigi-page.dart';
import 'views/onboarding_screen.dart';
import 'views/register_screen.dart';
import 'views/login_screen.dart';
import 'views/welcome_screen.dart';
import 'views/home_without_data.dart';
import 'views/home_with_data.dart';
import 'views/add_child_screen.dart';

void main() {
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
      initialRoute: '/splash', // Change initial route to splash screen
      routes: {
        '/splash': (context) => const SplashScreen(), // Add splash screen route
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
        '/home': (context) => HomeWithData(), // atau HomeWithoutData()
        '/tumbuh_gigi': (context) => const TumbuhGigiPage(),
        '/cari_dokter': (context) => const CariDokterPage(),
        '/detail_mpasi': (context) => const DetailMPASIPage(),
        '/detail_artikel': (context) => const DetailArtikelPage(),
        '/kebutuhan_mpasi': (context) => const KebutuhanMPASIPage(),
      },
    );
  }
}