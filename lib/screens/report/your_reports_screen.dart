import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/user_report.dart';
import '../../theme/theme.dart';
import 'report_screen.dart';

class YourReportsScreen extends StatelessWidget {
  final List<UserReport> reports;

  const YourReportsScreen({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RiceColors.backgroundAccent,
      appBar: AppBar(
        backgroundColor: RiceColors.backgroundAccent,
        elevation: 0,
        title: Text(
          "Your Reports",
          style: RiceTextStyles.body.copyWith(
            color: RiceColors.neutralDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: RiceColors.neutralDark),
          onPressed:
              () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),

      body:
          reports.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: RiceSpacings.m),
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return _buildReportCard(context, report);
                },
              ),
    );
  }

  Widget _buildReportCard(BuildContext context, UserReport report) {
    return GestureDetector(
      onTap: () async{
        final updatedReport = await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ReportScreen(
                  existingReport: report,
                  mode: ReportScreenMode.view,
                ),
          ),
        );
        if (updatedReport != null) {
          // Find the index of the existing report
          int index = reports.indexWhere(
            (r) => r.disease.id == updatedReport.disease.id,
          );

          if (index != -1) {
            reports[index] = updatedReport; // Update the list
          }

          // Trigger a UI refresh
          (context as Element).markNeedsBuild();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: RiceSpacings.s,
          horizontal: RiceSpacings.m,
        ),
        decoration: BoxDecoration(
          color: RiceColors.neutralLighter,
          borderRadius: BorderRadius.circular(RiceSpacings.radiusLarge),
          border: Border.fromBorderSide(
            BorderSide(color: RiceColors.neutral, width: 0.5),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(RiceSpacings.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Disease image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(RiceSpacings.radius),
                    child: Image.file(
                      File(report.imagePath),
                      width: 85,
                      height: 85,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: RiceSpacings.m),

                  // Disease details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.disease.name,
                          style: RiceTextStyles.button.copyWith(
                            color: RiceColors.neutralDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Affected Part
                        SizedBox(height: 5),
                        if (report.disease.affectedPart != null)
                          Row(
                            children: [
                              Text(
                                'Part of Disease: ',
                                style: RiceTextStyles.label.copyWith(
                                  color: RiceColors.neutral,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                StringExtension(
                                  report.disease.affectedPart!.name,
                                ).capitalize(),
                                style: RiceTextStyles.label.copyWith(
                                  color: RiceColors.neutral,
                                ),
                              ),
                            ],
                          ),

                        // Description
                        SizedBox(height: RiceSpacings.s),
                        Text(
                          report.disease.description,
                          style: RiceTextStyles.label.copyWith(
                            color: RiceColors.textNormal,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: 64, color: RiceColors.neutral),
          SizedBox(height: RiceSpacings.m),
          Text(
            "No reports yet",
            style: RiceTextStyles.body.copyWith(
              color: RiceColors.neutralDark,
              fontSize: 18,
            ),
          ),
          SizedBox(height: RiceSpacings.s),
          Text(
            "Your submitted reports will appear here",
            style: RiceTextStyles.label.copyWith(color: RiceColors.neutral),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
