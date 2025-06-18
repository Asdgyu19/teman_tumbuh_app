import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class HomeWithoutData extends StatefulWidget {
  const HomeWithoutData({super.key});

  @override
  State<HomeWithoutData> createState() => _HomeWithoutDataState();
}

class _HomeWithoutDataState extends State<HomeWithoutData> {
  int _currentIndex = 0;
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  // State variables
  List<dynamic> _popularQuestions = [];
  List<dynamic> _recommendedArticles = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  String _userName = 'User'; // Default name

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadData();
  }

  // Method untuk load user data
  Future<void> _loadUserData() async {
    try {
      final userData = await _authService.getCurrentUser();
      if (userData != null && userData['name'] != null) {
        setState(() {
          _userName = userData['name'];
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      // Keep default name if error
    }
  }

  // Method untuk load data dari API dengan null safety
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = ''; // Clear previous error message
      _popularQuestions = []; // Clear previous data
      _recommendedArticles = []; // Clear previous data
    });

    try {
      // Fetch data dengan null safety
      final questionsResponse = await _apiService.getPopularQuestions();
      final articlesResponse = await _apiService.getRecommendedArticles();

      setState(() {
        // Handle null responses dengan memberikan empty list sebagai fallback
        _popularQuestions = questionsResponse ?? [];
        _recommendedArticles = articlesResponse ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Gagal memuat data. Silakan coba lagi.';
        // Set empty lists even on error to prevent null issues in UI
        _popularQuestions = [];
        _recommendedArticles = [];
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
            Text(
              'Halo, $_userName!', // Gunakan nama dinamis
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {
                // TODO: Handle notification tap
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData, // Call _loadData for refresh
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(), // Untuk refresh indicator
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Error banner jika ada error tapi tidak blocking
                    if (_hasError)
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: Colors.orange[800], size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage,
                                style: TextStyle(color: Colors.orange[800], fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Empty state for child data
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                            textAlign: TextAlign.center, // Center text
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
                                'Tambah Data Anak', // More descriptive text
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
            onPressed: () {
              // TODO: Implement "Lihat Semua" functionality for questions/articles
            },
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
    if (_popularQuestions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.help_outline, color: Colors.grey[400], size: 48),
                const SizedBox(height: 8),
                Text(
                  _hasError
                      ? 'Gagal memuat pertanyaan. Tarik untuk refresh.'
                      : 'Belum ada pertanyaan populer saat ini.',
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _popularQuestions.map((question) {
          // Null safety check for each item in the list
          if (question == null) return const SizedBox.shrink();
          return _buildQuestionCard(Map<String, dynamic>.from(question));
        }).toList(),
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
                Expanded(
                  child: Text(
                    question['title']?.toString() ?? 'Judul Pertanyaan Tidak Tersedia',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
                    question['category_name']?.toString() ?? 'Umum',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
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
              _formatDate(question['created_at']?.toString() ?? ''),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              question['content']?.toString() ?? 'Konten tidak tersedia.',
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
    if (_recommendedArticles.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: 180, // Adjusted height for consistency with article cards
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, color: Colors.grey[400], size: 48),
                const SizedBox(height: 8),
                Text(
                  _hasError
                      ? 'Gagal memuat artikel. Tarik untuk refresh.'
                      : 'Belum ada artikel rekomendasi saat ini.',
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      height: 220, // Adjusted height to accommodate full card size
      padding: const EdgeInsets.only(left: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _recommendedArticles.length,
        itemBuilder: (context, index) {
          final article = _recommendedArticles[index];
          if (article == null) return const SizedBox.shrink(); // Null safety for each item
          return _buildArticleCard(Map<String, dynamic>.from(article));
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
                  article['thumbnail']?.toString() ?? '', // Use null-safe access
                  width: 180,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 180,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                        size: 48,
                      ),
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
                    article['category_name']?.toString() ?? 'Artikel',
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
            article['title']?.toString() ?? 'Judul artikel tidak tersedia',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _formatDate(article['published_at']?.toString() ?? ''),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'Tanggal tidak tersedia';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    } catch (e) {
      print('Error parsing date: $e'); // Log the error for debugging
      return 'Tanggal tidak valid';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return ''; // Return empty string for invalid month
  }
}