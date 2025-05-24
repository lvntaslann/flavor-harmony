import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/image_picker_service.dart';

class TakeImages extends StatelessWidget {
  final Function(File) onImageSelected;

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
    final imagePickerService = Provider.of<ImagePickerService>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Select Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Take a photo"),
                onTap: () async {
                  Navigator.pop(dialogContext);
                  await imagePickerService.pickImage(context, ImageSource.camera);
                  final image = imagePickerService.selectedImage;
                  if (image != null) {
                    onImageSelected(image);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Select from gallery"),
                onTap: () async {
                  Navigator.pop(dialogContext);
                  await imagePickerService.pickImage(context, ImageSource.gallery);
                  final image = imagePickerService.selectedImage;
                  if (image != null) {
                    onImageSelected(image);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
