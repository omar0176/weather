import 'package:flutter/material.dart';
import 'package:weather/navigation.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // hides the debug banner
      home: Navigation(), // forwards to the main page of the app
    );
  }
}