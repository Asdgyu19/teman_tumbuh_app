import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Import your API service

class HomeWithoutData extends StatefulWidget {
  const HomeWithoutData({Key? key}) : super(key: key);

  @override
  State<HomeWithoutData> createState() => _HomeWithoutDataState();
}

class _HomeWithoutDataState extends State<HomeWithoutData> {
  int _currentIndex = 0;
  final ApiService _apiService = ApiService(); // Create an instance of your API service
  
  // State variables to store data from API
  List<dynamic> _popularQuestions = [];
  List<dynamic> _recommendedArticles = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  
  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Load data when the widget initializes
    _loadData();
  }

  // Method to load data from API
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    
    try {
      // Fetch popular questions and recommended articles
      final questions = await _apiService.getPopularQuestions();
      final articles = await _apiService.getRecommendedArticles();
      
      // Update state with fetched data
      setState(() {
        _popularQuestions = questions;
        _recommendedArticles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to load data: $e';
      });
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF448AFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/profile_picture.png'),
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 12),
            const Text(
              'Halo, Sher!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Empty state for child data
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/ilustrasi_belum_tambah_anak.png',
                                height: 120,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Kamu belum menambahkan data anak',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 200,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/add_child');
                                  },
                                  icon: const Icon(Icons.add, color: Colors.white),
                                  label: const Text(
                                    'Tambah',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildSectionTitle('Tanya Ahli Populer'),
                        _buildPopularQuestions(),
                        const SizedBox(height: 16),
                        _buildSectionTitle('Rekomendasi Artikel'),
                        _buildArticleList(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Konsultasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'Konten',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Lihat Semua',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularQuestions() {
    // If no questions are available, show a placeholder
    if (_popularQuestions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Text(
            'Tidak ada pertanyaan saat ini',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }
    
    // Otherwise, build the list of questions from API data
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _popularQuestions.map((question) => _buildQuestionCard(question)).toList(),
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  question['title'] ?? 'Tumbuh Gigi',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    question['category_name'] ?? 'Tumbuh Kembang Anak',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _formatDate(question['created_at'] ?? '2023-04-09 13:20:00'),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              question['content'] ?? 'Bagaimana cara meredakan rasa gatal pada bayi yang sedang tumbuh gigi?',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleList() {
    // If no articles are available, show a placeholder
    if (_recommendedArticles.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Text(
            'Tidak ada artikel saat ini',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }
    
    // Otherwise, build the list of articles from API data
    return Container(
      height: 220,
      padding: const EdgeInsets.only(left: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _recommendedArticles.length,
        itemBuilder: (context, index) {
          final article = _recommendedArticles[index];
          return _buildArticleCard(article);
        },
      ),
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  article['thumbnail'] ?? 'https://via.placeholder.com/180x120',
                  width: 180,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/artikel_sample.png',
                      width: 180,
                      height: 120,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    article['category_name'] ?? 'Nutrisi',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            article['title'] ?? 'Makanan Praktis yang dapat Menjadi Sumber Energi',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _formatDate(article['published_at'] ?? '2023-04-09'),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to format dates from the API
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
  
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month - 1];
  }
}