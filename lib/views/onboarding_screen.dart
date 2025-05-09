import 'package:flutter/material.dart';
import 'register_screen.dart';



class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      "image": "assets/onboarding1.png",
      "title": "Selamat datang!",   
      "description": "Ayo pantau tumbuh kembang anak untuk masa depannya yang baik"
    },
    {
      "image": "assets/onboarding2.png",
      "title": "Pahami kebutuhan anak",
      "description": "Berikan perhatian yang tepat untuk memenuhi setiap kebutuhan anak Anda"
    },
    {
      "image": "assets/onboarding3.png",
      "title": "Awasi perkembangan anak",
      "description": "Bantu mereka tumbuh dan berkembang menjadi pribadi yang tangguh dan berprestasi"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          if (_currentPage < onboardingData.length - 1)
            TextButton(
              onPressed: () {
                _pageController.jumpToPage(onboardingData.length - 1);
              },
              child: Text("Lewati", style: TextStyle(color: Colors.grey)),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) => OnboardingPage(
                image: onboardingData[index]["image"]!,
                title: onboardingData[index]["title"]!,
                description: onboardingData[index]["description"]!,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => buildDot(index: index),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: FloatingActionButton(
             onPressed: () {
  if (_currentPage == onboardingData.length - 1) {
    // Navigasi ke halaman RegisterScreen atau LoginScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()), // Ganti dengan halaman yang diinginkan
    );
  } else {
    _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease);
  }
},
              backgroundColor: Colors.blue,
              child: Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot({required int index}) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      height: 8,
      width: _currentPage == index ? 20 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image, title, description;

  const OnboardingPage({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 300),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          description,
          style: TextStyle(fontSize: 16, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
