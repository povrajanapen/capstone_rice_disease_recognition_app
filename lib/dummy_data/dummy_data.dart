// lib/data/dummy_data.dart

import '../models/diagnosis_model.dart';
import '../models/disease.dart';
import '../models/scan.dart';
import '../screens/home/widgets/news_slider.dart';

// Dummy slider content
final List<SlideContent> sliderContent = [
  SlideContent(
    image: 'assets/images/SCAN.png',
    title: 'Tell me phone, what\'s destroying my crops?',
    subtitle: 'Scan your rice plants to detect diseases early',
  ),
  SlideContent(
    image: 'assets/images/disease_thumbnail.jpg',
    title: 'Protect your rice yield',
    subtitle: 'Get instant diagnosis and treatment recommendations',
  ),
  SlideContent(
    image: 'assets/images/disease_thumbnail.jpg',
    title: 'Protect your rice yield',
    subtitle: 'Get instant diagnosis and treatment recommendations',
  ),
];


// Dummy diseases
final List<Disease> diseases = [
  Disease(
    id: 'd1',
    name: 'Bacterial Leaf Blight',
    description:
        'A serious bacterial disease causing yellowing and drying of leaves',
    type: DiseaseType.bacterial,
    scanDate: DateTime.now().subtract(const Duration(hours: 2)),
    accuracy: 0.95,
    affectedPart: DiseasePart.leaf,
  ),
  Disease(
    id: 'd2',
    name: 'Rice Blast',
    description: 'Fungal disease affecting leaves, nodes, and panicles',
    type: DiseaseType.fungal,
    scanDate: DateTime.now().subtract(const Duration(hours: 5)),
    accuracy: 0.92,
    affectedPart: DiseasePart.grain,
  ),
  Disease(
    id: 'd3',
    name: 'Brown Spot',
    description: 'Common fungal disease causing oval brown lesions',
    type: DiseaseType.fungal,
    scanDate: DateTime.now().subtract(const Duration(days: 1)),
    accuracy: 0.88,
    affectedPart: DiseasePart.leaf,
  ),
];

// Dummy diagnoses
final List<DiagnosisModel> recentDiagnoses = [
  DiagnosisModel(
    id: 'diag1',
    userId: 'user123',
    disease: diseases[0],
    scanDate: DateTime.now().subtract(const Duration(hours: 2)),
    imageUrl: 'assets/images/disease_thumbnail.jpg',
    isSaved: false,
  ),
  DiagnosisModel(
    id: 'diag2',
    userId: 'user123',
    disease: diseases[1],
    scanDate: DateTime.now().subtract(const Duration(hours: 5)),
    imageUrl: 'assets/images/disease_thumbnail.jpg',
    isSaved: true,
  ),
  DiagnosisModel(
    id: 'diag3',
    userId: 'user123',
    disease: diseases[2],
    scanDate: DateTime.now().subtract(const Duration(days: 1)),
    imageUrl: 'assets/images/disease_thumbnail.jpg',
    isSaved: false,
  ),
];

// Feature buttons data
final List<Map<String, String>> featureButtons = [
  {
    'title': 'Common Diseases',
    'icon': 'assets/icons/wheat_icon.png',
    'route': '/diseases',
  },
  {
    'title': 'Rice Scan',
    'icon': 'assets/icons/scan_icon.png',
    'route': '/scan',
  },
  {
    'title': 'Report Disease',
    'icon': 'assets/icons/report.png',
    'route': '/report',
  },
];

// Dummy data for disease results page
final List<Scan> dummyScans = [
  // Most recent scan - Rice Blast
  Scan(
    userId: 'user123',
    imageUrl: 'assets/images/rice_blast.jpg',
    scanDate: DateTime.now(),
    status: ScanStatus.completed,
    confidenceScore: 0.85,
    predictedDisease: Disease(
      id: 'd1',
      name: 'Rice Blast',
      description:
          'Rice blast is one of the most serious diseases of rice. Initial symptoms appear as white to gray-green lesions or spots with darker borders. Older lesions are elliptical or spindle-shaped and whitish to gray with necrotic borders.',
      type: DiseaseType.fungal,
      scanDate: DateTime.now(),
      accuracy: 0.85,
    ),
  ),

  // Pending scan
  Scan(
    userId: 'user123',
    imageUrl: 'assets/images/pending_scan.jpg',
    scanDate: DateTime.now().subtract(const Duration(hours: 2)),
    status: ScanStatus.pending,
    confidenceScore: 0.0,
    predictedDisease: null,
  ),

  // Brown Spot scan
  Scan(
    userId: 'user123',
    imageUrl: 'assets/images/brown_spot.jpg',
    scanDate: DateTime.now().subtract(const Duration(days: 1)),
    status: ScanStatus.completed,
    confidenceScore: 0.92,
    predictedDisease: Disease(
      id: 'd2',
      name: 'Brown Spot',
      description:
          'Brown spot disease produces brown lesions or spots with darker borders on the leaves. The spots are initially small and circular and may enlarge to oval or circular spots.',
      type: DiseaseType.fungal,
      scanDate: DateTime.now().subtract(const Duration(days: 1)),
      accuracy: 0.92,
    ),
  ),

  // Failed scan
  Scan(
    userId: 'user123',
    imageUrl: 'assets/images/failed_scan.jpg',
    scanDate: DateTime.now().subtract(const Duration(days: 2)),
    status: ScanStatus.failed,
    confidenceScore: 0.0,
    predictedDisease: null,
  ),

  // Bacterial Leaf Blight scan
  Scan(
    userId: 'user123',
    imageUrl: 'assets/images/bacterial_blight.jpg',
    scanDate: DateTime.now().subtract(const Duration(days: 3)),
    status: ScanStatus.completed,
    confidenceScore: 0.88,
    predictedDisease: Disease(
      id: 'd3',
      name: 'Bacterial Leaf Blight',
      description:
          'Bacterial leaf blight causes wilting of seedlings and yellowing and drying of leaves. The disease is characterized by water-soaked lesions that turn yellow and eventually white or gray.',
      type: DiseaseType.bacterial,
      scanDate: DateTime.now().subtract(const Duration(days: 3)),
      accuracy: 0.88,
    ),
  ),
];

// Saved diagnoses with additional information
final List<Map<String, dynamic>> savedDiagnoses = [
  {
    'diagnosis': DiagnosisModel(
      id: 'saved1',
      userId: 'user123',
      disease: Disease(
        id: 'd1',
        name: 'Rice Blast',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec tempus tincidunt dolor, sit amet euismod ante ornare dignissim. Nullam ex erat, rhoncus sed accumsan sit amet, consequat imperdiet sapien. Proin vel nibh id enim varius ultrices eu sagitt.',
        type: DiseaseType.fungal,
        scanDate: DateTime.now().subtract(const Duration(days: 2)),
        accuracy: 0.98,
      ),
      scanDate: DateTime.now().subtract(const Duration(days: 2)),
      imageUrl: 'assets/images/rice_blast.jpg',
      isSaved: true,
    ),
    'affectedPart': 'Leaf',
    'detectionAccuracy': 0.98,
    'isExpanded': false,
  },
  {
    'diagnosis': DiagnosisModel(
      id: 'saved2',
      userId: 'user123',
      disease: Disease(
        id: 'd2',
        name: 'Bacterial Leaf Blight',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec tempus tincidunt dolor, sit amet euismod ante ornare dignissim. Nullam ex erat, rhoncus sed accumsan sit amet, consequat imperdiet sapien.',
        type: DiseaseType.bacterial,
        scanDate: DateTime.now().subtract(const Duration(days: 4)),
        accuracy: 0.95,
      ),
      scanDate: DateTime.now().subtract(const Duration(days: 4)),
      imageUrl: 'assets/images/bacterial_blight.jpg',
      isSaved: true,
    ),
    'affectedPart': 'Leaf',
    'detectionAccuracy': 0.95,
    'isExpanded': false,
  },
  {
    'diagnosis': DiagnosisModel(
      id: 'saved3',
      userId: 'user123',
      disease: Disease(
        id: 'd3',
        name: 'Brown Spot',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec tempus tincidunt dolor, sit amet euismod ante ornare dignissim. Nullam ex erat, rhoncus sed accumsan sit amet.',
        type: DiseaseType.fungal,
        scanDate: DateTime.now().subtract(const Duration(days: 7)),
        accuracy: 0.92,
      ),
      scanDate: DateTime.now().subtract(const Duration(days: 7)),
      imageUrl: 'assets/images/brown_spot.jpg',
      isSaved: true,
    ),
    'affectedPart': 'Stem',
    'detectionAccuracy': 0.92,
    'isExpanded': false,
  },
  {
    'diagnosis': DiagnosisModel(
      id: 'saved4',
      userId: 'user123',
      disease: Disease(
        id: 'd4',
        name: 'Sheath Blight',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec tempus tincidunt dolor, sit amet euismod ante ornare dignissim. Nullam ex erat, rhoncus sed accumsan sit amet, consequat imperdiet sapien.',
        type: DiseaseType.fungal,
        scanDate: DateTime.now().subtract(const Duration(days: 10)),
        accuracy: 0.89,
      ),
      scanDate: DateTime.now().subtract(const Duration(days: 10)),
      imageUrl: 'assets/images/disease_thumbnail.jpg',
      isSaved: true,
    ),
    'affectedPart': 'Sheath',
    'detectionAccuracy': 0.89,
    'isExpanded': false,
  },
];
