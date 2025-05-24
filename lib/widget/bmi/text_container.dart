import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TextContainer extends StatelessWidget {
  const TextContainer({
    Key? key,
    required this.size,
    required this.text,
    required this.lottieAnimationLink,
  }) : super(key: key);

  final Size size;
  final String text;
  final String lottieAnimationLink;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: size.height * 0.35,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        color: Color.fromARGB(255, 31, 31, 31),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.07,
              ),
              Center(
                child: Lottie.network(
                  lottieAnimationLink,
                  height: size.height * 0.25,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 45),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                '$text...',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
