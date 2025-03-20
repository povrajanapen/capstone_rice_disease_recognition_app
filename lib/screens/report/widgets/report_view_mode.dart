import 'dart:io';
import 'package:capstone_dr_rice/models/user_report.dart';
import 'package:capstone_dr_rice/screens/report/report_screen.dart';
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:capstone_dr_rice/widgets/display/rice_divider.dart';
import 'package:flutter/material.dart';

class ReportViewMode extends StatelessWidget {
  final UserReport existingReport;
  const ReportViewMode({super.key, required this.existingReport});

  @override
  Widget build(BuildContext context) {
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
              image: FileImage(File(existingReport.imagePath)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: RiceSpacings.m),

        // Disease name
        Text(
          existingReport.disease.name,
          style: RiceTextStyles.heading.copyWith(
            color: RiceColors.neutralDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Disease part
        Row(
          children: [
            Icon(Icons.eco, color: RiceColors.neutral, size: 16),
            SizedBox(width: RiceSpacings.s / 2),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Part of Disease: ",
                    style: RiceTextStyles.label.copyWith(
                      fontSize: 14,
                      color: RiceColors.neutral,
                      fontWeight: FontWeight.bold, // Make this part bold
                    ),
                  ),
                  TextSpan(
                    text:
                        (existingReport.disease.affectedPart?.name ?? '')
                            .capitalize(),
                    style: RiceTextStyles.label.copyWith(
                      fontSize: 14,
                      color: RiceColors.neutral,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: RiceSpacings.m),
        RiceDivider(),
        SizedBox(height: RiceSpacings.s),
        // Description
        Text(
          "Description",
          style: RiceTextStyles.body.copyWith(color: RiceColors.neutralDark),
        ),
        SizedBox(height: RiceSpacings.s),
        Text(
          existingReport.disease.description,
          style: RiceTextStyles.label.copyWith(
            fontSize: 14,
            color: RiceColors.textNormal,
          ),
        ),
        // No accuracy display for user reports
      ],
    );
  }
}
