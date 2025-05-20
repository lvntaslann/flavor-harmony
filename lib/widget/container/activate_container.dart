import 'package:flutter/widgets.dart';

class ActivateContainer extends StatelessWidget {
  final Function() function;
const ActivateContainer({ Key? key, required this.function }) : super(key: key);

  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 20.0,
          right: 10.0,
          top: 10.0,
        ),
        width: size.width * 0.8,
        height: 185,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 218, 218, 218),
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage("assets/images/activity-add-note.png"),
          ),
        ),
      ),
    );
  }
}