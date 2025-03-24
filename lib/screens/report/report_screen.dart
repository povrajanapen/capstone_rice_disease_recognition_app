import 'package:capstone_dr_rice/provider/report_provider.dart';
import 'package:capstone_dr_rice/screens/report/widgets/report_edit_mode.dart';
import 'package:capstone_dr_rice/screens/report/widgets/report_view_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/theme.dart';
import '../../models/disease.dart';
import '../../models/user_report.dart';
import 'your_reports_screen.dart';

// Define the enum for screen modes
enum ReportScreenMode { create, view, edit }

class ReportScreen extends StatefulWidget {
  final UserReport? existingReport;
  final ReportScreenMode mode;

  const ReportScreen({
    super.key,
    this.existingReport,
    this.mode = ReportScreenMode.create, // Default to creation mode
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  String? selectedImagePath;
  late DiseasePart selectedDiseasePart;
  late ReportScreenMode currentMode;

  @override
  void initState() {
    super.initState();
    // Initialize with existing data if available
    if (widget.existingReport != null) {
      nameController = TextEditingController(
        text: widget.existingReport!.disease.name,
      );
      descriptionController = TextEditingController(
        text: widget.existingReport!.disease.description,
      );
      selectedDiseasePart =
          widget.existingReport!.disease.affectedPart ?? DiseasePart.leaf;
      selectedImagePath = widget.existingReport!.imagePath;
    } else {
      nameController = TextEditingController();
      descriptionController = TextEditingController();
      selectedDiseasePart = DiseasePart.leaf;
    }

    // Set initial mode
    currentMode = widget.mode;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void onImageSelected(String? imagePath) {
    setState(() {
      selectedImagePath = imagePath;
    });
  }

  void toggleMode() {
    setState(() {
      // Toggle between view and edit modes
      currentMode =
          currentMode == ReportScreenMode.view
              ? ReportScreenMode.edit
              : ReportScreenMode.view;
    });
  }

  void onDiseasePartChanged(DiseasePart newPart) {
    setState(() {
      selectedDiseasePart = newPart;
    });
  }

  void submitReport() {
    final isComplete =
        selectedImagePath != null &&
        nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty;

    if (isComplete) {
      // Create or update disease
      final disease =
          widget.existingReport != null
              ? Disease(
                id: widget.existingReport!.disease.id,
                name: nameController.text,
                description: descriptionController.text,
                type: widget.existingReport!.disease.type,
                scanDate: widget.existingReport!.disease.scanDate,
                accuracy: widget.existingReport!.disease.accuracy,
                affectedPart: selectedDiseasePart,
              )
              : Disease(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameController.text,
                description: descriptionController.text,
                type: DiseaseType.fungal, // Default type
                scanDate: DateTime.now(),
                accuracy: 0.0, // Not applicable for user reports
                affectedPart: selectedDiseasePart,
              );

      // Create the report with the image path
      final report = UserReport(
        disease: disease,
        imagePath: selectedImagePath!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            currentMode == ReportScreenMode.create
                ? "Report submitted successfully!"
                : "Report updated successfully!",
          ),
        ),
      );

      // Add or update the report in the provider
      final reportProvider = Provider.of<ReportProvider>(
        context,
        listen: false,
      );
      if (currentMode == ReportScreenMode.create) {
        reportProvider.addReport(report);
      } else {
        reportProvider.updateReport(report);
      }

      // Navigate to YourReportsScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const YourReportsScreen(reports: []),
        ),
        (route) => route.isFirst, // Remove all previous routes
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all fields and select an image."),
        ),
      );
    }
  }

  String _getAppBarTitle() {
    switch (currentMode) {
      case ReportScreenMode.create:
        return "Report Disease";
      case ReportScreenMode.view:
        return "Report Details";
      case ReportScreenMode.edit:
        return "Edit Report";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RiceColors.backgroundAccent,
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(),
          style: RiceTextStyles.body.copyWith(color: RiceColors.neutralDark),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: RiceColors.neutralDark),
        actions:
            widget.existingReport != null
                ? [
                  IconButton(
                    icon: Icon(
                      currentMode == ReportScreenMode.view
                          ? Icons.edit
                          : Icons.visibility,
                      color: RiceColors.neutralDark,
                    ),
                    onPressed: toggleMode,
                  ),
                ]
                : null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(RiceSpacings.m),
          child:
              currentMode == ReportScreenMode.view
                  ? ReportViewMode(existingReport: widget.existingReport!)
                  : ReportEditMode(
                    selectedImagePath: selectedImagePath,
                    onImageSelected: onImageSelected,
                    nameController: nameController,
                    descriptionController: descriptionController,
                    selectedDiseasePart: selectedDiseasePart,
                    onDiseasePartChanged: onDiseasePartChanged,
                    submitReport: submitReport,
                    currentMode: currentMode,
                  ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
