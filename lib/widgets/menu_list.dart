import 'package:flutter/material.dart';

class MenuList extends StatelessWidget {
  final List<Map<String, String>> menus;

  MenuList({required this.menus});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: menus.map((menu) {
        return ListTile(
          title: Text(menu['name']!),
          trailing: Text(menu['time']!),
        );
      }).toList(),
    );
  }
}
