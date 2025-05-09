import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/welcome.png', width: 250),
            SizedBox(height: 20),
            Text("Selamat datang Bunda!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
            Text("Ayo pantau tumbuh kembang anak untuk masa depannya yang baik", textAlign: TextAlign.center),
            SizedBox(height: 30),
            ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, '/home_without_data');
  },
  child: Text("Masuk ke Beranda"),
),

          ],
        ),
      ),
    );
  }
}
