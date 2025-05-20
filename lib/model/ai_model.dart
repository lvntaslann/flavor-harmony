import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tensorflow_lite_flutter/tensorflow_lite_flutter.dart';

class AiModel {
  late List<String> _foodClasses;

  AiModel() {
    init();
  }

  Future<void> init() async {
    await loadModel();
    await loadLabels();
  }

  Future<void> loadModel() async {
    try {
      // Load the model
      await Tflite.loadModel(
        model: 'assets/model/converted_model.tflite',
        labels: 'assets/model/labels.txt',
        isAsset: true,
        useGpuDelegate: false,
      );
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> loadLabels() async {
    try {
      // Load the labels
      final ByteData data = await rootBundle.load('assets/model/labels.txt');
      final List<String> labels =
          utf8.decode(data.buffer.asUint8List()).split('\n');
      _foodClasses = labels;
    } catch (e) {
      print('Error loading labels: $e');
    }
  }

  Future<String?> classifyFood(File imageFile) async {
    try {
      // Load the image and resize it to 224x224
      img.Image image = img.decodeImage(await imageFile.readAsBytes())!;
      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

      // Normalize the resized image
      Float32List normalizedImage = normalizeImage(resizedImage);

      // Classify the image using the model
      List<dynamic>? recognitions = await Tflite.runModelOnBinary(
        binary: normalizedImage.buffer.asUint8List(),
        numResults: 101,
        threshold: 0.4,
      );

      if (recognitions != null && recognitions.isNotEmpty) {
        return _foodClasses[recognitions[0]['index']];
      }
    } catch (e, stackTrace) {
      print('Error classifying food: $e');
      print('Stack trace: $stackTrace');
    }
    return null;
  }

  Future<void> detectObjects(String filepath) async {
    try {
      var recognitions = await Tflite.detectObjectOnImage(
        path: filepath,
        model: "SSDMobileNet",
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.4,
        numResultsPerClass: 101,
        asynch: true,
      );
      print(recognitions);
    } catch (e) {
      print('Error detecting objects: $e');
    }
  }

  Float32List normalizeImage(img.Image image) {
    List<double> normalizedPixels = [];

    // Iterate over each pixel in the image
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        // Get the pixel at the given coordinates
        img.Pixel pixel = image.getPixel(x, y);

        // Normalize each color component of the pixel (0-255 range) to (0-1 range)
        double normalizedRed = pixel.r / 255.0;
        double normalizedGreen = pixel.g / 255.0;
        double normalizedBlue = pixel.b / 255.0;

        // Add the normalized color components to the list
        normalizedPixels.add(normalizedRed);
        normalizedPixels.add(normalizedGreen);
        normalizedPixels.add(normalizedBlue);
      }
    }

    // Convert the list of normalized pixels to a Float32List
    return Float32List.fromList(normalizedPixels);
  }
}
