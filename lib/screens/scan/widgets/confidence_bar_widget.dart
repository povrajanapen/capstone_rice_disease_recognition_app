import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfidenceBarWidget extends StatelessWidget {
  final double confidence;
  final String confidencePercent;

  const ConfidenceBarWidget({
    super.key,
    required this.confidence,
    required this.confidencePercent,
  });

  @override
  Widget build(BuildContext context) {
    final LanguageProvider languageProvider =
        Provider.of<LanguageProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              languageProvider.translate('Confidence'),
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              confidencePercent,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: confidence,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              confidence > 0.8
                  ? Colors.green
                  : confidence > 0.5
                  ? Colors.orange
                  : Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
