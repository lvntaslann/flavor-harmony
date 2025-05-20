import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;
const TitleText({ Key? key, required this.text }) : super(key: key);

  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 0, 0, 0),
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 218, 218, 218),
            borderRadius: BorderRadius.circular(5)),
        height: size.height * 0.08 - 31,
        width: size.width * 0.4 + 69,
        child: Stack(
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 67, 67, 67)),
            ),
          ],
        ),
      ),
    );
  }
}