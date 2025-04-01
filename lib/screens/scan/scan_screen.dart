import 'package:capstone_dr_rice/screens/scan/result_screen.dart';
import 'package:capstone_dr_rice/service/disease_api_service.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'widgets/camera_preview_widget.dart';
import 'widgets/app_bar_widget.dart';
import 'widgets/bottom_controls_widget.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _cameraController;
  late Future<bool> _initializeCameraControllerFuture; // Changed to return bool
  // ignore: unused_field
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  final DiseaseApiService _apiService = DiseaseApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeCameraControllerFuture = _initializeCamera();
  }

  Future<bool> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        print('No cameras available (likely running on emulator)');
        return false; // Indicate failure due to no camera
      }
      final firstCamera = cameras.first;

      _cameraController = CameraController(firstCamera, ResolutionPreset.high);
      await _cameraController!.initialize();
      return true; // Indicate successful initialization
    } catch (e) {
      print('Error initializing camera: $e');
      return false; // Indicate failure
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Camera not available')));
      return;
    }

    try {
      setState(() => _isLoading = true);
      final image = await _cameraController!.takePicture();

      setState(() => _selectedImage = File(image.path));
      final result = await _apiService.predictDisease(image.path);

      setState(() => _isLoading = false);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    ResultScreen(imagePath: image.path, result: result),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _uploadAndPredict() async {
    try {
      setState(() => _isLoading = true);
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) {
        setState(() => _isLoading = false);
        return;
      }

      final result = await _apiService.predictDisease(pickedFile.path);
      setState(() => _isLoading = false);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    ResultScreen(imagePath: pickedFile.path, result: result),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _initializeCameraControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData &&
                snapshot.data == true &&
                _cameraController != null) {
              // Camera is initialized successfully
              return Stack(
                children: [
                  CameraPreviewWidget(
                    isCameraReady: snapshot.data!,
                    cameraController: _cameraController!),
                  const CustomAppBar(),
                  BottomControlsWidget(
                    isLoading: _isLoading,
                    onTakePicture: _takePicture,
                    onUpload: _uploadAndPredict,
                  ),
                ],
              );
            } else {
              // No camera available (e.g., emulator), show loading/placeholder
              return Stack(
                children: [
                  CameraPreviewWidget(isCameraReady: false),
                  const CustomAppBar(),
                  BottomControlsWidget(
                    isLoading: _isLoading,
                    onTakePicture: _takePicture, // Will show error message
                    onUpload: _uploadAndPredict, // Gallery upload still works
                  ),
                ],
              );
            }
          }
          // Show loading while initializing
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
