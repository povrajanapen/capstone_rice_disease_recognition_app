
import 'dart:io';
import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:capstone_dr_rice/provider/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_report.dart';
import '../../theme/theme.dart';
import 'report_screen.dart';

class YourReportsScreen extends StatelessWidget {
  final List<UserReport> reports;
  const YourReportsScreen({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    final reports = reportProvider.reports;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: RiceColors.backgroundAccent,
      appBar: AppBar(
        backgroundColor: RiceColors.backgroundAccent,
        elevation: 0,
        title: Text(
          languageProvider.translate("Your Reports"),
          style: RiceTextStyles.body.copyWith(
            color: RiceColors.neutralDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: RiceColors.neutralDark),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
      body: reports.isEmpty
          ? _buildEmptyState(languageProvider)
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: RiceSpacings.m),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return _buildReportCard(context, report, reportProvider, languageProvider);
              },
            ),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    UserReport report,
    ReportProvider reportProvider,
    LanguageProvider languageProvider,
  ) {
    return GestureDetector(
      onTap: () async {
        final updatedReport = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportScreen(
              existingReport: report,
              mode: ReportScreenMode.view,
            ),
          ),
        );
        if (updatedReport != null) {
          reportProvider.updateReport(updatedReport);
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
                        SizedBox(height: 5),
                        if (report.disease.affectedPart != null)
                          _buildTextRow(
                            languageProvider.translate('Part of Disease'),
                            languageProvider.translate(report.disease.affectedPart!.name),
                          ),
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
                  IconButton(
                    icon: Icon(Icons.delete, color: RiceColors.red),
                    onPressed: () {
                      _confirmDelete(context, report, reportProvider, languageProvider);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    UserReport report,
    ReportProvider reportProvider,
    LanguageProvider languageProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          languageProvider.translate("Delete Report"),
          style: RiceTextStyles.body.copyWith(
            color: RiceColors.neutralDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          languageProvider.translate("Are you sure you want to delete this report"),
          style: RiceTextStyles.label.copyWith(
            fontSize: 16,
            color: RiceColors.neutralDark,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              languageProvider.translate("Cancel"),
              style: RiceTextStyles.button.copyWith(
                fontSize: 18,
                color: RiceColors.neutralDark,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              reportProvider.deleteReport(report.disease.id);
              Navigator.pop(context);
            },
            child: Text(
              languageProvider.translate("Delete"),
              style: RiceTextStyles.button.copyWith(
                fontSize: 18,
                color: RiceColors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(LanguageProvider languageProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: 64, color: RiceColors.neutral),
          SizedBox(height: RiceSpacings.m),
          Text(
            languageProvider.translate("No reports yet"),
            style: RiceTextStyles.body.copyWith(
              color: RiceColors.neutralDark,
              fontSize: 18,
            ),
          ),
          SizedBox(height: RiceSpacings.s),
          Text(
            languageProvider.translate("Your submitted reports will appear here"),
            style: RiceTextStyles.label.copyWith(color: RiceColors.neutral),
          ),
        ],
      ),
    );
  }

  Widget _buildTextRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: RiceTextStyles.label.copyWith(
            color: RiceColors.neutral,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: RiceTextStyles.label.copyWith(
            color: RiceColors.neutral,
          ),
        ),
      ],
    );
  }
}

