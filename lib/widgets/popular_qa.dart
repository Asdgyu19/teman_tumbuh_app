import 'package:flutter/material.dart';

class PopularQA extends StatelessWidget {
  const PopularQA({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text("Tumbuh Gigi"),
          subtitle: Text("Bagaimana cara meredakan nyeri gigi bayi?"),
          trailing: Icon(Icons.chat_bubble_outline),
          onTap: () {
            // Navigasi ke konsultasi
          },
        ),
      ],
    );
  }
}
