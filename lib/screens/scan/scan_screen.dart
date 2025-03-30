// import 'package:capstone_dr_rice/screens/scan/result_screen.dart';
// import 'package:capstone_dr_rice/service/disease_api_service.dart';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'widgets/camera_preview_widget.dart';
// import 'widgets/app_bar_widget.dart';
// import 'widgets/bottom_controls_widget.dart';

// class ScanScreen extends StatefulWidget {
//   const ScanScreen({super.key});

//   @override
//   State<ScanScreen> createState() => _ScanScreenState();
// }

// class _ScanScreenState extends State<ScanScreen> {
//   CameraController? _cameraController;
//   late Future<bool> _initializeCameraControllerFuture; // Changed to return bool
//   File? _selectedImage;
//   final ImagePicker _imagePicker = ImagePicker();
//   final DiseaseApiService _apiService = DiseaseApiService();
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCameraControllerFuture = _initializeCamera();
//   }

//   Future<bool> _initializeCamera() async {
//     try {
//       final cameras = await availableCameras();
//       if (cameras.isEmpty) {
//         print('No cameras available (likely running on emulator)');
//         return false; // Indicate failure due to no camera
//       }
//       final firstCamera = cameras.first;

//       _cameraController = CameraController(firstCamera, ResolutionPreset.high);
//       await _cameraController!.initialize();
//       return true; // Indicate successful initialization
//     } catch (e) {
//       print('Error initializing camera: $e');
//       return false; // Indicate failure
//     }
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     super.dispose();
//   }

//   Future<void> _takePicture() async {
//     if (_cameraController == null || !_cameraController!.value.isInitialized) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Camera not available')));
//       return;
//     }

//     try {
//       setState(() => _isLoading = true);
//       final image = await _cameraController!.takePicture();

//       setState(() => _selectedImage = File(image.path));
//       final result = await _apiService.predictDisease(image.path);

//       setState(() => _isLoading = false);

//       if (mounted) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder:
//                 (context) =>
//                     ResultScreen(imagePath: image.path, result: result),
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }

//   Future<void> _uploadAndPredict() async {
//     try {
//       setState(() => _isLoading = true);
//       final XFile? pickedFile = await _imagePicker.pickImage(
//         source: ImageSource.gallery,
//       );

//       if (pickedFile == null) {
//         setState(() => _isLoading = false);
//         return;
//       }

//       final result = await _apiService.predictDisease(pickedFile.path);
//       setState(() => _isLoading = false);

//       if (mounted) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder:
//                 (context) =>
//                     ResultScreen(imagePath: pickedFile.path, result: result),
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<bool>(
//         future: _initializeCameraControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             if (snapshot.hasData &&
//                 snapshot.data == true &&
//                 _cameraController != null) {
//               // Camera is initialized successfully
//               return Stack(
//                 children: [
//                   CameraPreviewWidget(
//                     isCameraReady: snapshot.data!,
//                     cameraController: _cameraController!),
//                   const CustomAppBar(),
//                   BottomControlsWidget(
//                     isLoading: _isLoading,
//                     onTakePicture: _takePicture,
//                     onUpload: _uploadAndPredict,
//                   ),
//                 ],
//               );
//             } else {
//               // No camera available (e.g., emulator), show loading/placeholder
//               return Stack(
//                 children: [
//                   CameraPreviewWidget(isCameraReady: false),
//                   const CustomAppBar(),
//                   BottomControlsWidget(
//                     isLoading: _isLoading,
//                     onTakePicture: _takePicture, // Will show error message
//                     onUpload: _uploadAndPredict, // Gallery upload still works
//                   ),
//                 ],
//               );
//             }
//           }
//           // Show loading while initializing
//           return const Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }

import 'package:capstone_dr_rice/screens/scan/result_screen.dart';
import 'package:capstone_dr_rice/service/disease_api_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker(); // Image picker
  final DiseaseApiService _apiService = DiseaseApiService(); // API service
  bool _isLoading = false;

  Future<void> _takePicture() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Pick an image from the camera
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );

      if (image == null) {
        setState(() {
          _isLoading = false;
        });
        return; // User canceled
      }

      setState(() {
        _selectedImage = File(image.path);
      });

      // Make the API call
      final result = await _apiService.predictDisease(image.path);

      // Navigate to ResultScreen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(imagePath: image.path, result: result),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _uploadAndPredict() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Pick an image from the gallery
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) {
        return; // User canceled
      }

      // Make the API call
      final result = await _apiService.predictDisease(pickedFile.path);

      // Navigate to ResultScreen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(imagePath: pickedFile.path, result: result),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(color: Colors.black),

          // Scan overlay
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // "Position object within frame" text
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                "Position object within frame",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                "Scan Rice",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Take Photo Button
                      GestureDetector(
                        onTap: _isLoading ? null : _takePicture,
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: Center(
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: _isLoading
                                  ? const Padding(
                                      padding: EdgeInsets.all(18.0),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Upload Button
                  GestureDetector(
                    onTap: _isLoading ? null : _uploadAndPredict,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.photo_library,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isLoading
                                ? "Processing..."
                                : "Upload from Gallery",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
