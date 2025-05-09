// detail_mpasi.dart
import 'package:flutter/material.dart';

class DetailMPASIPage extends StatelessWidget {
  const DetailMPASIPage({super.key});

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
                    'assets/images/bubur.png',
                    width: double.infinity,
                    height: 250,
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
                      "Bubur Beras Wortel",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Tags
                    Row(
                      children: [
                        _buildTag("Makan Pagi"),
                        const SizedBox(width: 8),
                        _buildTag("Dairy Free"),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Fakta Unik
                    _buildInfoCard(
                      icon: Icons.info_outline,
                      title: "Fakta Unik Bubur Beras Wortel",
                      color: Colors.blue[50]!,
                      iconColor: Colors.blue,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Kandungan Kalori
                    _buildInfoCard(
                      icon: Icons.restaurant,
                      title: "Kandungan Kalori",
                      color: Colors.orange[50]!,
                      iconColor: Colors.orange,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Alat dan Bahan
                    _buildInfoCard(
                      icon: Icons.kitchen,
                      title: "Alat dan Bahan",
                      color: Colors.green[50]!,
                      iconColor: Colors.green,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(height: 8),
                          Text("• 1 sendok makan beras putih"),
                          Text("• 25 gram wortel"),
                          Text("• 100 ml air"),
                          Text("• 100 ml ASI"),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Cari Resep MPASI",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Beli Bahan",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
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
  
  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required Color color,
    required Color iconColor,
    Widget? content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (content != null) content,
        ],
      ),
    );
  }
}