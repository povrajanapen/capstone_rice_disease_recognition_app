import 'package:capstone_dr_rice/screens/common%20disease/common_disease_screen.dart'
    show CommonDiseasesScreen;
import 'package:capstone_dr_rice/screens/home/widgets/feature_buttons.dart';
import 'package:capstone_dr_rice/screens/home/widgets/news_slider.dart';
import 'package:flutter/material.dart';
import '../../models/diagnosis_model.dart';
import '../../service/diagnosis_service.dart';
import '../../theme/theme.dart';
import '../report/report_screen.dart';
import '../scan/result_screen.dart';
import '../scan/scan_screen.dart';
import 'widgets/app_header.dart';
import 'widgets/diagnosis_controller.dart';
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
    _diagnosisController = DiagnosisController(
      diagnosisService: DiagnosisService(),
    );
    _recentDiagnoses = _diagnosisController.getRecentDiagnoses();
  }

  void _handleFeaturePressed(String route) {
    switch (route) {
      case '/diseases':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CommonDiseasesScreen()),
        );
        break;
      case '/scan':
        Navigator.push(
          context,
      
          MaterialPageRoute(builder: (context) => ResultScreen(
              imagePath: 'assets/image/disease_thumbnail.jpg', // Placeholder image
              result: {
                'name': 'Healthy',
                'description': 'A serious bacterial disease causing yellowing and drying of leaves', // Default class (Healthy)
                'accuracy': 0.95, // Default confidence level
              },
            ),
          ),
        );
        break;
      case '/report':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReportScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // App Header
        toolbarHeight: 80,
        title: AppHeader(),
        backgroundColor: RiceColors.backgroundAccent,
        elevation: 0,
      ),
      backgroundColor: RiceColors.backgroundAccent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(RiceSpacings.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: RiceSpacings.s),

                // Image Carousel
                NewsSlider(),
                // const ImageCarousel(),
                const SizedBox(height: RiceSpacings.m),

                // Feature Buttons
                FeatureButtons(onFeaturePressed: _handleFeaturePressed),

                const SizedBox(height: RiceSpacings.m),

                // Recent diagnoses section
                FutureBuilder<List<DiagnosisModel>>(
                  future: _recentDiagnoses,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error loading diagnoses.',
                          style: RiceTextStyles.label.copyWith(
                            color: RiceColors.red,
                          ),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No diagnoses available.',
                          style: RiceTextStyles.label.copyWith(
                            color: RiceColors.textNormal,
                          ),
                        ),
                      );
                    }

                    return RecentDiagnosesSection(
                      diagnoses: snapshot.data!.take(3).toList(),
                      controller: _diagnosisController,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
