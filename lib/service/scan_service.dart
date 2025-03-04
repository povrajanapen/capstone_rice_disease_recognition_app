//// Helper function to get the latest successful scan
import '../dummy_data/dummy_data.dart';
import '../models/disease.dart';
import '../models/scan.dart';

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