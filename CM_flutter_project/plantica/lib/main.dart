import 'package:flutter/material.dart';
import 'package:plantica/main_page.dart';
import 'package:plantica/screens/homepage.dart';
import 'package:plantica/screens/login.dart';
import 'package:plantica/screens/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}