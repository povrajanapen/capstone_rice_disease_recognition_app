

import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:capstone_dr_rice/screens/scan/result_screen.dart';
import 'package:capstone_dr_rice/service/disease_api_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'widgets/camera_preview_widget.dart';
import 'widgets/app_bar_widget.dart';
import 'widgets/bottom_controls_widget.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  final DiseaseApiService _apiService = DiseaseApiService();
  bool _isLoading = false;

  Future<void> _pickAndPredict(ImageSource source) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final XFile? image = await _imagePicker.pickImage(source: source);

      if (image == null) {
        setState(() {
          _isLoading = false;
        });
        return; // User canceled
      }

      setState(() {
        _selectedImage = File(image.path);
      });

      final result = await _apiService.predictDisease(image.path);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(imagePath: image.path, result: result),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _takePicture() => _pickAndPredict(ImageSource.camera);

  Future<void> _uploadAndPredict() => _pickAndPredict(ImageSource.gallery);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.black),
          const ScanOverlayWidget(),
          ScanAppBarWidget(languageProvider: languageProvider),
          ScanBottomControlsWidget(
            isLoading: _isLoading,
            onTakePicture: _takePicture,
            onUpload: _uploadAndPredict,
            languageProvider: languageProvider,
          ),
        ],
      ),
    );
  }
}