import 'package:flutter/material.dart';

class NoteButtons extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onCancel;
  const NoteButtons({Key? key, required this.onAdd, required this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(170, 48),
            backgroundColor: Color.fromARGB(255, 34, 0, 114),
          ),
          onPressed: onAdd,
          child: Text(
            'Add Note',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(170, 48),
            backgroundColor: Colors.red,
          ),
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
