import 'dart:io';
import 'package:flutter/material.dart';
import '../../widgets/action/rice_button.dart';
import 'widgets/image_picker_widget.dart';
import '../../theme/theme.dart';
import '../../models/disease.dart';
import '../../models/user_report.dart';
import 'your_reports_screen.dart';

// Define the enum for screen modes
enum ReportScreenMode {
  create,
  view,
  edit,
}

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
      selectedDiseasePart = widget.existingReport!.disease.affectedPart ?? DiseasePart.leaf;
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
      currentMode = currentMode == ReportScreenMode.view 
          ? ReportScreenMode.edit 
          : ReportScreenMode.view;
    });
  }

  void submitReport() {
    final isComplete =
        selectedImagePath != null &&
        nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty;

    if (isComplete) {
      // Create or update disease
      final disease = widget.existingReport != null
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

      // If creating a new report, navigate to reports screen
      // If editing, just go back
      if (currentMode == ReportScreenMode.create) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => YourReportsScreen(
              reports: [report],
            ),
          ),
        );
      } else {
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all fields and select an image."),
        ),
      );
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
        actions: widget.existingReport != null
            ? [
                IconButton(
                  icon: Icon(
                    currentMode == ReportScreenMode.view ? Icons.edit : Icons.visibility,
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
          child: currentMode == ReportScreenMode.view
              ? _buildViewMode()
              : _buildEditMode(),
        ),
      ),
    );
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

  Widget _buildEditMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // If we have an image path, show the image
        selectedImagePath != null
            ? GestureDetector(
                onTap: () => onImageSelected(null), // Allow changing the image
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(RiceSpacings.radius),
                    image: DecorationImage(
                      image: FileImage(File(selectedImagePath!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: RiceColors.primary.withOpacity(0.7),
                        radius: 18,
                        child: IconButton(
                          icon: Icon(Icons.edit, color: RiceColors.white, size: 18),
                          onPressed: () => onImageSelected(null),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : ImagePickerWidget(onImageSelected: onImageSelected),
        SizedBox(height: RiceSpacings.m),
        _buildTextField(
          controller: nameController,
          label: "Name",
          hint: "Type here...",
        ),
        SizedBox(height: RiceSpacings.m),
        _buildTextField(
          controller: descriptionController,
          label: "Description",
          hint: "Type here...",
          maxLines: 3,
        ),
        SizedBox(height: RiceSpacings.m),
        _buildDropdownField(),
        SizedBox(height: RiceSpacings.xl),
        RiceButton(
          text: currentMode == ReportScreenMode.create ? "Submit" : "Update",
          icon: currentMode == ReportScreenMode.create ? Icons.upload : Icons.edit,
          onPressed: submitReport,
          type: RiceButtonType.primary,
        ),
      ],
    );
  }

  Widget _buildViewMode() {
    final report = widget.existingReport!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the actual image from the report
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RiceSpacings.radius),
            image: DecorationImage(
              image: FileImage(File(report.imagePath)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: RiceSpacings.m),
        
        // Disease name
        Text(
          report.disease.name,
          style: RiceTextStyles.heading.copyWith(
            color: RiceColors.neutralDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: RiceSpacings.s),
        
        // Disease part
        Row(
          children: [
            Icon(Icons.eco, color: RiceColors.primary, size: 20),
            SizedBox(width: RiceSpacings.s),
            Text(
              "Part of Disease: ${StringExtension(report.disease.affectedPart?.name ?? '').capitalize()}",
              style: RiceTextStyles.body.copyWith(
                color: RiceColors.neutral,
              ),
            ),
          ],
        ),
        SizedBox(height: RiceSpacings.m),
        
        // Description
        Text(
          report.disease.description,
          style: RiceTextStyles.body.copyWith(
            color: RiceColors.textNormal,
          ),
        ),
        
        // No accuracy display for user reports
      ],
    );
  }

  // text field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: RiceTextStyles.label.copyWith(fontSize: 14)),
        SizedBox(height: RiceSpacings.s/2),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: RiceColors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RiceSpacings.radius),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 0.75),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RiceSpacings.radius),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  // select disease dropdown
  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Disease Type",
          style: RiceTextStyles.label.copyWith(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        DropdownButtonFormField<DiseasePart>(
          value: selectedDiseasePart,
          items: DiseasePart.values.map((part) {
            return DropdownMenuItem<DiseasePart>(
              value: part,
              child: Row(
                children: [
                  Icon(Icons.eco, color: RiceColors.primary),
                  SizedBox(width: 8),
                  Text(
                    StringExtension(part.name).capitalize(),
                    style: RiceTextStyles.label.copyWith(fontSize: 16),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) => setState(() {
            selectedDiseasePart = value!;
          }),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: RiceColors.primary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: RiceColors.primary),
            ),
          ),
          dropdownColor: RiceColors.white,
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
