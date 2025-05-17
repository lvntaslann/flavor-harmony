import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    Key? key,
    required this.size,
    required this.screen,
  }) : super(key: key);

  final Size size;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Burada bir sonraki ekrana geçiş işlemini gerçekleştirebilirsiniz.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0, bottom: 20),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            width: size.width * 0.4,
            height: size.height * 0.078,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 45, 45, 45),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: ListTile(
                  title: Text(
                    'Next',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20),
                  ),
                  trailing: Icon(Icons.arrow_forward,
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
