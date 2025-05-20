import 'package:flutter/material.dart';

class InformationUser extends StatelessWidget {
  final String text;
const InformationUser({ Key? key, required this.text }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            color: Color.fromARGB(255, 67, 67, 67),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}