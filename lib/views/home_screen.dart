import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Teman Tumbuh')),
      body: Center(child: Text('Selamat Datang!')),
    );
  }
}
