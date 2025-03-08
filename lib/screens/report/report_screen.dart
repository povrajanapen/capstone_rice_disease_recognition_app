import 'package:flutter/material.dart';
import '../../widgets/action/rice_button.dart';
import 'widgets/file_picker_widget.dart';
import '../../theme/theme.dart';
import '../../models/disease.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? selectedFilePath;
  DiseasePart selectedDiseasePart = DiseasePart.leaf;

  void onFileSelected(String? filePath) {
    setState(() {
      selectedFilePath = filePath;
    });
  }

  void submitReport() {
    if (selectedFilePath != null &&
        nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Report submitted successfully!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields and select a file.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RiceColors.backgroundAccent,
      appBar: AppBar(
        title: Text(
          "Report Disease",
          style: RiceTextStyles.body.copyWith(color: RiceColors.neutralDark),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: RiceColors.neutralDark),
      ),
      body: Padding(
        padding: const EdgeInsets.all(RiceSpacings.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilePickerWidget(onFileSelected: onFileSelected),
            SizedBox(height: RiceSpacings.m),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name",
                  style: RiceTextStyles.label.copyWith(
                    fontSize: 16,
                  ), // Increased font size
                ),
                SizedBox(height: RiceSpacings.s),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Type here...",
                    filled: true,
                    fillColor: RiceColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(RiceSpacings.radius),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: RiceSpacings.m),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Description",
                  style: RiceTextStyles.label.copyWith(
                    fontSize: 16,
                  ), // Increased font size
                ),
                SizedBox(height: RiceSpacings.s),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Type here...",
                    filled: true,
                    fillColor: RiceColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(RiceSpacings.radius),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: RiceSpacings.m),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Disease Type",
                  style: RiceTextStyles.label.copyWith(
                    fontSize: 16,
                  ), // Increased font size
                ),
                SizedBox(height: RiceSpacings.s),
                DropdownButtonFormField<DiseasePart>(
                  value: selectedDiseasePart,
                  items:
                      DiseasePart.values.map((DiseasePart part) {
                        return DropdownMenuItem<DiseasePart>(
                          value: part,
                          child: Row(
                            children: [
                              Icon(Icons.eco, color: RiceColors.primary),
                              SizedBox(width: 8),
                              Text(
                                part.name.capitalize(),
                                style: RiceTextStyles.body.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDiseasePart = value!;
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: RiceColors.primary),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: RiceColors.primary),
                    ),
                  ),
                  dropdownColor: RiceColors.white,
                  selectedItemBuilder: (BuildContext context) {
                    return DiseasePart.values.map<Widget>((DiseasePart part) {
                      return Row(
                        children: [
                          Icon(Icons.eco, color: RiceColors.primary),
                          SizedBox(width: 8),
                          Text(
                            part.name.capitalize(),
                            style: RiceTextStyles.body.copyWith(fontSize: 18),
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            SizedBox(height: RiceSpacings.xl),
            RiceButton(
              text: "Submit",
              icon: Icons.upload,
              onPressed: submitReport,
              type: RiceButtonType.primary,
            ),
          ],
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
