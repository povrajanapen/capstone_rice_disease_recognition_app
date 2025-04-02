import 'package:capstone_dr_rice/models/disease_data.dart';
import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:capstone_dr_rice/provider/saved_diagnosis_provider.dart';
import 'package:capstone_dr_rice/screens/scan/scan_screen.dart';
import 'package:capstone_dr_rice/screens/scan/widgets/detail_card_widget.dart';
import 'package:capstone_dr_rice/screens/scan/widgets/prediction_card_widget.dart';
import 'package:capstone_dr_rice/screens/scan/widgets/result_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:capstone_dr_rice/models/disease.dart';
import 'package:provider/provider.dart';

import 'package:flutter_tts/flutter_tts.dart';

class DiagnoseDetailScreen extends StatefulWidget {
  final String imagePath;
  final Map<String, dynamic> result;

  const DiagnoseDetailScreen({
    super.key,
    required this.imagePath,
    required this.result,
  });

  @override
  _DiagnoseDetailScreenState createState() => _DiagnoseDetailScreenState();
}

class _DiagnoseDetailScreenState extends State<DiagnoseDetailScreen>
    with SingleTickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("en-US");
    flutterTts.setPitch(1.0);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<Disease> _getDiseaseFromResult() async {
    final diseaseMap = await DiseaseDataLoader.loadDiseaseMap();
    final diseaseName = widget.result['class'].toString();
    return diseaseMap[diseaseName] ??
        Disease(
          id: 'unknown',
          name: diseaseName,
          description: 'Unknown disease',
          type: DiseaseType.bacterial,
          symptoms: 'No specific information available.',
          management: 'No specific management available.',
        );
  }


  Future<void> _saveDiagnosis(BuildContext context, LanguageProvider languageProvider) async {
    // final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final disease = await _getDiseaseFromResult();
    final diagnosisId = DateTime.now().millisecondsSinceEpoch.toString();
    final diagnose = Diagnose(
      id: diagnosisId,
      disease: disease,
      timestamp: DateTime.now(),
      imagePath: widget.imagePath,
      confidence:
          double.tryParse(widget.result['confidence'].toString()) ?? 0.0,
      userId: null,
    );
    
    // Check for duplicates in saved diagnoses
    final provider = context.read<DiagnosisProvider>();
    final savedDiagnoses = provider.savedDiagnoses;
    final isDuplicate = savedDiagnoses.any(
      (d) =>
          d.imagePath == diagnose.imagePath &&
          d.disease.name == diagnose.disease.name &&
          d.confidence == diagnose.confidence,
    );

    // if (!isDuplicate) {
    //   await provider.addDiagnosis(diagnose, widget.imagePath, save: true);
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text(LanguageProvider.translate('Diagnosis saved'))));
    // } else {
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text(LanguageProvider.translate('Diagnosis already saved'))));
    // }
    if (!isDuplicate) {
      await provider.addDiagnosis(diagnose, widget.imagePath, save: true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(languageProvider.translate('Diagnosis saved'))),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(languageProvider.translate('Diagnosis already saved'))),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    final confidence =
        double.tryParse(widget.result['confidence'].toString()) ?? 0.0;
    final confidencePercent = '${(confidence * 100).toStringAsFixed(2)}%';
    final diagnosisProvider = context.watch<DiagnosisProvider>();
    diagnosisProvider.getRecentDiagnoses();
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          languageProvider.translate('Analysis Result'),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.32,
                  child: ResultImageWidget(imagePath: widget.imagePath),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageProvider.translate('Results'),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    PredictionCardWidget(
                      result: widget.result,
                      confidence: confidence,
                      confidencePercent: confidencePercent,
                      onSave: () => _saveDiagnosis(context, languageProvider),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<Disease>(
                      future: _getDiseaseFromResult(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final disease =
                            snapshot.data ??
                            Disease(
                              id: 'unknown',
                              name: 'Unknown',
                              description: 'Unknown disease',
                              type: DiseaseType.bacterial,
                              symptoms: 'No info',
                              management: 'No info',
                            );
                        return DetailCardWidget(
                          tabController: _tabController,
                          flutterTts: flutterTts,
                          disease: disease,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const ScanScreen()),
                          )
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          languageProvider.translate('Scan Again'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

