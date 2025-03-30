import 'package:flutter/material.dart';
import '../../models/user_report.dart';

class ReportProvider extends ChangeNotifier {
  final List<UserReport> _reports = [];

  List<UserReport> get reports => List.unmodifiable(_reports);

  void addReport(UserReport report) {
    _reports.add(report);
    notifyListeners();
  }

  void updateReport(UserReport updatedReport) {
    final index = _reports.indexWhere((r) => r.disease.id == updatedReport.disease.id);
    if (index != -1) {
      _reports[index] = updatedReport;
      notifyListeners();
    }
  }

  void deleteReport(String reportId) {
    _reports.removeWhere((r) => r.disease.id == reportId);
    notifyListeners();
  }

  void setReports(List<UserReport> reports) {
    _reports.clear();
    _reports.addAll(reports);
    notifyListeners();
  }
}