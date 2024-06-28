import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; // package for state management
import 'package:weather/navigation.dart'; 
import 'package:weather/utils.dart'; 

void main() {
  // initializes the app 
  runApp(
    ChangeNotifierProvider(
      // Providing an instance of Utils to the widget tree
      create: (context) => Utils(),
      child: const MyApp(), 
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor 

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: Navigation(), // Sets the home property to the Nav widget
    );
  }
}
