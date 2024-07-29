import 'package:flutter/material.dart';
import 'package:sugarcane_leaf_disease_classifier/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sugarcane Leaf Disease Classifier',
      home: SplashScreen(), // Start with SplashScreen
      debugShowCheckedModeBanner: false,
    );
  }
}
