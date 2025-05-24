import 'package:flutter/material.dart';
import 'package:flavor_harmony_app/pages/workout/edit_screen.dart';
import 'package:flavor_harmony_app/model/note_model.dart';

class EditButton extends StatelessWidget {
  final Note note;
  final VoidCallback? onTap;
  const EditButton({Key? key, required this.note, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditScreen(note),
              ),
            );
          },
      child: Container(
        width: 90,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Edit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
