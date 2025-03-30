//// Helper function to get the latest successful scan
library;
import '../models/disease.dart';
import '../models/scan.dart';

List<Scan> dummyScans = [];

Scan? getLatestSuccessfulScan() {
  return dummyScans.firstWhere(
    (scan) => scan.status == ScanStatus.completed,
    orElse: () => dummyScans[0],
  );
}

// Helper function to get scans by status
List<Scan> getScansByStatus(ScanStatus status) {
  return dummyScans.where((scan) => scan.status == status).toList();
}

// Helper function to get scans by disease type
List<Scan> getScansByDiseaseType(DiseaseType type) {
  return dummyScans.where(
    (scan) => scan.predictedDisease?.type == type
  ).toList();
}