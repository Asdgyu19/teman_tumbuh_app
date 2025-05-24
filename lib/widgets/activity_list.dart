import 'package:flutter/material.dart';

class ActivityList extends StatelessWidget {
  final List<String> activities;

  const ActivityList({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: activities.map((activity) {
        return ListTile(
          title: Text(activity),
          trailing: Icon(Icons.check_circle_outline),
        );
      }).toList(),
    );
  }
}
