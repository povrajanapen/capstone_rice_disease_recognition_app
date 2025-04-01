import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Scan Object",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }
}
