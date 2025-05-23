import 'package:flutter/material.dart';

class ArticleList extends StatelessWidget {
  final String imagePath;

  const ArticleList({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(imagePath, height: 100),
        Text("Makanan Praktis yang Bisa Menjadi Sumber Energi"),
      ],
    );
  }
}
