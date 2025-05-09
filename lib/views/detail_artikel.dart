// detail_artikel.dart
import 'package:flutter/material.dart';

class DetailArtikelPage extends StatelessWidget {
  const DetailArtikelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Image
              Stack(
                children: [
                  Image.asset(
                    'assets/images/artikel.png',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Title
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "5 Rekomendasi Makanan Sehat untuk si Kecil",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Content
                    const Text(
                      "Rekomendasi Makanan Sehat untuk si Kecil\n"
                      "Memberikan makanan sehat untuk si kecil sangat penting untuk pertumbuhan dan perkembangan mereka. Berikut beberapa rekomendasi makanan sehat yang dapat diberikan kepada si kecil:",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildNumberedItem(
                      number: 1,
                      title: "Bubur Beras dengan Buah Segar",
                      content: "Bubur beras akan memberikan karbohidrat yang dibutuhkan si kecil. Tambahkan buah segar seperti pisang, stroberi, atau apel yang sudah dihaluskan untuk menambah rasa dan vitamin.",
                    ),
                    
                    _buildNumberedItem(
                      number: 2,
                      title: "Telur Rebus atau Orak-arik dengan Sayuran",
                      content: "Telur kaya akan protein dan nutrisi penting lainnya. Sajikan dalam bentuk rebus atau orak-arik dengan tambahan sayuran seperti wortel cincang untuk menambah serat dan vitamin.",
                    ),
                    
                    _buildNumberedItem(
                      number: 3,
                      title: "Sup Ayam dengan Sayuran Warna-warni",
                      content: "Sup ayam dengan sayuran warna-warni seperti wortel, kentang, dan brokoli tidak hanya lezat tetapi juga kaya nutrisi. Daging ayam memberikan protein yang dibutuhkan untuk pertumbuhan.",
                    ),
                    
                    _buildNumberedItem(
                      number: 4,
                      title: "Kentang dengan Daging dan Sayuran",
                      content: "Kentang adalah sumber karbohidrat yang baik. Kombinasikan dengan daging cincang dan sayuran hijau untuk mendapatkan menu lengkap dengan nutrisi seimbang.",
                    ),
                    
                    _buildNumberedItem(
                      number: 5,
                      title: "Smoothie Buah dengan Yogurt",
                      content: "Yogurt kaya akan probiotik yang baik untuk pencernaan si kecil. Tambahkan buah-buahan segar untuk membuat smoothie yang kaya nutrisi dan juga disukai si kecil karena rasanya yang manis.",
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Share Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share, color: Colors.white),
                        label: const Text(
                          "Bagikan Artikel",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildNumberedItem({required int number, required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              number.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}