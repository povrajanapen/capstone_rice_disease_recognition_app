import 'dart:io';
import 'package:capstone_dr_rice/models/disease.dart';
import 'package:capstone_dr_rice/screens/report/report_screen.dart';
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:capstone_dr_rice/widgets/action/rice_button.dart';
import 'package:flutter/material.dart';
import 'image_picker_widget.dart';
import 'disease_type_dropdown.dart';
import '../../../widgets/input/textfield_input.dart';

class ReportEditMode extends StatelessWidget {
  final String? selectedImagePath;
  final Function(String?) onImageSelected;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final DiseasePart selectedDiseasePart;
  final Function(DiseasePart) onDiseasePartChanged;
  final Function submitReport;
  final ReportScreenMode currentMode;

  const ReportEditMode({
    super.key,
    required this.selectedImagePath,
    required this.onImageSelected,
    required this.nameController,
    required this.descriptionController,
    required this.selectedDiseasePart,
    required this.onDiseasePartChanged,
    required this.submitReport,
    required this.currentMode,
  });

  @override
  Widget build(BuildContext context) {
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
                        icon: Icon(
                          Icons.edit,
                          color: RiceColors.white,
                          size: 18,
                        ),
                        onPressed: () => onImageSelected(null),
                      ),
                    ),
                  ),
                ),
              ),
            )
            : ImagePickerWidget(onImageSelected: onImageSelected),

        SizedBox(height: RiceSpacings.m),

        // disease name input
        TextfieldInput(
          controller: nameController,
          label: "Name",
          hint: "Type here...",
        ),

        // description input
        SizedBox(height: RiceSpacings.m),
        TextfieldInput(
          controller: descriptionController,
          label: "Description",
          hint: "Type here...",
          maxLines: 3,
        ),
        SizedBox(height: RiceSpacings.m),

        // Disease part dropdown
        DiseaseTypeDropdown(
          selectedDiseasePart: selectedDiseasePart,
          onChanged: (value) => onDiseasePartChanged(value),
        ),

        // submit button
        SizedBox(height: RiceSpacings.xl),
        RiceButton(
          text: currentMode == ReportScreenMode.create ? "Submit" : "Update",
          icon:
              currentMode == ReportScreenMode.create
                  ? Icons.upload
                  : Icons.edit,
          onPressed: () => submitReport(),
          type: RiceButtonType.primary,
        ),
      ],
    );
  }
}
