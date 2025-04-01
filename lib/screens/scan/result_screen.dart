import 'package:capstone_dr_rice/models/disease_data.dart';
import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:capstone_dr_rice/provider/saved_diagnosis_provider.dart';
import 'package:capstone_dr_rice/screens/scan/widgets/detail_card_widget.dart';
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:capstone_dr_rice/models/disease.dart';
import 'package:provider/provider.dart';
import 'widgets/result_image_widget.dart';
import 'widgets/prediction_card_widget.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ResultScreen extends StatefulWidget {
  final String imagePath;
  final Map<String, dynamic> result;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.result,
  });

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initTts();
  }

  Future<void> _initTts() async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    await flutterTts.setLanguage(languageProvider.languageCode); // Dynamic language
    await flutterTts.setPitch(1.0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    flutterTts.stop(); // Clean up TTS
    super.dispose();
  }

  Future<Disease> _getDiseaseFromResult() async {
    final diseaseMap = await DiseaseDataLoader.loadDiseaseMap();
    final diseaseName = widget.result['class'].toString();
    return diseaseMap[diseaseName] ??
        Disease(
          id: 'unknown',
          name: 'Unknown',
          description: 'Unknown disease',
          type: DiseaseType.bacterial,
          symptoms: 'No specific information available.',
          management: 'No specific management available.',
        );
  }

  Future<void> _saveDiagnosis(BuildContext context) async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final disease = await _getDiseaseFromResult();
    final diagnosisId = DateTime.now().millisecondsSinceEpoch.toString();
    final diagnose = Diagnose(
      id: diagnosisId,
      disease: disease,
      timestamp: DateTime.now(),
      imagePath: widget.imagePath,
      confidence: double.tryParse(widget.result['confidence'].toString()) ?? 0.0,
      userId: null,
    );
    context.read<DiagnosisProvider>().addDiagnosis(diagnose, widget.imagePath);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(languageProvider.translate('Diagnosis saved'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final confidence = double.tryParse(widget.result['confidence'].toString()) ?? 0.0;
    final confidencePercent = '${(confidence * 100).toStringAsFixed(2)}%';

    // Fallback disease with translations
    final fallbackDisease = Disease(
      id: languageProvider.translate('unknown'),
      name: languageProvider.translate('Unknown'),
      description: languageProvider.translate('Unknown disease'),
      type: DiseaseType.bacterial,
      symptoms: languageProvider.translate('No info'),
      management: languageProvider.translate('No info'),
    );

    return Scaffold(
      backgroundColor: RiceColors.white,
      appBar: AppBar(
        backgroundColor: RiceColors.white,
        elevation: 0,
        title: Text(
          languageProvider.translate('Analysis Result'),
          style: TextStyle(
            color: RiceColors.neutralDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: RiceColors.neutralDark),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(RiceSpacings.m), // Consistent spacing
                child: SizedBox(
                  width: MediaQuery.of(context).size.width, // Full width
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: ResultImageWidget(imagePath: widget.imagePath),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(RiceSpacings.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageProvider.translate('Results'),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: RiceColors.neutralDark,
                      ),
                    ),
                    const SizedBox(height: RiceSpacings.m),
                    PredictionCardWidget(
                      result: widget.result,
                      confidence: confidence,
                      confidencePercent: confidencePercent,
                      onSave: () => _saveDiagnosis(context),
                    ),
                    const SizedBox(height: RiceSpacings.m),
                    FutureBuilder<Disease>(
                      future: _getDiseaseFromResult(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final disease = snapshot.data ?? fallbackDisease;
                        return DetailCardWidget(
                          tabController: _tabController,
                          flutterTts: flutterTts,
                          disease: disease,
                        );
                      },
                    ),
                    const SizedBox(height: RiceSpacings.l),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
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
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: RiceSpacings.l),
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