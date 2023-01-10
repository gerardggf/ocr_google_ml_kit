import 'package:flutter/material.dart';
import 'package:prueba_ocr/home_google_ml_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prueba OCR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeGoogleMLKitPage(),
    );
  }
}
