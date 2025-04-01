// widgets/prediction_card_widget.dart
import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:capstone_dr_rice/screens/scan/widgets/confidence_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PredictionCardWidget extends StatelessWidget {
  final Map<String, dynamic> result;
  final double confidence;
  final String confidencePercent;
  final VoidCallback onSave; // Added callback for save action

  const PredictionCardWidget({
    super.key,
    required this.result,
    required this.confidence,
    required this.confidencePercent,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final LanguageProvider languageProvider =
        Provider.of<LanguageProvider>(context);
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                languageProvider.translate('Classification'),
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Row(
                children: [
                  ConfidenceBarWidget(
                    confidence: confidence,
                    confidencePercent: confidencePercent,
                  ),
                  const SizedBox(width: 8),
                  IconButton(icon: const Icon(Icons.save), onPressed: onSave),
                ],
              ),
            ],
          ),
          Text(
            result['class'].toString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Column(
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
          ),
        ],
      ),
    );
  }
}
