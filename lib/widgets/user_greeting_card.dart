import 'package:flutter/material.dart';

class UserGreetingCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final Widget? actionWidget;

  const UserGreetingCard({super.key, 
    required this.title,
    required this.description,
    required this.imagePath,
    this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Image.asset(imagePath, height: 100),
          SizedBox(height: 10),
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(description, textAlign: TextAlign.center),
          if (actionWidget != null) ...[
            SizedBox(height: 10),
            actionWidget!,
          ],
        ],
      ),
    );
  }
}
