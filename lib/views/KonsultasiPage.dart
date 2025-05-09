import 'package:flutter/material.dart';
import 'package:teman_tumbuh/widgets/custom_buttom_navbar.dart';

class KonsultasiPage extends StatelessWidget {
  const KonsultasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Konsultasi", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            Text("Agnesti, 8 bulan", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab Tanya Ahli & Cari Dokter
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: const [
                      Text("Tanya Ahli", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                      Divider(color: Colors.orange, thickness: 2),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/cari_dokter');
                    },
                    child: Column(
                      children: const [
                        Text("Cari Dokter", style: TextStyle(color: Colors.grey)),
                        Divider(color: Colors.grey, thickness: 1),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari Pertanyaan',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 16),

            // Kategori Populer
            const Text("Kategori Populer", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _categoryChip("Semua", isSelected: true),
                _categoryChip("Tumbuh Kembang"),
                _categoryChip("Kesehatan"),
                _categoryChip("Pola Asuh"),
              ],
            ),

            const SizedBox(height: 16),

            // List Tanya Ahli
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/tumbuh_gigi');
                    },
                    child: _questionCard(),
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home_with_data');
              break;
            case 1:
              // Stay di sini
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

  static Widget _categoryChip(String label, {bool isSelected = false}) {
    return Chip(
      label: Text(label),
      backgroundColor: isSelected ? Colors.blue[100] : Colors.grey[200],
      labelStyle: TextStyle(color: isSelected ? Colors.blue : Colors.black),
    );
  }

  static Widget _questionCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: const Text("Tumbuh Gigi", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("11 November 2024"),
            SizedBox(height: 4),
            Text("Bagaimana cara meredakan rasa gatal pada bayi yang sedang tumbuh gigi?"),
            SizedBox(height: 4),
            Chip(
              label: Text("Tumbuh kembang anak", style: TextStyle(fontSize: 10)),
              backgroundColor: Colors.blueAccent,
              labelStyle: TextStyle(color: Colors.white),
              padding: EdgeInsets.symmetric(horizontal: 4),
            )
          ],
        ),
        trailing: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}
