import 'package:flutter/material.dart';
import 'package:teman_tumbuh/widgets/custom_buttom_navbar.dart';

class CariDokterPage extends StatefulWidget {
  const CariDokterPage({super.key});

  @override
  State<CariDokterPage> createState() => _CariDokterPageState();
}

class _CariDokterPageState extends State<CariDokterPage> {
  int _selectedTabIndex = 1; // 0 for Tanya Ahli, 1 for Cari Dokter
  int _selectedFilterIndex = 1; // 0 for Filter, 1 for Semua, 2 for Gading Ayu, 3 for Terdekat

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
            Text(
              "Konsultasi",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              "Agnesti, 8 bulan",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab Tanya Ahli & Cari Dokter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = 0;
                      });
                      Navigator.pop(context); // Go back to Tanya Ahli page
                    },
                    child: Column(
                      children: [
                        Text(
                          "Tanya Ahli",
                          style: TextStyle(
                            color: _selectedTabIndex == 0
                                ? Colors.orange
                                : Colors.grey,
                            fontWeight: _selectedTabIndex == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        Divider(
                          color:
                              _selectedTabIndex == 0 ? Colors.orange : Colors.grey,
                          thickness: _selectedTabIndex == 0 ? 2 : 1,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = 1;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          "Cari Dokter",
                          style: TextStyle(
                            color: _selectedTabIndex == 1
                                ? Colors.orange
                                : Colors.grey,
                            fontWeight: _selectedTabIndex == 1
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        Divider(
                          color:
                              _selectedTabIndex == 1 ? Colors.orange : Colors.grey,
                          thickness: _selectedTabIndex == 1 ? 2 : 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari Dokter',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Filter options
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _filterOption("Filter", 0, Icons.filter_list),
                const SizedBox(width: 8),
                _filterOption("Semua", 1),
                const SizedBox(width: 8),
                _filterOption("Gading Ayu", 2),
                const SizedBox(width: 8),
                _filterOption("Terdekat", 3),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Doctor List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _doctorCard(
                  name: "Dr. Aryo Prabowo",
                  specialty: "Umum",
                  rating: 4.8,
                  price: 89000,
                  imageUrl: "assets/dokter1.jpg",
                ),
                _doctorCard(
                  name: "Dr. Ricardo",
                  specialty: "Pediatri",
                  rating: 4.7,
                  price: 70000,
                  imageUrl: "assets/ricard-lee.jpg",
                ),
                _doctorCard(
                  name: "Dr. Doktif",
                  specialty: "Umum",
                  rating: 4.5,
                  price: 65000,
                  imageUrl: "assets/doktif.jpg",
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home_with_data');
              break;
            case 1:
              // Stay on this page
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

  Widget _filterOption(String label, int index, [IconData? icon]) {
    final isSelected = _selectedFilterIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _doctorCard({
    required String name,
    required String specialty,
    required double rating,
    required int price,
    required String imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              imageUrl,
              width: 80,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(
                        Icons.bookmark_border,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  Text(
                    specialty,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      Text(
                        " $rating",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mulai dari",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        "Rp. ${price.toString()}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
