import 'package:capstone_dr_rice/widgets/navigation/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: riceTheme,
      home: Scaffold(body: BottomNavBar()),
    );
    
  }
}
