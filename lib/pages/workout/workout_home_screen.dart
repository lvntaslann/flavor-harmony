import 'package:flavor_harmony_app/pages/workout/add_note_screen.dart';

import 'package:flavor_harmony_app/pages/workout/stream_note.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WorkoutHomeScreen extends StatefulWidget {
  const WorkoutHomeScreen({Key? key}) : super(key: key);

  @override
  _WorkoutHomeScreenState createState() => _WorkoutHomeScreenState();
}

class _WorkoutHomeScreenState extends State<WorkoutHomeScreen> {
  bool show = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Notes"),
      ),
      floatingActionButton: Visibility(
        visible: show,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddNoteScreen()));
          },
          backgroundColor: Colors.purple,
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
      body: SafeArea(
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              setState(() {
                show = true;
              });
            }
            if (notification.direction == ScrollDirection.reverse) {
              setState(() {
                show = false;
              });
            }
            return true;
          },
          child: Column(
            children: [
              StreamNote(false),
              StreamNote(true),
            ],
          ),
        ),
      ),
    );
  }
}
