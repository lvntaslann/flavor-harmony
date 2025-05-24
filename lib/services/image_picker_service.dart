import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService with ChangeNotifier {
  File? _selectedImage;

  File? get selectedImage => _selectedImage;

  Future<void> pickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resim seçilmedi')),
      );
    }
  }

  void clearImage() {
    _selectedImage = null;
    notifyListeners();
  }
}
