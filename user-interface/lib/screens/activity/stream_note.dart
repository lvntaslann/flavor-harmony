import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flavor_harmony_app/screens/activity/task_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flavor_harmony_app/screens/activity/firestor.dart';

class StreamNote extends StatelessWidget {
  final bool done;

  StreamNote(this.done, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreDatasource().stream(done),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('An error occurred: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Lets add the event!'));
        }

        final notelist = FirestoreDatasource().getNotes(snapshot.data!);
        return ListView.builder(
          shrinkWrap: true,
          itemCount: notelist.length,
          itemBuilder: (context, index) {
            final note = notelist[index];
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                FirestoreDatasource().deleteNote(note.id);
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: TaskWidgets(note),
            );
          },
        );
      },
    );
  }
}
