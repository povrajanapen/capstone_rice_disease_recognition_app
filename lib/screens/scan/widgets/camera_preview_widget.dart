import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPreviewWidget extends StatelessWidget {
  final bool isCameraReady;
  final CameraController? cameraController;

  const CameraPreviewWidget({
    super.key,
    required this.isCameraReady,
    this.cameraController
  });

  @override
  Widget build(BuildContext context) {
    return isCameraReady
        ? Container(
          color: Colors.black,
          child: Stack(
            children: [
              Center(child: CameraPreview(cameraController!)),
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
            ],
          ),
        )
        : Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
  }
}
