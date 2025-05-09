import 'package:flutter/material.dart';
import 'package:teman_tumbuh/widgets/custom_buttom_navbar.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Profile info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/profile_picture.png'), // Ganti sesuai gambar kamu
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Sher Angel", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("Jakarta, Indonesia", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Edit Profil", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Profil section
            _sectionTitle("Profil"),
            _menuItem(icon: Icons.child_care, label: "Data Anak", onTap: () {}),

            const SizedBox(height: 16),

            // Seputar Aplikasi section
            _sectionTitle("Seputar Aplikasi"),
            _menuItem(icon: Icons.help_outline, label: "Pusat Bantuan & FAQ", onTap: () {}),
            _menuItem(icon: Icons.privacy_tip_outlined, label: "Kebijakan & Privasi", onTap: () {}),
            _menuItem(icon: Icons.star_border, label: "Rating Aplikasi", onTap: () {}),
            _menuItem(icon: Icons.info_outline, label: "Tentang Aplikasi", onTap: () {}),

            const SizedBox(height: 16),

            // Pengaturan
            _sectionTitle("Pengaturan"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Hapus Akun", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  Text("Keluar", style: TextStyle(color: Colors.red)),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home_with_data');
              break;
            case 1:
              Navigator.pushNamed(context, '/konsultasi');
              break;
            case 2:
              Navigator.pushNamed(context, '/konten');
              break;
            case 3:
              // stay di profil
              break;
          }
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 0,
        color: Colors.blue[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(label),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
