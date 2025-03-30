// lib/data/datasources/disease_local_data_source.dart
import 'dart:developer' as developer;
import '../models/disease.dart';

class DiseaseLocalDataSource {
  // Default unknown disease to reuse
  static final Disease _unknownDisease = Disease(
    id: '-1',
    name: 'Unknown Disease',
    description: 'No information available for this condition.',
    type: DiseaseType.bacterial,
  );
  
  // Map class indices directly to diseases
  final Map<int, Disease> _diseaseMap = {
    0: Disease(
      id: '0',
      name: 'Bacterial Blight',
      description: 'Bacterial Blight is a serious disease of rice caused by Xanthomonas oryzae. '
          'Symptoms include water-soaked lesions that turn yellow and eventually dry up. '
          'It can cause significant yield loss in susceptible varieties.',
      type: DiseaseType.bacterial,
      affectedPart: DiseasePart.leaf,
    ),
    1: Disease(
      id: '1',
      name: 'Brown Spot',
      description: 'Brown Spot is caused by the fungus Cochliobolus miyabeanus. '
          'It appears as brown, oval-shaped spots on leaves and can affect grain quality. '
          'It\'s often associated with nutrient-deficient soils.',
      type: DiseaseType.fungal,
      affectedPart: DiseasePart.leaf,
    ),
    2: Disease(
      id: '2',
      name: 'Healthy',
      description: 'This plant appears healthy with no visible signs of disease. '
          'Continue with regular care and monitoring.',
      type: DiseaseType.bacterial,
      affectedPart: null,
    ),
    3: Disease(
      id: '3',
      name: 'Hispa',
      description: 'Rice Hispa is caused by the beetle Dicladispa armigera. '
          'Adults and grubs feed on leaf tissue, creating characteristic transparent patches. '
          'Severe infestations can reduce photosynthetic area significantly.',
      type: DiseaseType.parasitic,
      affectedPart: DiseasePart.leaf,
    ),
    4: Disease(
      id: '4',
      name: 'Leaf Blast',
      description: 'Leaf Blast is caused by the fungus Magnaporthe oryzae. '
          'It creates diamond-shaped lesions with gray centers and can affect all above-ground parts of the plant. '
          'It\'s one of the most destructive rice diseases worldwide.',
      type: DiseaseType.fungal,
      affectedPart: DiseasePart.leaf,
    ),
    5: Disease(
      id: '5',
      name: 'Sheath Blight',
      description: 'Sheath Blight is caused by Rhizoctonia solani. '
          'It appears as oval lesions on leaf sheaths that can expand and merge. '
          'The disease can spread to leaves and even panicles in severe cases.',
      type: DiseaseType.fungal,
      affectedPart: DiseasePart.stem,
    ),
    6: Disease(
      id: '6',
      name: 'Tungro',
      description: 'Rice Tungro Disease is caused by a combination of two viruses. '
          'Symptoms include yellow to orange discoloration, stunted growth, and reduced tillering. '
          'It\'s transmitted by green leafhoppers and can cause severe yield losses.',
      type: DiseaseType.viral,
      affectedPart: DiseasePart.leaf,
    ),
  };
  
  // Get all diseases as a list
  List<Disease> getAllDiseases() {
    return _diseaseMap.values.toList();
  }
  
  // Get disease by ID
  Disease getDiseaseById(String id) {
    try {
      return _diseaseMap.values.firstWhere((disease) => disease.id == id);
    } catch (e) {
      return _getUnknownDisease();
    }
  }
  
  // Get disease by class index (for ML model results)
  Disease getDiseaseByClassIndex(int classIndex) {
    // Add debugging
    developer.log('Requested disease with class index: $classIndex');
    developer.log('Available class indices: ${_diseaseMap.keys.toList().join(', ')}');
    
    if (_diseaseMap.containsKey(classIndex)) {
      developer.log('Found disease: ${_diseaseMap[classIndex]!.name}');
      return _diseaseMap[classIndex]!;
    } else {
      developer.log('Disease not found for class index: $classIndex');
      return _getUnknownDisease();
    }
  }
  
  // Create a disease record from scan results
  Disease createDiseaseFromScanResult(Map<String, dynamic> result) {
    final int classIndex = (result['class'] as int?) ?? -1;
    final double confidence = (result['confidence'] as double?) ?? 0.0;
    final String? imagePath = result['imagePath'] as String?;
    
    // Add debugging
    developer.log('Scan result: $result');
    developer.log('Class index: $classIndex, Confidence: $confidence');
    
    if (_diseaseMap.containsKey(classIndex)) {
      // Get the base disease information and add scan-specific details
      final baseDisease = _diseaseMap[classIndex]!;
      developer.log('Matched to disease: ${baseDisease.name}');
      
      return baseDisease.copyWith(
        scanDate: DateTime.now(),
        accuracy: confidence,
        imagePath: imagePath,
      );
    } else {
      developer.log('No matching disease found for class index: $classIndex');
      // Return unknown disease with scan details
      return _getUnknownDisease(
        customDescription: 'The scan result (class $classIndex) could not be matched to any known disease.',
        accuracy: confidence,
        imagePath: imagePath,
      );
    }
  }
  
  // Helper method to get an unknown disease with optional custom properties
  Disease _getUnknownDisease({
    String? customDescription,
    double? accuracy,
    String? imagePath,
  }) {
    return _unknownDisease.copyWith(
      description: customDescription ?? _unknownDisease.description,
      scanDate: DateTime.now(),
      accuracy: accuracy,
      imagePath: imagePath,
    );
  }
}