import 'package:flutter/material.dart';
import 'package:teman_tumbuh/widgets/custom_buttom_navbar.dart';
import 'package:teman_tumbuh/models/child.dart'; // Import Child model yang sudah kamu buat

class HomeWithData extends StatelessWidget {
  // Properti untuk menerima data Child dari halaman sebelumnya (AddChildScreen)
  // `?` menandakan bahwa childData bisa null (jika halaman diakses langsung tanpa data)
  final Child? childData;

  // Constructor untuk menginisialisasi childData
  const HomeWithData({super.key, this.childData});

  // Fungsi helper untuk menghitung umur anak dari tanggal lahir (DOB)
  String _calculateAge(String? dobString) {
    // Jika dobString kosong atau null, kembalikan pesan default
    if (dobString == null || dobString.isEmpty) {
      return "Umur tidak tersedia";
    }
    try {
      // Memparsing tanggal lahir dari format "DD Month YYYY"
      final parts = dobString.split(' ');
      if (parts.length != 3) {
        return "Format tanggal salah"; // Jika format tidak sesuai
      }

      final day = int.parse(parts[0]);
      final monthName = parts[1];
      final year = int.parse(parts[2]);

      int monthNumber;
      // Konversi nama bulan ke angka bulan
      switch (monthName) {
        case "Januari":
          monthNumber = 1;
          break;
        case "Februari":
          monthNumber = 2;
          break;
        case "Maret":
          monthNumber = 3;
          break;
        case "April":
          monthNumber = 4;
          break;
        case "Mei":
          monthNumber = 5;
          break;
        case "Juni":
          monthNumber = 6;
          break;
        case "Juli":
          monthNumber = 7;
          break;
        case "Agustus":
          monthNumber = 8;
          break;
        case "September":
          monthNumber = 9;
          break;
        case "Oktober":
          monthNumber = 10;
          break;
        case "November":
          monthNumber = 11;
          break;
        case "Desember":
          monthNumber = 12;
          break;
        default:
          return "Bulan tidak valid"; // Jika nama bulan tidak dikenal
      }

      final DateTime dob = DateTime(year, monthNumber, day);
      final DateTime now = DateTime.now();

      int years = now.year - dob.year;
      int months = now.month - dob.month;
      int days = now.day - dob.day;

      // Sesuaikan bulan dan tahun jika hari atau bulan kurang dari 0
      if (days < 0) {
        months--;
        // Menghitung jumlah hari di bulan sebelumnya
        days += DateTime(now.year, now.month, 0).day;
      }
      if (months < 0) {
        years--;
        months += 12;
      }

      String ageText = "";
      if (years > 0) {
        ageText += "$years tahun ";
      }
      if (months > 0) {
        ageText += "$months bulan";
      }
      // Jika tahun dan bulan 0, tampilkan hari saja
      if (years == 0 && months == 0) {
        ageText = "$days hari";
      }

      // Menghilangkan spasi ekstra dan memberikan default jika kosong
      return ageText.trim().isEmpty ? "Kurang dari sehari" : ageText.trim();
    } catch (e) {
      // Tangani error jika parsing tanggal gagal
      print("Error parsing DOB: $e");
      return "Umur tidak valid";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data anak dari argumen Route (jika ada) atau dari properti childData
    // `ModalRoute.of(context)?.settings.arguments` mengambil data yang dikirim dengan `Navigator.pushNamed`
    final Child? receivedChild =
        childData ?? ModalRoute.of(context)?.settings.arguments as Child?;

    // Tentukan nilai default jika tidak ada data anak yang diterima
    // Ini penting agar aplikasi tidak crash jika tidak ada data anak
    final String childName = receivedChild?.name ?? "Nama Anak (Default)";
    final String childAge = _calculateAge(receivedChild?.dob);
    final String childNIK = receivedChild?.nik ?? "NIK tidak tersedia";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // AppBar ini bisa dihilangkan atau disesuaikan jika ingin mirip Home Screen
        title: const Text('Beranda'),
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Profil Anak
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/profile_picture1.png'), // Pastikan gambar ini ada di folder assets
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          childName, // Menampilkan nama anak yang dinamis
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          childAge, // Menampilkan umur anak yang dihitung dinamis
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          "NIK: $childNIK", // Menampilkan NIK anak
                          style: const TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Colors.blue),
                      onPressed: () {
                        // TODO: Tambahkan navigasi atau fungsi notifikasi
                      },
                    )
                  ],
                ),
              ),

              // Bagian "Kesehatan hari ini"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue[50],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/baby_icon.png', // Pastikan gambar ini ada di folder assets
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Bagaimana kabar $childName hari ini?", // Nama anak dinamis di sini juga
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Update kondisi harian kecil untuk saran aktivitas",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Aksi saat "Kurang Baik" ditekan
                            },
                            icon: const Icon(Icons.sentiment_dissatisfied, size: 16),
                            label: const Text("Kurang Baik"),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              foregroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Aksi saat "Baik" ditekan
                            },
                            icon: const Icon(Icons.sentiment_satisfied_alt, size: 16),
                            label: const Text("Baik"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Bagian "Fitur utama"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _mainFeature(
                      icon: Icons.colorize,
                      title: "Booking\nVaksin",
                      color: Colors.purple[100]!,
                      iconColor: Colors.purple,
                    ),
                    _mainFeature(
                      icon: Icons.bar_chart,
                      title: "Tumbuh\nKembang",
                      color: Colors.orange[100]!,
                      iconColor: Colors.orange,
                    ),
                    _mainFeature(
                      icon: Icons.shopping_bag_outlined,
                      title: "Belanja",
                      color: Colors.green[100]!,
                      iconColor: Colors.green,
                    ),
                    _mainFeature(
                      icon: Icons.campaign_outlined,
                      title: "Campaign",
                      color: Colors.red[100]!,
                      iconColor: Colors.red,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Bagian "Menu Hari Ini"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _sectionTitle("Menu Hari Ini"),
              ),
              _menuItem(
                title: "ASI",
                subtitle: "08:00 • 12:00 • 15:00 • 18:00",
                imageAsset: 'assets/food_asi.png', // Pastikan gambar ini ada
              ),
              _menuItem(
                title: "Bubur Jagung",
                subtitle: "08:00",
                imageAsset: 'assets/food_bubur_jagung.png', // Pastikan gambar ini ada
              ),
              _menuItem(
                title: "Puding Jambu Merah",
                subtitle: "12:00",
                imageAsset: 'assets/food_bubur_jagung.png', // Pastikan gambar ini ada
              ),

              const SizedBox(height: 16),

              // Bagian "Aktivitas Hari Ini"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _sectionTitle("Aktivitas Hari Ini"),
              ),
              _menuItem(
                title: "Membaca Buku",
                subtitle: "Mendorong Kreativitas",
                imageAsset: 'assets/food_bubur_jagung.png', // Contoh, ganti dengan gambar relevan
              ),
              _menuItem(
                title: "Board Game",
                subtitle: "10:00",
                imageAsset: 'assets/food_bubur_jagung.png', // Contoh, ganti dengan gambar relevan
              ),

              const SizedBox(height: 16),

              // Bagian "Tanya Ahli Populer"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _sectionTitle("Tanya Ahli Populer"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _qaItem(
                  tag: "Tumbuh Gigi",
                  question: "Bagaimana cara meredakan rasa gatal pada bayi yang sedang tumbuh gigi?",
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _qaItem(
                  tag: "Tumbuh Gigi",
                  question: "Bagaimana cara meredakan rasa gatal pada bayi yang sedang tumbuh gigi?",
                ),
              ),

              const SizedBox(height: 16),

              // Bagian "Artikel Populer"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _sectionTitle("Artikel Populer"),
              ),
              SizedBox(
                height: 180,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  scrollDirection: Axis.horizontal,
                  children: [
                    _articleCard(
                      imageUrl: 'assets/artikel_sample.png', // Pastikan gambar ini ada
                      title: "Makanan Praktis yang dapat Menjadi Sumber Energi",
                      date: "6 April 2023",
                    ),
                    _articleCard(
                      imageUrl: 'assets/artikel_sample.png',
                      title: "Manfaat Bermain di Luar Ruangan untuk Anak", // Contoh judul artikel lain
                      date: "10 Mei 2023",
                    ),
                    _articleCard(
                      imageUrl: 'assets/artikel_sample.png',
                      title: "Pentingnya Imunisasi untuk Tumbuh Kembang Bayi", // Contoh judul artikel lain
                      date: "1 Juni 2023",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      // Custom Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0, // Indeks saat ini (0 untuk Home)
        onTap: (index) {
          switch (index) {
            case 0:
              // Navigasi ke halaman utama
              Navigator.pushReplacementNamed(context, '/home'); // Kembali ke home utama
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/konsultasi');
              break;
            case 2:
              Navigator.pushNamed(context, '/konten');
              break;
            case 3:
              Navigator.pushNamed(context, '/profil');
              break;
          }
        },
      ),
    );
  }

  // --- Fungsi-fungsi Widget Pembantu ---
  // Fungsi untuk membuat fitur utama (icon, judul, warna)
  Widget _mainFeature({
    required IconData icon,
    required String title,
    required Color color,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Fungsi untuk membuat judul bagian (misal: "Menu Hari Ini")
  Widget _sectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            // TODO: Aksi saat "Lihat Semua" ditekan
          },
          child: const Text(
            "Lihat Semua",
            style: TextStyle(fontSize: 12, color: Colors.blue),
          ),
        )
      ],
    );
  }

  // Fungsi untuk membuat item menu (misal: "ASI", "Bubur Jagung")
  Widget _menuItem({
    required String title,
    required String subtitle,
    required String imageAsset,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      leading: CircleAvatar(
        backgroundColor: Colors.amber[100],
        child: ClipOval(
          child: Image.asset(imageAsset, fit: BoxFit.cover),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }

  // Fungsi untuk membuat item Q&A
  Widget _qaItem({required String tag, required String question}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  question,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membuat kartu artikel
  Widget _articleCard({
    required String imageUrl,
    required String title,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}