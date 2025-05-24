import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final String imageName;
  const ImageContainer({Key? key, required this.imageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage("assets/images/$imageName.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
