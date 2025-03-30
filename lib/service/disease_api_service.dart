import 'package:dio/dio.dart';

class DiseaseApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.0.225:5001',
      headers: {'Access-Control-Allow-Origin': '*'},
    ),
  );

  Future<Map<String, dynamic>> predictDisease(String imagePath) async {
    const String apiUrl = 'http://192.168.0.225:5001/predict';

    try {
      // Prepare the image file as a "multipart/form-data" request
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imagePath, filename: 'image.jpg'),
      });

      // Send the POST request
      Response response = await _dio.post(apiUrl, data: formData);

      // Return the JSON response
      return response.data;
    } on DioException catch (e) {
      // Handle errors
      throw Exception(
        'Failed to predict disease: ${e.response?.data ?? e.message}',
      );
    }
  }
}
