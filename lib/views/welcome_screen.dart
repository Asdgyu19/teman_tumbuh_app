import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Menambahkan warna latar belakang putih
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0), // Menambahkan padding horizontal
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch, // Agar children mengisi lebar
          children: [
            // Gambar Selamat Datang
            Image.asset(
              'assets/welcome.png',
              width: 280, // Sedikit perbesar ukuran gambar
              height: 280, // Tetapkan tinggi agar proporsional
              fit: BoxFit.contain, // Memastikan gambar muat tanpa terpotong
            ),
            const SizedBox(height: 30), // Spasi setelah gambar

            // Judul Selamat Datang
            Text(
              "Selamat Datang, Bunda!", // Penulisan lebih formal & rapi
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28, // Ukuran font lebih besar
                fontWeight: FontWeight.w800, // Ketebalan font lebih kuat
                color: Colors.blue.shade700, // Warna biru yang lebih gelap
                letterSpacing: 0.5, // Sedikit spasi antar huruf
              ),
            ),
            const SizedBox(height: 10), // Spasi antara judul dan deskripsi

            // Deskripsi Aplikasi
            Text(
              "Ayo pantau tumbuh kembang si Kecil, dan berikan yang terbaik untuk masa depannya yang cerah!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16, // Ukuran font normal
                color: Colors.grey.shade600, // Warna abu-abu yang lebih lembut
                height: 1.5, // Spasi baris untuk keterbacaan
              ),
            ),
            const SizedBox(height: 40), // Spasi sebelum tombol

            // Tombol "Masuk ke Beranda"
            ElevatedButton(
              onPressed: () {
                // Fungsi navigasi tetap sama
                Navigator.pushNamed(context, '/home_without_data');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600, // Warna latar belakang tombol yang lebih menarik
                foregroundColor: Colors.white, // Warna teks tombol
                padding: const EdgeInsets.symmetric(vertical: 16), // Padding vertikal tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Sudut tombol lebih membulat
                ),
                elevation: 5, // Sedikit efek bayangan
                textStyle: const TextStyle(
                  fontSize: 18, // Ukuran teks tombol lebih besar
                  fontWeight: FontWeight.bold, // Teks tombol lebih tebal
                ),
              ),
              child: const Text("Masuk ke Beranda"),
            ),
          ],
        ),
      ),
    );
  }
}