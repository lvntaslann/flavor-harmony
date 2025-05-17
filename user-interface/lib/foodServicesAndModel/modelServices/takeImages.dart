import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TakeImages extends StatelessWidget {
  final Function(File) onImageSelected; // onImageSelected parametresi eklendi

  const TakeImages({Key? key, required this.onImageSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.camera_alt),
      onPressed: () {
        _showImageSourceOptions(context);
      },
    );
  }

  Future<void> _showImageSourceOptions(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Take a photo"),
                onTap: () async {
                  Navigator.pop(context);
                  await _getImageFromCamera(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Select from galery"),
                onTap: () async {
                  Navigator.pop(context);
                  await _getImageFromGallery(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImageFromCamera(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _processImage(context, pickedFile);
  }

  Future<void> _getImageFromGallery(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _processImage(context, pickedFile);
  }

  void _processImage(BuildContext context, XFile? pickedFile) {
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      onImageSelected(
          imageFile); // Seçilen resmi iletmek için callback kullanılıyor
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resim seçilmedi')),
      );
    }
  }
}
