import 'package:flutter/material.dart';
import 'package:test_app/pages/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red
      ),
      home: MainPage(),
    );
  }
}

