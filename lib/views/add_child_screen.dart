import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import untuk melakukan request HTTP
import 'dart:convert'; // Import untuk encoding/decoding JSON
import 'package:teman_tumbuh/models/child.dart'; // Import model Child yang sudah kamu buat

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  // TextEditingController untuk mengelola input dari TextField
  final TextEditingController nikController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  // URL base untuk API Golang kamu.
  // PENTING: Ganti 'http://<IP_KOMPUTER_KAMU_ATAU_LOCALHOST>:8080/api'
  // dengan IP lokal komputermu jika menggunakan emulator/perangkat fisik (misal: http://192.168.1.5:8080/api)
  // atau biarkan 'localhost' jika menjalankan di web browser.
  final String _baseUrl =  'http://localhost:8080/api'; 

  @override
  void dispose() {
    // Pastikan controller di-dispose untuk mencegah memory leaks
    nikController.dispose();
    nameController.dispose();
    dobController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengirim data anak ke backend Go
  Future<void> _submitChildData() async {
    // Mengambil teks dari controller dan menghapus spasi di awal/akhir
    final String nik = nikController.text.trim();
    final String name = nameController.text.trim();
    final String dob = dobController.text.trim();

    // Validasi input: pastikan semua field tidak kosong
    if (nik.isEmpty || name.isEmpty || dob.isEmpty) {
      _showSnackBar('Harap lengkapi semua data.', Colors.red);
      return; // Berhenti jika ada field yang kosong
    }

    try {
      // Melakukan HTTP POST request ke endpoint /api/children
      final response = await http.post(
        Uri.parse('$_baseUrl/children'), // URL lengkap endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8', // Header untuk tipe konten JSON
        },
        body: jsonEncode(<String, String>{
          'nik': nik,
          'name': name,
          'dob': dob,
        }), // Mengubah Map Dart menjadi String JSON
      );

      // Memeriksa status code respons dari server
      if (response.statusCode == 201) {
        // Jika berhasil (status code 201 Created)
        final responseData = jsonDecode(response.body); // Dekode respons JSON
        // Pastikan 'data' ada dan merupakan Map<String, dynamic>
        if (responseData['success'] == true && responseData['data'] is Map<String, dynamic>) {
          // Buat objek Child dari data yang diterima
          final Child newChild = Child.fromJson(responseData['data']);
          _showSnackBar('Data anak berhasil ditambahkan!', Colors.green);

          // Navigasi ke halaman HomeWithData dan kirim objek newChild sebagai argumen
          // pushReplacementNamed digunakan agar halaman AddChildScreen tidak bisa di-back
          Navigator.pushReplacementNamed(
            context,
            '/home_with_data',
            arguments: newChild, // Mengirim objek Child ke halaman berikutnya
          );
        } else {
          // Jika respons dari server tidak valid meskipun status code 201
          _showSnackBar('Respons dari server tidak valid: ${responseData['message'] ?? 'Unknown error'}', Colors.red);
          print('Invalid response data structure or success status: $responseData');
        }
      } else {
        // Jika gagal (status code selain 201)
        final errorData = jsonDecode(response.body); // Dekode respons error
        _showSnackBar(
          'Gagal menambahkan data anak: ${errorData['message'] ?? 'Unknown error'}',
          Colors.red,
        );
        print('Error response status: ${response.statusCode}, body: ${response.body}');
      }
    } catch (e) {
      // Menangkap error jaringan atau error lainnya
      _showSnackBar('Terjadi kesalahan jaringan: $e', Colors.red);
      print('Error submitting data: $e');
    }
  }

  // Fungsi pembantu untuk menampilkan Snackbar
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2), // Durasi tampilnya snackbar
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah profil anak'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Kembali ke halaman sebelumnya
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input NIK
            const Text("Input NIK", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextField(
              controller: nikController,
              keyboardType: TextInputType.number, // Hanya menerima angka
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '123456789',
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "NIK digunakan untuk mengintegrasikan data anak Anda yang sudah tersimpan di Posyandu",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Input Nama
            const Text("Nama", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Agnesti Wulansari',
              ),
            ),
            const SizedBox(height: 20),

            // Input Tanggal Lahir (menggunakan DatePicker)
            const Text("Tanggal Lahir", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextField(
              controller: dobController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '10 September 2024',
              ),
              readOnly: true, // Membuat TextField tidak bisa diketik langsung
              onTap: () async {
                // Menampilkan DatePicker saat TextField diklik
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(), // Tanggal awal yang ditampilkan
                  firstDate: DateTime(2000), // Batas tanggal paling awal
                  lastDate: DateTime(2101), // Batas tanggal paling akhir
                );

                // Jika tanggal dipilih, update teks di TextField
                if (pickedDate != null) {
                  setState(() {
                    dobController.text =
                        "${pickedDate.day} ${_getMonthName(pickedDate.month)} ${pickedDate.year}";
                  });
                }
              },
            ),
            const Spacer(), // Mendorong widget ke bawah

            // Tombol "Submit data"
            SizedBox(
              width: double.infinity, // Membuat tombol mengisi lebar penuh
              child: ElevatedButton(
                onPressed: _submitChildData, // Panggil fungsi submit
                child: const Text("Submit data"),
              ),
            ),

            // Tombol "Masukkan data manual"
            Align( // Agar tombol berada di tengah atau sesuai keinginan
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  // TODO: Implementasi navigasi ke form manual jika ada
                  _showSnackBar('Fitur "Masukkan data manual" belum diimplementasikan.', Colors.orange);
                },
                // Hapus onLongPress jika tidak diperlukan
                // onLongPress: () { /* ... */ }, 
                child: const Text("Masukkan data manual"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi pembantu untuk mendapatkan nama bulan dari angka bulan
  String _getMonthName(int month) {
    const monthNames = [
      "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    return monthNames[month - 1]; // Array dimulai dari 0, bulan dari 1
  }
}