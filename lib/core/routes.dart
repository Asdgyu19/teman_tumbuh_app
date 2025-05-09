import 'package:flutter/material.dart';
import '../views/home_screen.dart';
import '../views/login_screen.dart';

Map<String, WidgetBuilder> routes = {
  '/home': (context) => HomeScreen(),
  '/login': (context) => LoginScreen(),
};
