import 'package:flavor_harmony_app/services/note_services.dart';
import 'package:flavor_harmony_app/widget/workout/note_buttons.dart';
import 'package:flavor_harmony_app/widget/workout/note_images.dart';
import 'package:flavor_harmony_app/widget/workout/note_textfield.dart';
import 'package:flutter/material.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  int selectedIndex = 0;

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  Future<void> _addNote() async {
    String title = titleController.text;
    String subtitle = subtitleController.text;
    int image = selectedIndex;
    bool success = await NoteServices().addNote(
      subtitle,
      title,
      image,
    );

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note could not be added. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NoteTextField(
              controller: titleController,
              focusNode: _focusNode1,
              hintText: 'Title',
            ),
            SizedBox(height: 20),
            NoteTextField(
              controller: subtitleController,
              focusNode: _focusNode2,
              hintText: 'Subtitle',
              maxLines: 3,
            ),
            SizedBox(height: 20),
            NoteImages(
              selectedIndex: selectedIndex,
              onSelect: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            SizedBox(height: 20),
            NoteButtons(
              onAdd: _addNote,
              onCancel: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
