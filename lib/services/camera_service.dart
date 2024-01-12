import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraService {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.max,
        enableAudio: false,
      );
      await _cameraController!.initialize();
    } else {
      throw Exception("No cameras found");
    }
  }

  CameraController? get cameraController => _cameraController;

  Future<void> disposeCamera() async {
    await _cameraController?.dispose();
    _cameraController = null;
  }

  Future<XFile?> takePicture() async {
    if (!_cameraController!.value.isInitialized) {
      return null;
    }

    final XFile? picture = await _cameraController!.takePicture();

    return picture;
  }
}