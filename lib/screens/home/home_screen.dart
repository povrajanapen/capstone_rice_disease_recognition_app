import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:flutter/material.dart';

import '../../models/diagnosis_model.dart';
import '../../service/diagnosis_service.dart';
import '../saved diagnosis/saved_diagnosis_screen.dart';
import 'widgets/diagnosis_controller.dart';
import 'widgets/news_slider.dart';
import 'widgets/recent_diagnoses_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final DiagnosisController _diagnosisController;
  late Future<List<DiagnosisModel>> _recentDiagnoses;

  @override
  void initState() {
    super.initState();
    // Initialize the controller
    _diagnosisController = DiagnosisController(diagnosisService: DiagnosisService());
    // Fetch the recent diagnoses
    _recentDiagnoses = _diagnosisController.getRecentDiagnoses();
  }

  void onSelect() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SavedDiagnosisScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(RiceSpacings.m),
      child: Column(
        children: [
          NewsSlider(),
          const SizedBox(height: RiceSpacings.m),
          FutureBuilder<List<DiagnosisModel>>(
            future: _recentDiagnoses,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Error loading diagnoses.'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No diagnoses available.'));
              }

              return RecentDiagnosesSection(
                diagnoses: snapshot.data!.take(3).toList(),
                controller: _diagnosisController,
              );
            },
          ),
        ],
      ),
    );
  }
}
