import 'package:flutter/material.dart';
import 'package:teman_tumbuh/widgets/custom_buttom_navbar.dart';

class KontenPage extends StatefulWidget {
  const KontenPage({super.key});

  @override
  State<KontenPage> createState() => _KontenPageState();
}

class _KontenPageState extends State<KontenPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari Resep',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.bookmark_border),
                ],
              ),
            ),

            // Tab MPASI / Artikel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _tabController.animateTo(0);
                      },
                      child: Column(
                        children: [
                          Text(
                            "MPASI", 
                            style: TextStyle(
                              color: _selectedTabIndex == 0 ? Colors.orange : Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )
                          ),
                          Divider(
                            color: _selectedTabIndex == 0 ? Colors.orange : Colors.grey,
                            thickness: _selectedTabIndex == 0 ? 2 : 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _tabController.animateTo(1);
                      },
                      child: Column(
                        children: [
                          Text(
                            "Artikel", 
                            style: TextStyle(
                              color: _selectedTabIndex == 1 ? Colors.orange : Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )
                          ),
                          Divider(
                            color: _selectedTabIndex == 1 ? Colors.orange : Colors.grey,
                            thickness: _selectedTabIndex == 1 ? 2 : 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMPASITab(),
                  _buildArtikelTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home_with_data');
              break;
            case 1:
              Navigator.pushNamed(context, '/konsultasi');
              break;
            case 2:
              // stay di konten
              break;
            case 3:
              Navigator.pushNamed(context, '/profil');
              break;
          }
        },
      ),
    );
  }

  Widget _buildMPASITab() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 12),

        // Banner Form
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/kebutuhan_mpasi');
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit, color: Colors.blue),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Isi Form Kebutuhan MPASI\nDapatkan rekomendasi MPASI sesuai kebutuhan",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _filterChip("Filter", icon: Icons.filter_list),
              const SizedBox(width: 8),
              _filterChip("Semua", isSelected: true),
              const SizedBox(width: 8),
              _filterChip("Makanan Pagi"),
              const SizedBox(width: 8),
              _filterChip("Makan Siang"),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Resep Populer Horizontal
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: const [
              Text("Resep Populer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _resepCardHorizontal("Bubur Beras Wortel", "assets/bubur.png", "30 menit"),
              _resepCardHorizontal("Ubi Wangi", "assets/ubi.png", "45 menit"),
              _resepCardHorizontal("Perkedel Ayam", "assets/perkedel.png", "45 menit"),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // List Resep Vertikal
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _resepCardVertical(
                "Bubur Beras Wortel", 
                "Makan Pagi", 
                "8 - 12 bulan", 
                "30 menit",
                onTap: () => Navigator.pushNamed(context, '/detail_mpasi'),
              ),
              _resepCardVertical(
                "Ubi Wangi", 
                "Camilan", 
                "8 - 12 bulan", 
                "45 menit",
              ),
              _resepCardVertical(
                "Perkedel Ayam", 
                "Makan Siang", 
                "9 - 11 bulan", 
                "45 menit",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArtikelTab() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 12),

        // Filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _filterChip("Filter", icon: Icons.filter_list),
              const SizedBox(width: 8),
              _filterChip("Semua", isSelected: true),
              const SizedBox(width: 8),
              _filterChip("Tips"),
              const SizedBox(width: 8),
              _filterChip("Popular"),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Resep Populer Horizontal
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: const [
              Text("Resep Populer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _resepCardHorizontal("Bubur Beras Wortel", "assets/bubur.png", "30 menit"),
              _resepCardHorizontal("Ubi Wangi", "assets/ubi.png", "45 menit"),
              _resepCardHorizontal("Perkedel Ayam", "assets/perkedel.png", "45 menit"),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // List Artikel Vertikal
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _artikelCardVertical(
                "5 Rekomendasi Makanan Sehat untuk si Kecil",
                "Tips",
                "5 menit baca",
                onTap: () => Navigator.pushNamed(context, '/detail_artikel'),
              ),
              _artikelCardVertical(
                "Cara Membuat MPASI yang Bergizi",
                "Tips",
                "3 menit baca",
              ),
              _artikelCardVertical(
                "Jadwal Makan MPASI untuk Bayi 6-12 Bulan",
                "Panduan",
                "4 menit baca",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _filterChip(String label, {bool isSelected = false, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[100] : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: isSelected ? Colors.blue : Colors.black54),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _resepCardHorizontal(String title, String imageAsset, String durasi) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/detail_mpasi');
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imageAsset),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, 
                style: const TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  durasi, 
                  style: const TextStyle(
                    fontSize: 10, 
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _resepCardVertical(String title, String kategori, String usia, String waktu, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: AssetImage('assets/bubur.png'),
                    fit: BoxFit.cover,
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
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      kategori,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      usia,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        waktu,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.bookmark_border, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _artikelCardVertical(String title, String kategori, String readTime, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: AssetImage('assets/artikel.png'),
                    fit: BoxFit.cover,
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
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      kategori,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        readTime,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.bookmark_border, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}