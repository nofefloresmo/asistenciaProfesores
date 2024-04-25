import 'package:flutter/material.dart';
import './pages/login_page.dart';

void main() {
  runApp(const Practica0301());
}

class Practica0301 extends StatefulWidget {
  const Practica0301({super.key});

  @override
  State<Practica0301> createState() => _Practica0301State();
}

class _Practica0301State extends State<Practica0301> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(255, 9, 49, 109),
      ),
      home: const LoginPage(),
    );
  }
}
