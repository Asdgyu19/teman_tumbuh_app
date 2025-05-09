import "package:flutter/material.dart";
import "package:teman_tumbuh/widgets/custom_buttom_navbar.dart";

class HomeWithData extends StatelessWidget {
  
  const
  HomeWithData({super.key});

  @override
  Widget
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/profile_picture1.png'),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Nanda Kirana", 
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("0 tahun 8 bulan", 
                            style: TextStyle(color: Colors.grey, fontSize: 12))
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Colors.blue),
                      onPressed: () {},
                    )
                  ],
                ),
              ),

              // Kesehatan hari ini
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
                            'assets/baby_icon.png',
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Bagaimana kabar Nanda Kirana hari ini?",
                            style: TextStyle(
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
                            onPressed: () {},
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
                              // Add your desired functionality here
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

              // Fitur utama
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

              // Menu Hari Ini
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _sectionTitle("Menu Hari Ini"),
              ),
              _menuItem(
                title: "ASI", 
                subtitle: "08:00 • 12:00 • 15:00 • 18:00",
                imageAsset: 'assets/food_asi.png',
              ),
              _menuItem(
                title: "Bubur Jagung", 
                subtitle: "08:00",
                imageAsset: 'assets/food_bubur_jagung.png',
              ),
              _menuItem(
                title: "Puding Jambu Merah", 
                subtitle: "12:00",
                imageAsset: 'assets/food_bubur_jagung.png',
              ),

              const SizedBox(height: 16),

              // Aktivitas Hari Ini
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _sectionTitle("Aktivitas Hari Ini"),
              ),
              _menuItem(
                title: "Membaca Buku", 
                subtitle: "Mendorong Kreativitas",
                imageAsset: 'assets/food_bubur_jagung.png',
              ),
              _menuItem(
                title: "Board Game", 
                subtitle: "10:00",
                imageAsset: 'assets/food_bubur_jagung.png',
              ),

              const SizedBox(height: 16),

              // Tanya Ahli Populer
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

              // Artikel Populer
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
                      imageUrl: 'assets/artikel_sample.png',
                      title: "Makanan Praktis yang dapat Menjadi Sumber Energi",
                      date: "6 April 2023",
                    ),
                    _articleCard(
                      imageUrl: 'assets/artikel_sample.png',
                      title: "Makanan Praktis yang dapat Menjadi Sumber Energi",
                      date: "6 April 2023",
                    ),
                    _articleCard(
                      imageUrl: 'assets/artikel_sample.png',
                      title: "Makanan Praktis yang dapat Menjadi Sumber Energi",
                    date: "6 April 2023",
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
        Navigator.pushReplacementNamed(context, '/home');
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

  Widget
  _mainFeature({
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

  Widget
  _sectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title, 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
        ),
        TextButton(
          onPressed: () {}, 
          child: const Text(
            "Lihat Semua",
            style: TextStyle(fontSize: 12, color: Colors.blue),
          ),
        )
      ],
    );
  }

  Widget
  _menuItem({
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

  Widget
  _qaItem({required String tag, required String question}) {
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
            decoration: BoxDecoration(
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

  Widget
  _articleCard({
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
