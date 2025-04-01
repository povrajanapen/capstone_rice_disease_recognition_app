import 'package:capstone_dr_rice/models/disease.dart';
import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:capstone_dr_rice/screens/report/report_screen.dart' as report;
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DiseaseTypeDropdown extends StatelessWidget {
  final DiseasePart selectedDiseasePart;
  final ValueChanged<DiseasePart> onChanged;

  const DiseaseTypeDropdown({
    super.key,
    required this.selectedDiseasePart,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageProvider.translate("Select Disease Type"),
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
                  languageProvider.translate(report.StringExtension(part.name).capitalize()),
                    style: RiceTextStyles.label.copyWith(fontSize: 16),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
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
        ),
      ],
    );
  }
}
