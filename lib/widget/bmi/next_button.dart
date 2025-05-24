import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    Key? key,
    required this.size,
    required this.screen,
    this.age,
    this.weight,
    this.height,
    this.gender,
  }) : super(key: key);

  final Size size;
  final Widget screen;
  final int? age;
  final int? weight;
  final int? height;
  final String? gender;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
