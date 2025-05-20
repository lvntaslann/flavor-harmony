import 'package:flutter/material.dart';

class MealContainer extends StatelessWidget {
  final String image;
  final String title;
  final Function() press;
const MealContainer({ Key? key, required this.image, required this.title, required this.press }) : super(key: key);

  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        press();
      },
      child: Container(
        color: Color.fromARGB(255, 218, 218, 218),
        margin: EdgeInsets.only(left: 20.0, right: 10.0, bottom: 50.0, top: 7),
        width: size.width * 0.6,
        child: Column(
          children: <Widget>[
            Image.asset(image),
            GestureDetector(
              onTap: () {
                press();
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.amber,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 15),
                          blurRadius: 10,
                          color:
                              Color.fromARGB(255, 34, 0, 114).withOpacity(0.2))
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: title.toUpperCase(),
                          style: Theme.of(context).textTheme.titleMedium),
                    ]))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}