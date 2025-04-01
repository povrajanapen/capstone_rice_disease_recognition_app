

import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:flutter/material.dart';

class ScanAppBarWidget extends StatelessWidget {
  final LanguageProvider languageProvider;

  const ScanAppBarWidget({super.key, required this.languageProvider});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          languageProvider.translate('Scan Rice'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }
}